// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SmsManager
import android.telephony.TelephonyManager
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
    const val SMS_GATEWAY = "sms_gateway"
}

data class SendProviderPayload(
    val sender: String,
    val body: String,
    val simInfo: String?,
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
    val requiresNetwork: Boolean

    fun send(context: Context, configJson: String, secret: String, type: String, payload: SendProviderPayload): SendProviderResult

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
        SmtpServerProvider,
        SmsGatewayProvider,
    ).associateBy { it.id }

    fun requiresNetwork(providerId: String): Boolean {
        return providers[providerId]?.requiresNetwork ?: true
    }

    fun send(
        context: Context,
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
        return provider.send(context, configJson, secret, type, payload)
    }
}

// ================================================================================
// TELEGRAM BOT PROVIDER
// ================================================================================

object TelegramBotProvider : SendProvider {
    override val id: String = SendProviderId.TELEGRAM_BOT
    override val requiresNetwork: Boolean = true

    override fun send(context: Context, configJson: String, secret: String, type: String, payload: SendProviderPayload): SendProviderResult {
        if (configJson.isBlank()) {
            return buildResult(false, ResultCode.INVALID_PARAMS, "Empty configuration")
        }

        return try {
            val json = JSONObject(configJson)
            val token = secret
            val chatId = json.optString("chatId", "")
            val apiUrl = json.optString("apiUrl", "").ifBlank { "https://api.telegram.org" }
            if (token.isBlank() || chatId.isBlank()) {
                return buildResult(false, ResultCode.INVALID_PARAMS, "Token and chat ID are required")
            }

            val msg = MessageHelpers.format(
                provider = id,
                type = type,
                sender = payload.sender,
                body = payload.body,
                simInfo = payload.simInfo,
                receivedAt = payload.receivedAt,
                labels = payload.labels,
            )
            val result = sendRequest(token, chatId, apiUrl, msg.text)
            mapApiResult(result)
        } catch (e: Exception) {
            buildResult(false, ResultCode.UNEXPECTED_ERROR, e.message ?: "Unexpected error", exception = e)
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
            return buildResult(true, ResultCode.OK, "Sent successfully")
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
            // Transport-level failures are retryable
            return buildResult(false, code, result.error.message ?: "Network error", true)
        }

        // Get specific Telegram API description for the error code
        if (result.errorCode != null) {
            val info = result.description ?: "Bot API error ${result.errorCode}"
            val mappedCode = mapErrorCode(result.errorCode)
            return buildResult(false, mappedCode, info, isRetryable(mappedCode))
        }

        // Final fallback when body has no Telegram error_code (proxy/html/partial body cases)
        return when (result.statusCode) {
            400 -> buildResult(false, ResultCode.BAD_REQUEST, "Bad request")
            401 -> buildResult(false, ResultCode.UNAUTHORIZED, "Invalid bot token")
            403 -> buildResult(false, ResultCode.FORBIDDEN, "Bot has no access to chat")
            429 -> buildResult(false, ResultCode.RATE_LIMITED, "Too many requests", true)
            in 500..599 -> buildResult(false, ResultCode.SERVER_ERROR, "Server error", true)
            else -> buildResult(
                false, ResultCode.UNEXPECTED_ERROR,
                "Bot API returned status ${result.statusCode ?: "Unknown"}",
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
    override val requiresNetwork: Boolean = true

    override fun send(context: Context, configJson: String, secret: String, type: String, payload: SendProviderPayload): SendProviderResult {
        if (configJson.isBlank()) {
            return buildResult(false, ResultCode.INVALID_PARAMS, "Empty configuration")
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
                return buildResult(false, ResultCode.INVALID_PARAMS, "Host, login, and password are required")
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
                simInfo = payload.simInfo,
                receivedAt = payload.receivedAt,
                labels = payload.labels,
            )

            val message = MimeMessage(session)
            message.setFrom(fromAddress)
            message.setRecipients(Message.RecipientType.TO, toAddresses)
            message.setSubject(sanitizeMailHeader(subject.ifBlank { msg.subject }), "UTF-8")
            message.setText(msg.text, "UTF-8")

            Transport.send(message)
            buildResult(true, ResultCode.OK, "Sent successfully")
        } catch (e: Exception) {
            val details = buildErrorDetails(e)
            val code = mapErrorCode(e)
            buildResult(false, code, "Failed to send via SMTP", isRetryable(e, code), details, e)
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

// ================================================================================
// SMS GATEWAY PROVIDER
// ================================================================================

object SmsGatewayProvider : SendProvider {
    override val id: String = SendProviderId.SMS_GATEWAY
    override val requiresNetwork: Boolean = false

    override fun send(context: Context, configJson: String, secret: String, type: String, payload: SendProviderPayload): SendProviderResult {
        if (configJson.isBlank()) {
            return buildResult(false, ResultCode.INVALID_PARAMS, "Empty configuration")
        }

        return try {
            if (!isDeviceReady(context)) {
                return buildResult(false, ResultCode.NETWORK_ERROR, "SMS cannot be sent", true)
            }

            val json = JSONObject(configJson)
            val targetNumber = json.optString("number", "")

            if (targetNumber.isBlank()) {
                return buildResult(false, ResultCode.INVALID_PARAMS, "Target phone number is required")
            }

            val msg = MessageHelpers.format(
                provider = id,
                type = type,
                sender = payload.sender,
                body = payload.body,
                simInfo = payload.simInfo,
                receivedAt = payload.receivedAt,
                labels = payload.labels,
            )

            val smsManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                context.getSystemService(SmsManager::class.java)
            } else {
                @Suppress("DEPRECATION")
                SmsManager.getDefault()
            }

            if (smsManager == null) {
                return buildResult(false, ResultCode.UNEXPECTED_ERROR, "SMS manager is unavailable")
            }

            // Split message if it's too long (>160 characters typically)
            val parts = smsManager.divideMessage(msg.text)

            if (parts.size > 1) {
                smsManager.sendMultipartTextMessage(targetNumber, null, parts, null, null)
            } else {
                smsManager.sendTextMessage(targetNumber, null, msg.text, null, null)
            }

            buildResult(true, ResultCode.OK, "Sent successfully")
        } catch (e: SecurityException) {
            buildResult(false, ResultCode.FORBIDDEN, "Missing SEND_SMS permission", exception = e)
        } catch (e: Exception) {
            buildResult(false, ResultCode.UNEXPECTED_ERROR, "Failed to send SMS", exception = e)
        }
    }

    // Check if the device can send SMS
    private fun isDeviceReady(context: Context): Boolean {
        val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager ?: return false

        // Check SMS capability
        val hasSmsFeature = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.packageManager.hasSystemFeature(PackageManager.FEATURE_TELEPHONY_MESSAGING)
        } else {
            context.packageManager.hasSystemFeature(PackageManager.FEATURE_TELEPHONY)
        }
        if (!hasSmsFeature) return false

        // Check if SIM card is present and unlocked
        if (telephonyManager.simState != TelephonyManager.SIM_STATE_READY) return false

        return true
    }
}
