// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.app.Activity
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SmsManager
import android.telephony.TelephonyManager
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
import java.io.InterruptedIOException
import java.net.ConnectException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import java.util.Properties
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicInteger
import okhttp3.FormBody
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject

private const val TAG = "SendProvider"

internal object HttpUtils {
    val client: OkHttpClient by lazy {
        OkHttpClient.Builder()
            .connectTimeout(15, TimeUnit.SECONDS)
            .readTimeout(15, TimeUnit.SECONDS)
            .writeTimeout(15, TimeUnit.SECONDS)
            .build()
    }

    fun getErrorCode(statusCode: Int): String {
        return when (statusCode) {
            400 -> ResultCode.BAD_REQUEST
            401 -> ResultCode.UNAUTHORIZED
            403 -> ResultCode.FORBIDDEN
            429 -> ResultCode.RATE_LIMITED
            in 500..599 -> ResultCode.SERVER_ERROR
            else -> ResultCode.UNEXPECTED_ERROR
        }
    }

    fun getErrorMessage(statusCode: Int): String {
        return when (statusCode) {
            400 -> "bad request / invalid format"
            401 -> "unauthorized / invalid token"
            403 -> "forbidden / access denied"
            404 -> "resource not found"
            429 -> "rate limited / too many requests"
            in 500..599 -> "internal server error"
            else -> "unexpected HTTP error"
        }
    }

    fun isRetryable(resultCode: String): Boolean {
        return when (resultCode) {
            ResultCode.RATE_LIMITED,
            ResultCode.SERVER_ERROR,
            ResultCode.NETWORK_ERROR,
            ResultCode.NETWORK_TIMEOUT -> true
            else -> false
        }
    }

    fun isTimeoutError(error: Throwable): Boolean {
        var current: Throwable? = error
        var depth = 0
        while (current != null && depth < 8) {
            when (current) {
                is SocketTimeoutException -> return true
                is InterruptedIOException -> {
                    val message = current.message?.lowercase().orEmpty()
                    val isCancellation = "canceled" in message || "cancelled" in message
                    val isInterruption = "interrupted" in message
                    if (!isCancellation && !isInterruption) return true
                }
            }
            current = current.cause
            depth++
        }
        return false
    }
}

object SendProviderId {
    const val TELEGRAM = "telegram_bot"
    const val NTFY = "ntfy_server"
    const val SMTP = "smtp_server"
    const val SMS = "sms_gateway"
    val list = listOf(TELEGRAM, NTFY, SMTP, SMS)
}

data class SendProviderPayload(
    val sender: String,
    val body: String,
    val simInfo: String?,
    val receivedAt: Long,
    val sets: Map<String, String>,
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

    fun buildResult(
        code: String,
        info: String? = null,
        shouldRetry: Boolean = false,
        details: String? = null,
        exception: Throwable? = null
    ): SendProviderResult {
        val isSuccess = code == ResultCode.OK
        val infoStr = info?.trim().orEmpty()
        val infoSuffix = infoStr.takeIf { it.isNotEmpty() }?.let { ": $it" }.orEmpty()
        val detailsSuffix = details
            ?.takeIf { it.isNotBlank() }
            ?.let { ", details=\"${AppLog.sanitizeString(it)}\"" }
            .orEmpty()
        val meta = "(provider=$id, code=$code$detailsSuffix)"
        val isUnexpectedError = code == ResultCode.UNEXPECTED_ERROR || details != null || exception != null

        when {
            isSuccess -> AppLog.d(TAG) { "Sent successfully$infoSuffix $meta" }
            isUnexpectedError -> AppLog.e(TAG, "Send failed$infoSuffix $meta", exception)
            else -> AppLog.w(TAG, "Send failed$infoSuffix $meta")
        }

        return SendProviderResult(isSuccess, code, infoStr, shouldRetry)
    }
}

object SendProviderGateway {
    private val providers: Map<String, SendProvider> = listOf(
        TelegramProvider,
        NtfyProvider,
        SmtpProvider,
        SmsProvider,
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
        val provider = providers[providerId]
            ?: return SendProviderResult(false, ResultCode.UNEXPECTED_ERROR, "Unknown provider")
        return provider.send(context, configJson, secret, type, payload)
    }
}

// ================================================================================
// TELEGRAM PROVIDER
// ================================================================================

object TelegramProvider : SendProvider {
    override val id: String = SendProviderId.TELEGRAM
    override val requiresNetwork: Boolean = true

    override fun send(context: Context, configJson: String, secret: String, type: String, payload: SendProviderPayload): SendProviderResult {
        if (configJson.isBlank()) {
            return buildResult(ResultCode.INVALID_PARAMS, "empty configuration")
        }

        return try {
            val json = JSONObject(configJson)
            val token = secret
            val chatId = json.optString("chatId", "")
            val apiUrl = json.optString("apiUrl", "").ifBlank { "https://api.telegram.org" }.trimEnd('/')
            if (token.isBlank() || chatId.isBlank()) {
                return buildResult(ResultCode.INVALID_PARAMS, "token and chat ID are required")
            }

            val fMessage = MessageHelpers.format(
                provider = id,
                type = type,
                sender = payload.sender,
                body = payload.body,
                simInfo = payload.simInfo,
                receivedAt = payload.receivedAt,
                sets = payload.sets,
            )
            val message = if (fMessage.title.isNotBlank())
                "${fMessage.title}\n${fMessage.text}" else fMessage.text
            val result = sendRequest(token, chatId, apiUrl, message)
            mapApiResult(result)
        } catch (e: Exception) {
            buildResult(ResultCode.UNEXPECTED_ERROR, e.message ?: "unexpected error", exception = e)
        }
    }

    private fun sendRequest(
        token: String,
        chatId: String,
        apiUrl: String,
        message: String
    ): ApiResult {
        val requestBody = FormBody.Builder()
            .add("chat_id", chatId)
            .add("text", message)
            .add("parse_mode", "HTML")
            .build()

        val request = Request.Builder()
            .url("$apiUrl/bot$token/sendMessage")
            .post(requestBody)
            .build()

        return try {
            HttpUtils.client.newCall(request).execute().use { response ->
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
            return buildResult(ResultCode.OK)
        }

        if (result.error != null) {
            val code = if (HttpUtils.isTimeoutError(result.error)) {
                ResultCode.NETWORK_TIMEOUT
            } else {
                ResultCode.NETWORK_ERROR
            }
            // Transport-level failures are retryable
            return buildResult(code, result.error.message ?: "network error", true)
        }

        // Get specific Telegram API description for the error code
        val codeToMap = result.errorCode ?: result.statusCode ?: -1
        val mappedCode = HttpUtils.getErrorCode(codeToMap)
        val info = result.description ?: HttpUtils.getErrorMessage(codeToMap)

        return buildResult(mappedCode, info, HttpUtils.isRetryable(mappedCode))
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
}

// ================================================================================
// NTFY PROVIDER
// ================================================================================

object NtfyProvider : SendProvider {
    override val id: String = SendProviderId.NTFY
    override val requiresNetwork: Boolean = true

    override fun send(context: Context, configJson: String, secret: String, type: String, payload: SendProviderPayload): SendProviderResult {
        if (configJson.isBlank()) {
            return buildResult(ResultCode.INVALID_PARAMS, "empty configuration")
        }

        return try {
            val json = JSONObject(configJson)
            val serverUrl = json.optString("serverUrl", "").ifBlank { "https://ntfy.sh" }.trimEnd('/')
            val priority = json.optInt("priority", 3)
            val secretJson = JSONObject(secret)
            val topic = secretJson.optString("topic", "")
            val token = secretJson.optString("token", "")

            if (topic.isBlank()) {
                return buildResult(ResultCode.INVALID_PARAMS, "topic is required")
            }

            val fMessage = MessageHelpers.format(
                provider = id,
                type = type,
                sender = payload.sender,
                body = payload.body,
                simInfo = payload.simInfo,
                receivedAt = payload.receivedAt,
                sets = payload.sets,
            )

            val payloadJson = JSONObject().apply {
                put("topic", topic)
                if (fMessage.title.isNotBlank()) put("title", fMessage.title)
                if (fMessage.text.isNotBlank()) put("message", fMessage.text)
                if (priority != 3) put("priority", priority)
            }

            sendRequest(serverUrl, token, payloadJson)
        } catch (e: Exception) {
            buildResult(ResultCode.UNEXPECTED_ERROR, e.message ?: "unexpected error", exception = e)
        }
    }

    private fun sendRequest(serverUrl: String, token: String, payloadJson: JSONObject): SendProviderResult {
        val mediaType = "application/json; charset=utf-8".toMediaType()
        val requestBody = payloadJson.toString().toRequestBody(mediaType)
        val requestBuilder = Request.Builder().url(serverUrl).post(requestBody)
        if (token.isNotBlank()) requestBuilder.addHeader("Authorization", "Bearer $token")

        return try {
            HttpUtils.client.newCall(requestBuilder.build()).execute().use { response ->
                mapHttpStatus(response.code, response.body?.string())
            }
        } catch (e: Exception) {
            val code = if (HttpUtils.isTimeoutError(e)) {
                ResultCode.NETWORK_TIMEOUT
            } else {
                ResultCode.NETWORK_ERROR
            }
            buildResult(code, e.message ?: "network error", shouldRetry = true)
        }
    }

    private fun mapHttpStatus(code: Int, responseBody: String?): SendProviderResult {
        if (code in 200..299) return buildResult(ResultCode.OK)
        val mappedCode = HttpUtils.getErrorCode(code)
        val errorMessage = parseErrorMessage(responseBody)
        return buildResult(
            mappedCode,
            errorMessage ?: HttpUtils.getErrorMessage(code),
            HttpUtils.isRetryable(mappedCode)
        )
    }

    private fun parseErrorMessage(responseBody: String?): String? {
        if (responseBody.isNullOrBlank()) return null
        return try {
            val json = JSONObject(responseBody)
            val message = json.optString("error", "")
            message.ifBlank { null }
        } catch (_: Exception) {
            responseBody.trim().ifBlank { null }
        }
    }
}

// ================================================================================
// SMTP PROVIDER
// ================================================================================

object SmtpProvider : SendProvider {
    override val id: String = SendProviderId.SMTP
    override val requiresNetwork: Boolean = true

    override fun send(context: Context, configJson: String, secret: String, type: String, payload: SendProviderPayload): SendProviderResult {
        if (configJson.isBlank()) {
            return buildResult(ResultCode.INVALID_PARAMS, "empty configuration")
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
            val insecureTls = json.optBoolean("insecureTls", false) // for old Android trust stores

            if (host.isBlank() || login.isBlank() || password.isBlank()) {
                return buildResult(ResultCode.INVALID_PARAMS, "host, login, and password are required")
            }

            val props = Properties()
            props["mail.smtp.host"] = host
            props["mail.smtp.port"] = port.toString()
            props["mail.smtp.auth"] = "true"
            props["mail.smtp.connectiontimeout"] = "25000"
            props["mail.smtp.timeout"] = "25000"
            props["mail.smtp.writetimeout"] = "25000"

            when (protocol) {
                "starttls" -> {
                    props["mail.smtp.starttls.enable"] = "true"
                    props["mail.smtp.starttls.required"] = "true"
                    props["mail.smtp.ssl.checkserveridentity"] = "true"
                    if (insecureTls) props["mail.smtp.ssl.trust"] = host
                }
                "ssl" -> {
                    props["mail.smtp.ssl.enable"] = "true"
                    props["mail.smtp.ssl.checkserveridentity"] = "true"
                    if (insecureTls) props["mail.smtp.ssl.trust"] = host
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

            val fMessage = MessageHelpers.format(
                provider = id,
                type = type,
                sender = payload.sender,
                body = payload.body,
                simInfo = payload.simInfo,
                receivedAt = payload.receivedAt,
                sets = payload.sets,
            )

            val message = MimeMessage(session)
            message.setFrom(fromAddress)
            message.setRecipients(Message.RecipientType.TO, toAddresses)
            message.setSubject(sanitizeMailHeader(subject.ifBlank { fMessage.title }), "UTF-8")
            message.setText(fMessage.text, "UTF-8")

            Transport.send(message)
            buildResult(ResultCode.OK)
        } catch (e: Exception) {
            val details = buildErrorDetails(e)
            val code = mapErrorCode(e)
            buildResult(code, "", isRetryable(e, code), details)
        }
    }

    private fun mapErrorCode(error: Throwable): String {
        val networkCode = getNetworkErrorCode(error)
        return when {
            error is AuthenticationFailedException -> ResultCode.UNAUTHORIZED
            networkCode != null -> networkCode
            error is SendFailedException -> ResultCode.SMTP_ADDRESS_REJECTED
            error is MessagingException -> ResultCode.SMTP_ERROR
            else -> ResultCode.UNEXPECTED_ERROR
        }
    }

    private fun getNetworkErrorCode(error: Throwable): String? {
        fun codeOf(error: Throwable): String? {
            return when (error) {
                is SocketTimeoutException -> ResultCode.NETWORK_TIMEOUT
                is InterruptedIOException ->
                    if (HttpUtils.isTimeoutError(error)) ResultCode.NETWORK_TIMEOUT else null
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
// SMS PROVIDER
// ================================================================================

object SmsProvider : SendProvider {
    override val id: String = SendProviderId.SMS
    override val requiresNetwork: Boolean = false

    override fun send(context: Context, configJson: String, secret: String, type: String, payload: SendProviderPayload): SendProviderResult {
        if (configJson.isBlank()) {
            return buildResult(ResultCode.INVALID_PARAMS, "empty configuration")
        }

        return try {
            val deviceError = checkDeviceSupport(context)
            if (deviceError != null) return deviceError

            val json = JSONObject(configJson)
            val targetNumber = json.optString("number", "")

            if (targetNumber.isBlank()) {
                return buildResult(ResultCode.INVALID_PARAMS, "target phone number is required")
            }

            val fMessage = MessageHelpers.format(
                provider = id,
                type = type,
                sender = payload.sender,
                body = payload.body,
                simInfo = payload.simInfo,
                receivedAt = payload.receivedAt,
                sets = payload.sets,
            )

            val smsManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                context.getSystemService(SmsManager::class.java)
            } else {
                @Suppress("DEPRECATION")
                SmsManager.getDefault()
            }

            if (smsManager == null) {
                return buildResult(ResultCode.UNEXPECTED_ERROR, "SMS manager is unavailable")
            }

            val message = if (fMessage.title.isNotBlank())
                "${fMessage.title}\n${fMessage.text}" else fMessage.text
            val parts = smsManager.divideMessage(message) // split message (160 characters per part)

            sendAndAwait(context, smsManager, targetNumber, parts)
        } catch (e: SecurityException) {
            buildResult(ResultCode.FORBIDDEN, "missing SEND_SMS permission", exception = e)
        } catch (e: Exception) {
            buildResult(ResultCode.UNEXPECTED_ERROR, exception = e)
        }
    }

    private val sendCounter = AtomicInteger(0) // prevent collisions for concurrent sends

    // Send parts and wait for the platform sent-callbacks to classify the result:
    // explicit error -> retry; OK -> success; timeout -> optimistic success
    private fun sendAndAwait(
        context: Context,
        smsManager: SmsManager,
        number: String,
        parts: ArrayList<String>
    ): SendProviderResult {
        val expected = parts.size
        val results = java.util.Collections.synchronizedList(mutableListOf<Int>())
        val latch = CountDownLatch(expected)
        val action = "SMS_SENT.${sendCounter.incrementAndGet()}"

        // Register receiver for sent-callbacks
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(ctx: Context, intent: Intent) {
                results.add(resultCode)
                latch.countDown()
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.registerReceiver(receiver, IntentFilter(action), Context.RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            context.registerReceiver(receiver, IntentFilter(action))
        }

        return try {
            val sentIntents = ArrayList<PendingIntent>(expected)
            val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            for (i in 0 until expected) {
                val intent = Intent(action).setPackage(context.packageName)
                sentIntents.add(PendingIntent.getBroadcast(context, i, intent, flags))
            }

            if (expected > 1) {
                smsManager.sendMultipartTextMessage(number, null, parts, sentIntents, null)
            } else {
                smsManager.sendTextMessage(number, null, parts[0], sentIntents[0], null)
            }

            // Treat result as optimistic after 30s to avoid false negatives
            latch.await(30_000L, TimeUnit.MILLISECONDS)
            checkSendResults(results.toList(), expected)
        } finally {
            try { context.unregisterReceiver(receiver) } catch (_: Exception) {}
        }
    }

    private fun checkSendResults(results: List<Int>, expected: Int): SendProviderResult {
        // Not all confirmations arrived in time: stay optimistic to avoid false negatives
        if (results.size < expected) {
            return buildResult(ResultCode.OK, "confirmation timed out")
        }

        val firstError = results.firstOrNull { it != Activity.RESULT_OK }
            ?: return buildResult(ResultCode.OK)

        // NULL_PDU is a programmatic error (no point retrying)
        return if (firstError == SmsManager.RESULT_ERROR_NULL_PDU) {
            buildResult(ResultCode.UNEXPECTED_ERROR, "null PDU error")
        } else { // everything else is treated as transient and retryable
            buildResult(ResultCode.NETWORK_ERROR, "error $firstError", true)
        }
    }

    private fun checkDeviceSupport(context: Context): SendProviderResult? {
        val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager
            ?: return buildResult(ResultCode.FORBIDDEN, "Telephony service is unavailable")

        // Check SMS capability
        val hasSmsFeature = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.packageManager.hasSystemFeature(PackageManager.FEATURE_TELEPHONY_MESSAGING)
        } else {
            context.packageManager.hasSystemFeature(PackageManager.FEATURE_TELEPHONY)
        }
        if (!hasSmsFeature) {
            return buildResult(ResultCode.FORBIDDEN, "SMS is not supported on this device")
        }

        // Check if SIM card is ready
        return when (telephonyManager.simState) {
            TelephonyManager.SIM_STATE_READY -> null
            TelephonyManager.SIM_STATE_NOT_READY,
            TelephonyManager.SIM_STATE_UNKNOWN -> {
                buildResult(ResultCode.NETWORK_ERROR, "SIM is not ready", true)
            }
            else -> {
                buildResult(ResultCode.FORBIDDEN, "SIM is unavailable, state=${telephonyManager.simState}")
            }
        }
    }
}
