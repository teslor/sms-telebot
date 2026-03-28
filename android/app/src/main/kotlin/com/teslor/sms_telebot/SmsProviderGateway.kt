package com.teslor.sms_telebot

import android.util.Log
import jakarta.mail.Authenticator
import jakarta.mail.Message
import jakarta.mail.MessagingException
import jakarta.mail.PasswordAuthentication
import jakarta.mail.Session
import jakarta.mail.Transport
import jakarta.mail.internet.InternetAddress
import jakarta.mail.internet.MimeMessage
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

interface SmsProvider {
    val id: String
    fun send(configJson: String?, payload: SmsForwardPayload): Boolean
}

object SmsProviderGateway {
    private val providers: Map<String, SmsProvider> = listOf(
        TelegramBotProvider,
        SmtpServerProvider
    ).associateBy { it.id }

    fun send(providerId: String, configJson: String?, payload: SmsForwardPayload): Boolean {
        val provider = providers[providerId.lowercase()] ?: return true
        return provider.send(configJson, payload)
    }
}

object TelegramBotProvider : SmsProvider {
    override val id: String = SmsContract.Providers.TELEGRAM_BOT

    override fun send(configJson: String?, payload: SmsForwardPayload): Boolean {
        if (configJson.isNullOrBlank()) return false

        return try {
            val json = JSONObject(configJson)
            val token = json.optString("botToken", "")
            val chatId = json.optString("chatId", "")
            if (token.isBlank() || chatId.isBlank()) return false

            val senderEscaped = escapeHtml(payload.sender)
            val deviceLabelEscaped = escapeHtml(payload.deviceLabel)
            val bodyEscaped = escapeHtml(payload.body)
            val deviceInfo = if (deviceLabelEscaped.isNotBlank()) " <i>($deviceLabelEscaped)</i>" else ""
            val message = if (senderEscaped.isBlank()) {
                "$bodyEscaped$deviceInfo"
            } else {
                "${payload.l10nSmsFrom} <b>$senderEscaped</b>$deviceInfo:\n$bodyEscaped"
            }

            val code = sendTelegramMessageRequest(token, chatId, message)
            code == 200
        } catch (_: Exception) {
            false
        }
    }

    private fun sendTelegramMessageRequest(token: String, chatId: String, msg: String): Int? {
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
            httpClient.newCall(request).execute().use {
                response -> response.code
            }
        } catch (_: Exception) {
            null
        }
    }

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

object SmtpServerProvider : SmsProvider {
    override val id: String = SmsContract.Providers.SMTP_SERVER
    private const val TAG = "SmtpServerProvider"

    override fun send(configJson: String?, payload: SmsForwardPayload): Boolean {
        if (configJson.isNullOrBlank()) return false
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

            if (host.isBlank() || login.isBlank() || password.isBlank() || toEmail.isBlank()) return false

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
            true
        } catch (e: Exception) {
            val details = buildErrorDetails(e)
            Log.e(TAG, "SMTP send failed: host=$host, protocol=$protocol, details=$details", e)
            false
        }
    }

    private fun sanitizeMailHeader(value: String): String {
        return value
            .replace(Regex("[\\r\\n\\u0000-\\u001F\\u007F]"), " ")
            .trim()
    }

    private fun buildErrorDetails(error: Throwable): String {
        val parts = mutableListOf<String>()
        val visited = HashSet<Int>()
        var current: Throwable? = error
        var depth = 0

        while (current != null && depth < 8) {
            val id = System.identityHashCode(current)
            if (!visited.add(id)) break

            val type = current::class.java.simpleName
            val message = current.message ?: "<no message>"
            parts += "[$depth] $type: $message"

            if (current is MessagingException) {
                val next = current.nextException
                if (next != null && visited.add(System.identityHashCode(next))) {
                    val nextType = next::class.java.simpleName
                    val nextMessage = next.message ?: "<no message>"
                    parts += "[$depth.next] $nextType: $nextMessage"
                    current = next
                    depth++
                    continue
                }
            }

            current = current.cause
            depth++
        }

        return parts.joinToString(" | ")
    }
}
