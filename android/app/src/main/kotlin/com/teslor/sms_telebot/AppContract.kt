// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.content.Context
import android.util.Log
import java.security.MessageDigest
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import org.json.JSONObject

data class FormattedMessage(val subject: String, val text: String)

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

object SendStatus {
    const val RECEIVED = 0
    const val FAILED_FINAL = 1
    const val FAILED_RETRY = 2
    const val SENT_PARTIAL = 3
    const val SENT_ALL = 4
}

object MessageHelpers {
    fun generateId(rawId: String): String {
        return MessageDigest.getInstance("SHA-256")
            .digest(rawId.toByteArray())
            .joinToString(separator = "") { byte -> "%02x".format(byte.toInt() and 0xff) }
            .take(16)
    }

    fun format(
        provider: String, type: String,
        sender: String, body: String, simInfo: String?, receivedAt: Long, labels: Map<String, String>
    ): FormattedMessage {
        val dt = Instant.ofEpochMilli(receivedAt)
            .atZone(ZoneId.systemDefault()).toLocalDateTime()
        val time = dt.format(DateTimeFormatter.ofPattern(
            if (dt.toLocalDate() == LocalDate.now()) "HH:mm" else "dd.MM HH:mm"
        ))

        val deviceLabel = labels["deviceLabel"] ?: ""
        val l10nSms = labels["l10nSms"] ?: ""
        val l10nCall = labels["l10nCall"] ?: ""

        val dl = if (provider == SendProviderId.TELEGRAM_BOT) escapeHtml(deviceLabel) else deviceLabel
        val si = simInfo?.trim().orEmpty()
        val lb = when {
            dl.isNotBlank() && si.isNotBlank() -> " ($dl: $si)"
            dl.isNotBlank() -> " ($dl)"
            si.isNotBlank() -> " ($si)"
            else -> ""
        }

        return when (provider) {
            SendProviderId.TELEGRAM_BOT -> {
                val s = escapeHtml(sender)
                val b = escapeHtml(body)
                val sysSrc = dl.ifBlank { s }
                val head = when (type) {
                    "sms" -> "💬 <b>$s</b>$lb 🕒 <i>$time</i>"
                    "call" -> "📞 <b>$s</b>$lb 🕒 <i>$time</i>"
                    "sys" -> "⚙️ <b>$sysSrc</b> 🕒 <i>$time</i>"
                    "app" -> "🤖 <b>$s</b>$lb"
                    else -> s
                }
                FormattedMessage(subject = "", text = head + if (b.isNotBlank()) "\n$b" else "")
            }

            SendProviderId.SMTP_SERVER -> {
                val sysSrc = dl.ifBlank { sender }
                val (subject, head) = when (type) {
                    "sms" -> "$l10nSms: $sender$lb" to "💬 $sender$lb 🕒 $time"
                    "call" -> "$l10nCall: $sender$lb" to "📞 $sender$lb 🕒 $time"
                    "sys" -> "$sysSrc: $body" to "⚙️ $sysSrc 🕒 $time"
                    "app" -> "$sender$lb: $body" to "🤖 $sender$lb"
                    else -> sender to sender
                }
                FormattedMessage(subject = subject, text = head + if (body.isNotBlank()) "\n\n$body" else "")
            }

            SendProviderId.SMS_GATEWAY -> {
                val sysSrc = dl.ifBlank { sender }
                val head = when (type) {
                    "sms" -> "$l10nSms: $sender$lb $time"
                    "call" -> "$l10nCall: $sender$lb $time"
                    "sys" -> "$sysSrc $time"
                    "app" -> "$sender$lb"
                    else -> sender
                }
                FormattedMessage(subject = "", text = head + if (body.isNotBlank()) "\n$body" else "")
            }

            else -> FormattedMessage(subject = sender, text = body)
        }
    }

    fun escapeHtml(t: String) =
        t.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
}

object MessageFilters {
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

    fun checkFilters(mode: Int, sender: String, body: String, filters: Lists): Boolean {
        return when (mode) {
            0 -> true // filters off
            1 -> { // whitelist
                hasFilterMatches(sender, filters.whitelistSenders) || hasFilterMatches(body, filters.whitelistBody)
            }
            else -> { // blacklist
                !hasFilterMatches(sender, filters.blacklistSenders) && !hasFilterMatches(body, filters.blacklistBody)
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

object AppLog {
    const val LEVEL_INFO = 0
    const val LEVEL_WARN = 1
    const val LEVEL_ERROR = 2

    @Volatile
    @PublishedApi
    internal var isDebugEnabled = false

    @Volatile
    private var dbManager: DbManager? = null

    // Prevents recursive DB logging (safeguard if DB will use AppLog)
    private val isPersistingDbLog = ThreadLocal.withInitial { false }

    fun configure(context: Context, enabled: Boolean) {
        isDebugEnabled = enabled
        dbManager = DbManager.getInstance(context.applicationContext)
    }

    inline fun d(tag: String, e: Throwable? = null, message: () -> String) {
        if (!isDebugEnabled) return
        val text = message()
        if (e == null) Log.d(tag, text) else Log.d(tag, text, e)
    }

    fun i(tag: String, message: String, e: Throwable? = null) {
        if (e == null) Log.i(tag, message) else Log.i(tag, message, e)
        persistToDb(LEVEL_INFO, tag, message, e)
    }

    fun w(tag: String, message: String, e: Throwable? = null) {
        if (e == null) Log.w(tag, message) else Log.w(tag, message, e)
        persistToDb(LEVEL_WARN, tag, message, e)
    }

    fun e(tag: String, message: String, e: Throwable? = null) {
        if (e == null) Log.e(tag, message) else Log.e(tag, message, e)
        persistToDb(LEVEL_ERROR, tag, message, e)
    }

    private fun persistToDb(level: Int, tag: String, message: String, e: Throwable?) {
        val manager = dbManager ?: return
        if (isPersistingDbLog.get() == true) return

        val text = if (e == null) {
            "[$tag] $message"
        } else {
            val eInfo = "${e::class.java.simpleName}: ${e.message ?: "unknown"}"
            "[$tag] $message | $eInfo"
        }

        try {
            isPersistingDbLog.set(true)
            manager.insertAppLogs(level = level, message = text)
        } finally {
            isPersistingDbLog.set(false)
        }
    }

    fun sanitizeString(value: String): String =
        value.replace("\"", "'") // replace double quotes to avoid parsing issues
            .replace("\r\n", "\\n").replace("\n", "\\n").replace("\r", "\\n")
}
