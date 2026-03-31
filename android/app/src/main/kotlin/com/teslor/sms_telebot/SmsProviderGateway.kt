package com.teslor.sms_telebot

import android.util.Log
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

data class SmsForwardPayload(
    val sender: String,
    val body: String,
    val deviceLabel: String,
    val l10nSmsFrom: String
)

data class ProviderSendResult(
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

object SendCodes {
    const val OK = "ok"
    const val BAD_REQUEST = "bad_request"
    const val FORBIDDEN = "forbidden"
    const val INVALID_PARAMS = "invalid_params"
    const val NETWORK_ERROR = "network_error"
    const val NETWORK_TIMEOUT = "network_timeout"
    const val RATE_LIMITED = "rate_limited"
    const val SERVER_ERROR = "server_error"
    const val SMTP_ERROR = "smtp_error"
    const val SMTP_RECIPIENTS_REJECTED = "smtp_recipients_rejected"
    const val UNAUTHORIZED = "unauthorized"
    const val UNEXPECTED_ERROR = "unexpected_error"
}

interface SmsProvider {
    val id: String
    fun send(configJson: String?, payload: SmsForwardPayload): ProviderSendResult

    // Universal factory for creating ProviderSendResult and logging
    fun buildResult(
        isSuccess: Boolean,
        code: String,
        info: String,
        shouldRetry: Boolean = false,
        details: String? = null,
        exception: Throwable? = null // Pass Exception to Logcat to draw stacktrace
    ): ProviderSendResult {
        val type = if (isSuccess) "send_success" else "send_error"
        val infoStr = LogFormatter.buildInfo(type, info, id, code, details ?: exception?.message)

        // Log
        if (isSuccess) Log.i("SmsProvider", infoStr)
        else Log.e("SmsProvider", infoStr, exception)

        // Return object for worker and UI
        return ProviderSendResult(isSuccess, code, infoStr, shouldRetry)
    }
}

object SmsProviderGateway {
    private val providers: Map<String, SmsProvider> = listOf(
        TelegramBotProvider,
        SmtpServerProvider
    ).associateBy { it.id }

    fun send(providerId: String, configJson: String?, payload: SmsForwardPayload): ProviderSendResult {
        val provider = providers[providerId.lowercase()]
            ?: return ProviderSendResult(
                isSuccess = false,
                code = SendCodes.UNEXPECTED_ERROR,
                info = "Unknown provider: $providerId"
            )
        return provider.send(configJson, payload)
    }
}

// ================================================================================
// TELEGRAM BOT PROVIDER
// ================================================================================

object TelegramBotProvider : SmsProvider {
    override val id: String = SmsContract.Providers.TELEGRAM_BOT

    override fun send(configJson: String?, payload: SmsForwardPayload): ProviderSendResult {
        if (configJson.isNullOrBlank()) {
            return buildResult(
                isSuccess = false,
                code = SendCodes.INVALID_PARAMS,
                info = "Bot connection data is empty"
            )
        }

        return try {
            val json = JSONObject(configJson)
            val token = json.optString("botToken", "")
            val chatId = json.optString("chatId", "")
            if (token.isBlank() || chatId.isBlank()) {
                return buildResult(
                    isSuccess = false,
                    code = SendCodes.INVALID_PARAMS,
                    info = "Bot token and chat ID are required"
                )
            }

            val senderEscaped = escapeHtml(payload.sender)
            val deviceLabelEscaped = escapeHtml(payload.deviceLabel)
            val bodyEscaped = escapeHtml(payload.body)
            val deviceInfo = if (deviceLabelEscaped.isNotBlank()) " <i>($deviceLabelEscaped)</i>" else ""
            val message = if (senderEscaped.isBlank()) {
                "$bodyEscaped$deviceInfo"
            } else {
                "${payload.l10nSmsFrom} <b>$senderEscaped</b>$deviceInfo:\n$bodyEscaped"
            }

            val result = sendRequest(token, chatId, message)
            mapApiResult(result)
        } catch (e: Exception) {
            buildResult(
                isSuccess = false,
                code = SendCodes.UNEXPECTED_ERROR,
                info = e.message ?: "Unexpected error",
                exception = e
            )
        }
    }

    private fun sendRequest(
        token: String,
        chatId: String,
        msg: String
    ): ApiResult {
        val requestBody = FormBody.Builder()
            .add("chat_id", chatId)
            .add("text", msg)
            .add("parse_mode", "HTML")
            .build()

        val request = Request.Builder()
            .url("https://api.telegram.org/bot$token/sendMessage")
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

    private fun mapApiResult(result: ApiResult): ProviderSendResult {
        // Prefer Telegram "ok=true", but keep HTTP 200 fallback for malformed/missing body
        if (result.ok == true || (result.statusCode == 200 && result.errorCode == null)) {
            return buildResult(isSuccess = true, code = SendCodes.OK, info = "Sent successfully")
        }

        if (result.error != null) {
            val rootCause = result.error.cause ?: result.error
            val code = when {
                rootCause is SocketTimeoutException || result.error is SocketTimeoutException -> 
                    SendCodes.NETWORK_TIMEOUT
                rootCause is UnknownHostException || rootCause is ConnectException || 
                result.error is UnknownHostException || result.error is ConnectException -> 
                    SendCodes.NETWORK_ERROR
                else -> SendCodes.NETWORK_ERROR
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
            400 -> buildResult(false, SendCodes.BAD_REQUEST, "Bad request")
            401 -> buildResult(false, SendCodes.UNAUTHORIZED, "Bot token is incorrect")
            403 -> buildResult(false, SendCodes.FORBIDDEN, "Bot has no access to the chat")
            429 -> buildResult(false, SendCodes.RATE_LIMITED, "Too many requests", true)
            in 500..599 -> buildResult(false, SendCodes.SERVER_ERROR, "Server error", true)
            else -> buildResult(
                isSuccess = false,
                code = SendCodes.UNEXPECTED_ERROR,
                info = "Telegram API returned status ${result.statusCode ?: "unknown"}",
            )
        }
    }

    private fun isRetryable(code: String): Boolean {
        // Retry only codes that are expected to recover without user action
        return when (code) {
            SendCodes.RATE_LIMITED,
            SendCodes.SERVER_ERROR,
            SendCodes.NETWORK_ERROR,
            SendCodes.NETWORK_TIMEOUT -> true
            else -> false
        }
    }

    private fun mapErrorCode(errorCode: Int): String {
        return when (errorCode) {
            400 -> SendCodes.BAD_REQUEST
            401 -> SendCodes.UNAUTHORIZED
            403 -> SendCodes.FORBIDDEN
            429 -> SendCodes.RATE_LIMITED
            in 500..599 -> SendCodes.SERVER_ERROR
            else -> SendCodes.UNEXPECTED_ERROR
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

    private fun escapeHtml(text: String): String {
        return text
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
    }

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

object SmtpServerProvider : SmsProvider {
    override val id: String = SmsContract.Providers.SMTP_SERVER
    private const val TAG = "SmtpServerProvider"

    override fun send(configJson: String?, payload: SmsForwardPayload): ProviderSendResult {
        if (configJson.isNullOrBlank()) {
            return buildResult(
                isSuccess = false,
                code = SendCodes.INVALID_PARAMS,
                info = "SMTP config is empty"
            )
        }
        var host = ""
        var protocol = ""

        return try {
            val json = JSONObject(configJson)
            host = json.optString("host", "")
            protocol = json.optString("protocol", "starttls")
            val port = json.optInt("port", 587)
            val login = json.optString("login", "")
            val password = json.optString("password", "")
            val fromEmail = json.optString("fromEmail", "").ifBlank { login }
            val toEmail = json.optString("toEmail", "")
            var subject = json.optString("subject", "")

            if (host.isBlank() || login.isBlank() || password.isBlank() || toEmail.isBlank()) {
                return buildResult(
                    isSuccess = false,
                    code = SendCodes.INVALID_PARAMS,
                    info = "host, login, password and toEmail are required"
                )
            }

            val sender = payload.sender
            val deviceLabel = payload.deviceLabel
            val body = payload.body
            val deviceInfo = if (deviceLabel.isNotBlank()) " ($deviceLabel)" else ""

            val messageText = if (sender.isBlank()) {
                if (subject.isBlank()) subject = "SMS Telebot"
                "$body$deviceInfo"
            } else {
                if (subject.isBlank()) {
                    subject = "${payload.l10nSmsFrom} $sender$deviceInfo"
                    body
                } else {
                    "${payload.l10nSmsFrom} $sender$deviceInfo:\n$body"
                }
            }

            val props = Properties()
            props["mail.smtp.host"] = host
            props["mail.smtp.port"] = port.toString()
            props["mail.smtp.auth"] = "true"
            props["mail.smtp.connectiontimeout"] = "15000"
            props["mail.smtp.timeout"] = "15000"
            props["mail.smtp.writetimeout"] = "15000"

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
            val safeSubject = sanitizeMailHeader(subject) 
            val message = MimeMessage(session)
            message.setFrom(fromAddress)
            message.setRecipients(Message.RecipientType.TO, toAddresses)
            message.setSubject(safeSubject, "UTF-8")
            message.setText(messageText, "UTF-8")

            Transport.send(message)
            buildResult(
                isSuccess = true,
                code = SendCodes.OK,
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
                shouldRetry = isRetryable(code),
                exception = e
            )
        }
    }

    private fun mapErrorCode(error: Throwable): String {
        val rootCause = error.cause ?: error
        return when {
            error is AuthenticationFailedException -> SendCodes.UNAUTHORIZED
            error is SendFailedException -> SendCodes.SMTP_RECIPIENTS_REJECTED
            rootCause is SocketTimeoutException || error is SocketTimeoutException ->
                SendCodes.NETWORK_TIMEOUT
            rootCause is UnknownHostException || rootCause is ConnectException ||
            error is UnknownHostException || error is ConnectException ->
                SendCodes.NETWORK_ERROR
            error is MessagingException -> SendCodes.SMTP_ERROR
            else -> SendCodes.UNEXPECTED_ERROR
        }
    }

    private fun isRetryable(code: String): Boolean {
        return when (code) {
            SendCodes.NETWORK_TIMEOUT,
            SendCodes.NETWORK_ERROR -> true
            else -> false
        }
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
