package com.teslor.sms_telebot

import org.json.JSONArray
import org.json.JSONObject

object SmsContract {
    object Providers {
        const val TELEGRAM_BOT = "telegram_bot"
    }

    object Keys {
        val FILTER_KEYS = listOf("whitelist_senders", "whitelist_body", "blacklist_senders", "blacklist_body")
    }
}

object SmsFilters {
    private val filterKeys = SmsContract.Keys.FILTER_KEYS

    data class Lists(
        val whitelist_senders: List<String>,
        val whitelist_body: List<String>,
        val blacklist_senders: List<String>,
        val blacklist_body: List<String>
    )

    fun fromJson(jsonStr: String?): Lists {
        if (jsonStr.isNullOrBlank()) {
            return Lists(emptyList(), emptyList(), emptyList(), emptyList())
        }

        return try {
            val json = JSONObject(jsonStr)
            
            fun readList(key: String): List<String> {
                val arr = json.optJSONArray(key) ?: return emptyList()
                return List(arr.length()) { index -> arr.optString(index) }
            }

            Lists(
                whitelist_senders = readList(filterKeys[0]),
                whitelist_body = readList(filterKeys[1]),
                blacklist_senders = readList(filterKeys[2]),
                blacklist_body = readList(filterKeys[3])
            )
        } catch (_: Exception) {
            Lists(emptyList(), emptyList(), emptyList(), emptyList())
        }
    }

    fun checkFilters(mode: Int, sender: String, sms: String, filters: Lists): Boolean {
        return when (mode) {
            0 -> true // filters off
            1 -> { // whitelist
                hasFilterMatches(sender, filters.whitelist_senders) || hasFilterMatches(sms, filters.whitelist_body)
            }
            else -> { // blacklist
                !hasFilterMatches(sender, filters.blacklist_senders) && !hasFilterMatches(sms, filters.blacklist_body)
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
                } catch (_: Exception) {} // invalid regex -> ignore
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
