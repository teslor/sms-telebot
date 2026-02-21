package com.teslor.sms_telebot

import org.json.JSONArray

object SmsContract {

    // SharedPreferences keys
    object Prefs {
        private const val P = "flutter."

        // General
        const val IS_RUNNING = "${P}isRunning"

        // Settings
        const val BOT_TOKEN = "${P}botToken"
        const val CHAT_ID = "${P}chatId"
        const val DEVICE_LABEL = "${P}deviceLabel"
        const val FILTER_MODE = "${P}filterMode"
        val FILTER_KEYS = listOf("${P}wSenders", "${P}wSms", "${P}bSenders", "${P}bSms")
        const val L10N_SMS_FROM = "${P}l10nSmsFrom"

        // Received SMS
        const val SMS_RECEIVED_COUNT = "${P}smsReceivedCount"
        const val SMS_RECEIVED_LAST_ID = "${P}smsReceivedLastId"

        // Sent (forwarded) SMS
        const val SMS_SENT_COUNT = "${P}smsSentCount"
        const val SMS_SENT_LAST_IDS = "${P}smsSentLastIds"
        const val SMS_SENT_LAST_ID = "${P}smsSentLastId"
        const val SMS_SENT_LAST_DATA = "${P}smsSentLastData"

        const val CAP_LAST_IDS = 20
    }
}

/** Stored filters are JSON arrays. */
object SmsFilters {
    private val filterKeys = SmsContract.Prefs.FILTER_KEYS

    data class Lists(
            val wSenders: List<String>,
            val wSms: List<String>,
            val bSenders: List<String>,
            val bSms: List<String>
    )

    fun fromPrefs(prefs: android.content.SharedPreferences): Lists {
        fun readList(key: String): List<String> {
            val raw = prefs.getString(key, "[]") ?: "[]"
            return try {
                val json = JSONArray(raw)
                List(json.length()) { index -> json.optString(index) }
            } catch (_: Exception) {
                emptyList()
            }
        }

        return Lists(
                wSenders = readList(filterKeys[0]),
                wSms = readList(filterKeys[1]),
                bSenders = readList(filterKeys[2]),
                bSms = readList(filterKeys[3])
        )
    }

    fun checkFilters(mode: Int, sender: String, sms: String, filters: Lists): Boolean {
        return when (mode) {
            0 -> true // filters off
            1 -> { // whitelist
                hasFilterMatches(sender, filters.wSenders) || hasFilterMatches(sms, filters.wSms)
            }
            else -> { // blacklist
                !hasFilterMatches(sender, filters.bSenders) && !hasFilterMatches(sms, filters.bSms)
            }
        }
    }

    private fun hasFilterMatches(text: String, filters: List<String>): Boolean {
        if (text.isBlank() || filters.isEmpty()) return false

        for (filter in filters) {
            if (isRegex(filter)) {
                try {
                    val regex = Regex(filter.substring(1, filter.length - 1))
                    if (regex.containsMatchIn(text)) return true
                } catch (_: Exception) {
                    // Invalid regex -> ignore, same as Dart behavior
                }
            } else {
                if (text.contains(filter)) return true
            }
        }
        return false
    }

    private fun isRegex(text: String): Boolean {
        return text.length > 1 && text.startsWith("/") && text.endsWith("/")
    }

    fun isValidRegex(text: String): Boolean {
        return try {
            Regex(text.substring(1, text.length - 1))
            true
        } catch (_: Exception) {
            false
        }
    }
}
