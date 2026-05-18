// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.util.Log
import com.sun.mail.smtp.SMTPAddressFailedException
import com.sun.mail.smtp.SMTPSendFailedException
import com.sun.mail.smtp.SMTPSenderFailedException
import jakarta.mail.Authenticator
import jakarta.mail.AuthenticationFailedException
import jakarta.mail.Message
import jakarta.mail.MessagingException
import jakarta.mail.PasswordAuthentication
import jakarta.mail.SendFailedException
import jakarta.mail.Session
import jakarta.mail.Transport
import jakarta.mail.internet.InternetAddress
import jakarta.mail.internet.MimeMessage
import java.net.ConnectException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import java.util.Properties
import java.util.concurrent.TimeUnit
import okhttp3.FormBody
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONObject

object SendProviderId {
    const val TELEGRAM_BOT = "telegram_bot"
    const val SMTP_SERVER = "smtp_server"
}

data class SendProviderPayload(
    val sender: String,
    val body: String,
    val receivedAt: Long,
    val labels: Map<String, String>
)

data class SendProviderResult(
    val isSuccess: Boolean,
    val code: String,
    val info: String, // not for UI (logging only)
    val shouldRetry: Boolean = false
) {
    fun toMap(): Map<String, Any> {
        return mapOf(
            "isSuccess" to isSuccess,
            "code" to code,
            "info" to info,
            "shouldRetry" to shouldRetry
        )
    }
}

interface SendProvider {
    val id: String
    fun send(configJson: String, secret: String, type: String, payload: SendProviderPayload): SendProviderResult

    // Universal factory for creating SendProviderResult and logging
    fun buildResult(
        isSuccess: Boolean,
        code: String,
        info: String,
        shouldRetry: Boolean = false,
        details: String? = null,
        exception: Throwable? = null
    ): SendProviderResult {
        val type = if (isSuccess) "send_success" else "send_error"
        val infoStr = LogFormatter.buildInfo(type, info, id, code, details ?: exception?.message)

        // Log
        if (isSuccess) Log.i("SendProvider", infoStr)
        else Log.e("SendProvider", infoStr, exception)

        // Return object for worker and UI
        return SendProviderResult(isSuccess, code, infoStr, shouldRetry)
    }
}

object SendProviderGateway {
    private val providers: Map<String, SendProvider> = listOf(
        TelegramBotProvider,
        SmtpServerProvider
    ).associateBy { it.id }

    fun send(
        providerId: String,
        configJson: String,
        secret: String,
        type: String,
        payload: SendProviderPayload
    ): SendProviderResult {
        val provider = providers[providerId.lowercase()]
            ?: return SendProviderResult(
                isSuccess = false,
                code = ResultCode.UNEXPECTED_ERROR,
                info = "Unknown provider: $providerId"
            )
        return provider.send(configJson, secret, type, payload)
    }
}

// ================================================================================
// TELEGRAM BOT PROVIDER
// ================================================================================

object TelegramBotProvider : SendProvider {
    override val id: String = SendProviderId.TELEGRAM_BOT

    override fun send(configJson: String, secret: String, type: String, payload: SendProviderPayload): SendProviderResult {
        if (configJson.isBlank()) {
            return buildResult(
                isSuccess = false,
                code = ResultCode.INVALID_PARAMS,
                info = "Bot connection data is empty"
            )
        }

        return try {
            val json = JSONObject(configJson)
            val token = secret
            val chatId = json.optString("chatId", "")
            val apiUrl = json.optString("apiUrl", "").ifBlank { "https://api.telegram.org" }
            if (token.isBlank() || chatId.isBlank()) {
                return buildResult(
                    isSuccess = false,
                    code = ResultCode.INVALID_PARAMS,
                    info = "Bot token and chat ID are required"
                )
            }

            val msg = MessageHelpers.format(
                provider = id,
                type = type,
                sender = payload.sender,
                body = payload.body,
                receivedAt = payload.receivedAt,
                labels = payload.labels,
            )
            val result = sendRequest(token, chatId, apiUrl, msg.text)
            mapApiResult(result)
        } catch (e: Exception) {
            buildResult(
                isSuccess = false,
                code = ResultCode.UNEXPECTED_ERROR,
                info = e.message ?: "Unexpected error",
                exception = e
            )
        }
    }

    private fun sendRequest(
        token: String,
        chatId: String,
        apiUrl: String,
        msg: String
    ): ApiResult {
        val requestBody = FormBody.Builder()
            .add("chat_id", chatId)
            .add("text", msg)
            .add("parse_mode", "HTML")
            .build()

        val request = Request.Builder()
            .url("$apiUrl/bot$token/sendMessage")
            .post(requestBody)
            .build()

        return try {
            httpClient.newCall(request).execute().use { response ->
                // Read and parse Telegram JSON body to get description text
                val bodyText = response.body?.string()
                val payload = parseResponseBody(bodyText)
                ApiResult(
                    statusCode = response.code,
                    ok = payload.ok,
                    errorCode = payload.errorCode,
                    description = payload.description
                )
            }
        } catch (e: Exception) {
            ApiResult(error = e)
        }
    }

    private fun mapApiResult(result: ApiResult): SendProviderResult {
        // Prefer Telegram "ok=true", but keep HTTP 200 fallback for malformed/missing body
        if (result.ok == true || (result.statusCode == 200 && result.errorCode == null)) {
            return buildResult(isSuccess = true, code = ResultCode.OK, info = "Sent successfully")
        }

        if (result.error != null) {
            val rootCause = result.error.cause ?: result.error
            val code = when {
                rootCause is SocketTimeoutException || result.error is SocketTimeoutException -> 
                    ResultCode.NETWORK_TIMEOUT
                rootCause is UnknownHostException || rootCause is ConnectException || 
                result.error is UnknownHostException || result.error is ConnectException -> 
                    ResultCode.NETWORK_ERROR
                else -> ResultCode.NETWORK_ERROR
            }
            return buildResult(
                isSuccess = false,
                code = code,
                info = result.error.message ?: "Telegram network error",
                shouldRetry = true // transport-level failures are retryable
            )
        }

        // Get specific Telegram API description for the error code
        if (result.errorCode != null) {
            val info = result.description ?: "Telegram API error ${result.errorCode}"
            val mappedCode = mapErrorCode(result.errorCode)
            return buildResult(
                isSuccess = false,
                code = mappedCode,
                info = info,
                shouldRetry = isRetryable(mappedCode)
            )
        }

        // Final fallback when body has no Telegram error_code (proxy/html/partial body cases)
        return when (result.statusCode) {
            400 -> buildResult(false, ResultCode.BAD_REQUEST, "Bad request")
            401 -> buildResult(false, ResultCode.UNAUTHORIZED, "Bot token is incorrect")
            403 -> buildResult(false, ResultCode.FORBIDDEN, "Bot has no access to the chat")
            429 -> buildResult(false, ResultCode.RATE_LIMITED, "Too many requests", true)
            in 500..599 -> buildResult(false, ResultCode.SERVER_ERROR, "Server error", true)
            else -> buildResult(
                isSuccess = false,
                code = ResultCode.UNEXPECTED_ERROR,
                info = "Telegram API returned status ${result.statusCode ?: "unknown"}",
            )
        }
    }

    private fun isRetryable(code: String): Boolean {
        // Retry only codes that are expected to recover without user action
        return when (code) {
            ResultCode.RATE_LIMITED,
            ResultCode.SERVER_ERROR,
            ResultCode.NETWORK_ERROR,
            ResultCode.NETWORK_TIMEOUT -> true
            else -> false
        }
    }

    private fun mapErrorCode(errorCode: Int): String {
        return when (errorCode) {
            400 -> ResultCode.BAD_REQUEST
            401 -> ResultCode.UNAUTHORIZED
            403 -> ResultCode.FORBIDDEN
            429 -> ResultCode.RATE_LIMITED
            in 500..599 -> ResultCode.SERVER_ERROR
            else -> ResultCode.UNEXPECTED_ERROR
        }
    }

    private fun parseResponseBody(body: String?): ApiResponse {
        if (body.isNullOrBlank()) return ApiResponse()

        return try {
            val json = JSONObject(body)
            ApiResponse(
                ok = if (json.has("ok")) json.optBoolean("ok") else null,
                errorCode = if (json.has("error_code")) json.optInt("error_code") else null,
                description = json.optString("description").ifBlank { null }
            )
        } catch (_: Exception) { // non-JSON body fallback
            ApiResponse()
        }
    }

    private data class ApiResult(
        val statusCode: Int? = null,
        val ok: Boolean? = null,
        val errorCode: Int? = null,
        val description: String? = null,
        val error: Exception? = null
    )

    private data class ApiResponse(
        val ok: Boolean? = null,
        val errorCode: Int? = null,
        val description: String? = null
    )

    private val httpClient: OkHttpClient by lazy {
        OkHttpClient.Builder()
            .connectTimeout(15, TimeUnit.SECONDS)
            .readTimeout(15, TimeUnit.SECONDS)
            .writeTimeout(15, TimeUnit.SECONDS)
            .build()
    }
}

// ================================================================================
// SMTP SERVER PROVIDER
// ================================================================================

object SmtpServerProvider : SendProvider {
    override val id: String = SendProviderId.SMTP_SERVER

    override fun send(configJson: String, secret: String, type: String, payload: SendProviderPayload): SendProviderResult {
        if (configJson.isBlank()) {
            return buildResult(
                isSuccess = false,
                code = ResultCode.INVALID_PARAMS,
                info = "SMTP config is empty"
            )
        }

        return try {
            val json = JSONObject(configJson)
            val host = json.optString("host", "")
            val protocol = json.optString("protocol", "starttls")
            val port = json.optInt("port", 587)
            val login = json.optString("login", "")
            val password = secret
            val fromEmail = json.optString("fromEmail", "").ifBlank { login }
            val toEmail = json.optString("toEmail", "").ifBlank { login }
            val subject = json.optString("subject", "")

            if (host.isBlank() || login.isBlank() || password.isBlank()) {
                return buildResult(
                    isSuccess = false,
                    code = ResultCode.INVALID_PARAMS,
                    info = "host, login, password and toEmail are required"
                )
            }

            val props = Properties()
            props["mail.smtp.host"] = host
            props["mail.smtp.port"] = port.toString()
            props["mail.smtp.auth"] = "true"
            props["mail.smtp.connectiontimeout"] = "25000"
            props["mail.smtp.timeout"] = "25000"
            props["mail.smtp.writetimeout"] = "25000"

            when (protocol.lowercase()) {
                "ssl" -> {
                    props["mail.smtp.ssl.enable"] = "true"
                    props["mail.smtp.socketFactory.port"] = port.toString()
                    props["mail.smtp.socketFactory.class"] = "javax.net.ssl.SSLSocketFactory"
                }
                "starttls" -> {
                    props["mail.smtp.starttls.enable"] = "true"
                }
                else -> {
                    // Plain SMTP
                }
            }

            val session = Session.getInstance(props, object : Authenticator() {
                override fun getPasswordAuthentication(): PasswordAuthentication {
                    return PasswordAuthentication(login, password)
                }
            })
            val fromAddress = InternetAddress(fromEmail, true).apply { validate() }
            val toAddresses = InternetAddress.parse(toEmail, true).also {
                addresses -> addresses.forEach { it.validate() }
            }

            val msg = MessageHelpers.format(
                provider = id,
                type = type,
                sender = payload.sender,
                body = payload.body,
                receivedAt = payload.receivedAt,
                labels = payload.labels,
            )

            val message = MimeMessage(session)
            message.setFrom(fromAddress)
            message.setRecipients(Message.RecipientType.TO, toAddresses)
            message.setSubject(sanitizeMailHeader(subject.ifBlank { msg.subject }), "UTF-8")
            message.setText(msg.text, "UTF-8")

            Transport.send(message)
            buildResult(
                isSuccess = true,
                code = ResultCode.OK,
                info = "Sent successfully"
            )
        } catch (e: Exception) {
            val details = buildErrorDetails(e)
            val code = mapErrorCode(e)
            return buildResult(
                isSuccess = false,
                code = code,
                info = "SMTP send failed",
                details = details,
                shouldRetry = isRetryable(e, code),
                exception = e
            )
        }
    }

    private fun mapErrorCode(error: Throwable): String {
        val networkCode = networkErrorCode(error)
        return when {
            error is AuthenticationFailedException -> ResultCode.UNAUTHORIZED
            networkCode != null -> networkCode
            error is SendFailedException -> ResultCode.SMTP_ADDRESS_REJECTED
            error is MessagingException -> ResultCode.SMTP_ERROR
            else -> ResultCode.UNEXPECTED_ERROR
        }
    }

    private fun networkErrorCode(error: Throwable): String? {
        fun codeOf(error: Throwable): String? {
            return when (error) {
                is SocketTimeoutException -> ResultCode.NETWORK_TIMEOUT
                is UnknownHostException,
                is ConnectException -> ResultCode.NETWORK_ERROR
                else -> null
            }
        }

        var current: Throwable? = error
        var depth = 0
        while (current != null && depth < 8) {
            codeOf(current)?.let { return it }

            if (current is MessagingException) {
                var next = current.nextException
                var nextDepth = 0
                while (next != null && next !== current && nextDepth < 8) {
                    codeOf(next)?.let { return it }
                    next = (next as? MessagingException)?.nextException
                    nextDepth++
                }
            }

            current = current.cause
            depth++
        }

        return null
    }

    private fun isRetryable(error: Throwable, code: String): Boolean {
        return when (code) {
            ResultCode.NETWORK_TIMEOUT,
            ResultCode.NETWORK_ERROR -> true
            ResultCode.SMTP_ERROR,
            ResultCode.SMTP_ADDRESS_REJECTED -> hasTransientSmtpStatus(error)
            else -> false
        }
    }

    private fun hasTransientSmtpStatus(error: Throwable): Boolean {
        fun returnCodeOf(error: Throwable): Int? {
            return when (error) {
                is SMTPAddressFailedException -> error.returnCode
                is SMTPSendFailedException -> error.returnCode
                is SMTPSenderFailedException -> error.returnCode
                else -> null
            }
        }

        var current: Throwable? = error
        var depth = 0
        while (current != null && depth < 8) {
            val returnCode = returnCodeOf(current)
            if (returnCode in 400..499) return true

            if (current is MessagingException) {
                var next = current.nextException
                var nextDepth = 0
                while (next != null && next !== current && nextDepth < 8) {
                    val nextReturnCode = returnCodeOf(next)
                    if (nextReturnCode in 400..499) return true
                    next = (next as? MessagingException)?.nextException
                    nextDepth++
                }
            }

            current = current.cause
            depth++
        }

        return false
    }

    private fun sanitizeMailHeader(value: String): String {
        return value
            .replace(Regex("[\\r\\n\\u0000-\\u001F\\u007F]"), " ")
            .trim()
    }

    private fun buildErrorDetails(error: Throwable): String {
        val type = error::class.java.simpleName
        val message = error.message?.trim().orEmpty().ifBlank { "<no message>" }

        if (error is MessagingException) {
            val next = error.nextException
            if (next != null && next !== error) {
                val nextType = next::class.java.simpleName
                val nextMessage = next.message?.trim().orEmpty().ifBlank { "<no message>" }
                return "$type: $message | $nextType: $nextMessage"
            }
        }

        return "$type: $message"
    }
}
