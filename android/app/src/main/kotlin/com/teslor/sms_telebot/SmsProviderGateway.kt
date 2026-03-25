package com.teslor.sms_telebot

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
        TelegramBotProvider
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
            httpClient.newCall(request).execute().use { response ->
                response.code
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
