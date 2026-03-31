package com.teslor.sms_telebot

import org.json.JSONArray
import org.json.JSONObject

object SmsContract {
    object Providers {
        const val TELEGRAM_BOT = "telegram_bot"
        const val SMTP_SERVER = "smtp_server"
    }

    object Keys {
        val FILTER_KEYS = listOf("whitelistSenders", "whitelistBody", "blacklistSenders", "blacklistBody")
    }
}

object SmsFilters {
    private val filterKeys = SmsContract.Keys.FILTER_KEYS

    data class Lists(
        val whitelistSenders: List<String>,
        val whitelistBody: List<String>,
        val blacklistSenders: List<String>,
        val blacklistBody: List<String>
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
                whitelistSenders = readList(filterKeys[0]),
                whitelistBody = readList(filterKeys[1]),
                blacklistSenders = readList(filterKeys[2]),
                blacklistBody = readList(filterKeys[3])
            )
        } catch (_: Exception) {
            Lists(emptyList(), emptyList(), emptyList(), emptyList())
        }
    }

    fun checkFilters(mode: Int, sender: String, sms: String, filters: Lists): Boolean {
        return when (mode) {
            0 -> true // filters off
            1 -> { // whitelist
                hasFilterMatches(sender, filters.whitelistSenders) || hasFilterMatches(sms, filters.whitelistBody)
            }
            else -> { // blacklist
                !hasFilterMatches(sender, filters.blacklistSenders) && !hasFilterMatches(sms, filters.blacklistBody)
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

object LogFormatter {
    fun buildInfo(
        type: String, // source or event type
        msg: String, // short description of what happened (human-readable)
        provider: String? = null, // provider ID (optional)
        code: String? = null, // internal error code (optional)
        details: String? = null // technical details (optional)
    ): String {
        val sb = StringBuilder()
        
        // Basic fields
        sb.append("type=").append(type)
        sb.append(" msg=\"").append(msg).append("\"")
        
        // Specific fields for send_error type
        if (!provider.isNullOrBlank()) sb.append(" provider=").append(provider)
        if (!code.isNullOrBlank()) sb.append(" code=").append(code)
        
        if (!details.isNullOrBlank()) {
            // Replace double quotes with single quotes inside details to avoid parsing issues
            sb.append(" details=\"").append(details.replace("\"", "'")).append("\"") 
        }
        
        return sb.toString()
    }
}
