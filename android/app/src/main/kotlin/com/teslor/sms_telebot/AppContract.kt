// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import org.json.JSONArray
import org.json.JSONObject

object ResultCode {
    // General/Network
    const val OK = "ok"
    const val BAD_REQUEST = "bad_request"
    const val FORBIDDEN = "forbidden"
    const val INVALID_PARAMS = "invalid_params"
    const val NETWORK_ERROR = "network_error"
    const val NETWORK_TIMEOUT = "network_timeout"
    const val RATE_LIMITED = "rate_limited"
    const val SERVER_ERROR = "server_error"
    const val SMTP_ADDRESS_REJECTED = "smtp_address_rejected"
    const val SMTP_ERROR = "smtp_error"
    const val UNAUTHORIZED = "unauthorized"
    const val UNEXPECTED_ERROR = "unexpected_error"

    // Secure storage
    const val SECRETS_ERROR = "secrets_error"
    const val SECRETS_RECOVERED = "secrets_recovered"
}

object SmsProviderId {
    const val TELEGRAM_BOT = "telegram_bot"
    const val SMTP_SERVER = "smtp_server"
}

object SmsSendStatus {
    const val RECEIVED = 0
    const val FAILED_FINAL = 1
    const val FAILED_RETRY = 2
    const val SENT_PARTIAL = 3
    const val SENT_ALL = 4
}

object SmsFilters {
    private val filterKeys =
        listOf("whitelistSenders", "whitelistBody", "blacklistSenders", "blacklistBody")

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
