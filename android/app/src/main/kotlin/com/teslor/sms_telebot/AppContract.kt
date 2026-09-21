// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.content.Context
import android.text.format.DateFormat
import android.util.Log
import java.io.File
import java.io.FileOutputStream
import java.security.MessageDigest
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Locale
import java.util.concurrent.ConcurrentHashMap
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
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

object SendStatus {
    const val RECEIVED = 0
    const val FAILED_FINAL = 1
    const val FAILED_RETRY = 2
    const val SENT_PARTIAL = 3
    const val SENT_ALL = 4
}

object MessageHelpers {
    data class FormattedMessage(val title: String, val text: String)

    private data class TemplateContext(
        val sender: String, val text: String, val slot: String, val carrier: String,
        val dateTime: java.time.LocalDateTime, val device: String,
    )
    private data class CustomFormatCache(val rawJson: String, val root: JSONObject)

    @Volatile
    private var customFormatCache: CustomFormatCache? = null

    private val dateFormatterCache = ConcurrentHashMap<String, DateTimeFormatter>()
    private val customFormatLock = Any()

    fun format(
        provider: String, type: String,
        sender: String, body: String, simInfo: String?, receivedAt: Long, sets: Map<String, String>,
    ): FormattedMessage {
        val dt = Instant.ofEpochMilli(receivedAt)
            .atZone(ZoneId.systemDefault()).toLocalDateTime()
        val pattern = if (dt.toLocalDate() == LocalDate.now()) {
            "HH:mm"
        } else {
            val currentLocale = Locale.getDefault()
            DateFormat.getBestDateTimePattern(currentLocale, "ddMMHHmm")
        }
        val time = dt.format(DateTimeFormatter.ofPattern(pattern))

        val customFormatJson = sets["customFormatJson"].orEmpty()
        val deviceLabel = sets["deviceLabel"].orEmpty()
        val l10nSms = sets["l10nSms"].orEmpty()
        val l10nCall = sets["l10nCall"].orEmpty()

        val dl = if (provider == SendProviderId.TELEGRAM) escapeHtml(deviceLabel) else deviceLabel
        val si = simInfo.orEmpty()
        val lb = when {
            dl.isNotBlank() && si.isNotBlank() -> " - $dl ($si)"
            dl.isNotBlank() -> " - $dl"
            si.isNotBlank() -> " - $si"
            else -> ""
        }
        val emoji = when (type) {
            "sms" -> "💬" "call" -> "📞" "sys" -> "🔋" else -> "🤖"
        }

        val defaultFormattedMessage = when (provider) {
            SendProviderId.TELEGRAM -> {
                val s = escapeHtml(sender)
                val b = escapeHtml(body)
                val text = "🕒 <i>$time$lb</i>" + if (b.isNotBlank()) "\n$b" else ""
                FormattedMessage("", "$emoji <b>$s</b> $text")
            }

            SendProviderId.NTFY -> {
                val text = "🕒 $time$lb" + if (body.isNotBlank()) "\n$body" else ""
                FormattedMessage("$emoji $sender", text)
            }

            SendProviderId.SMTP -> {
                val (title, ending) = when (type) {
                    "sms" -> "[$l10nSms] $sender" to "🕒 $time$lb\n$emoji $sender"
                    "call" -> "[$l10nCall] $sender" to "🕒 $time$lb\n$emoji $sender"
                    else -> sender to "🕒 $time$lb"
                }
                val text = (if (body.isNotBlank()) "$body\n\n" else "") + ending
                FormattedMessage(title, text)
            }

            SendProviderId.SMS -> {
                val title = when (type) {
                    "sms" -> "$l10nSms: $sender"
                    "call" -> "$l10nCall: $sender"
                    else -> sender
                }
                val text = "$time$lb" + if (body.isNotBlank()) "\n$body" else ""
                FormattedMessage(title, text)
            }

            else -> FormattedMessage(sender, body)
        }

        return try {
            formatCustom(
                provider, type, sender, body, simInfo, dt, customFormatJson, deviceLabel,
            ) ?: defaultFormattedMessage
        } catch (_: Exception) {
            defaultFormattedMessage
        }
    }

    private fun formatCustom(
        provider: String, type: String,
        sender: String, body: String, simInfo: String?, dateTime: java.time.LocalDateTime,
        customFormatJson: String, deviceLabel: String,
    ): FormattedMessage? {
        if (customFormatJson.isEmpty()) return null

        val destination = provider.substringBefore('_')
        val root = getCustomFormatRoot(customFormatJson)
        val templates = root.getJSONObject("templates")
        val providerTemplate = templates.optJSONObject(destination)
        val commonTemplate = templates.optJSONObject("common")
        val typeTemplate = providerTemplate?.optJSONObject(type)
            ?: commonTemplate?.optJSONObject(type)
            ?: return null
        val titleTemplate = typeTemplate.optString("title", "")
        val messageTemplate = typeTemplate.optString("message", "")
        val isTelegram = provider == SendProviderId.TELEGRAM
        val (slot, carrier) = SimInfoResolver.parseInfo(simInfo)

        val templateContext = TemplateContext(
            sender = if (isTelegram) escapeHtml(sender) else sender,
            text = if (isTelegram) escapeHtml(body) else body,
            slot = slot,
            carrier = carrier,
            dateTime = dateTime,
            device = if (isTelegram) escapeHtml(deviceLabel) else deviceLabel,
        )

        val title = if (titleTemplate.isNotEmpty()) applyTemplate(titleTemplate, templateContext) else ""
        val text = if (messageTemplate.isNotEmpty()) applyTemplate(messageTemplate, templateContext) else ""

        return FormattedMessage(title, text)
    }

    private fun getCustomFormatRoot(rawJson: String): JSONObject {
        val cached = customFormatCache
        if (cached != null && cached.rawJson == rawJson) return cached.root

        synchronized(customFormatLock) {
            val lockedCache = customFormatCache
            if (lockedCache != null && lockedCache.rawJson == rawJson) return lockedCache.root

            val root = JSONObject(rawJson)
            customFormatCache = CustomFormatCache(rawJson = rawJson, root = root)
            return root
        }
    }

    fun previewFormat(sets: Map<String, String>): List<Map<String, String>> {
        val previews = mutableListOf<Map<String, String>>()
        for (provider in SendProviderId.list) {
            for (type in listOf("sms", "call", "sys")) {
                val (sender, text) = when (type) {
                    "sys" -> sets["l10nBattery"].orEmpty() to "${sets["l10nLowBattery"].orEmpty()}: 15%"
                    "call" -> "+12345678900" to ""
                    else -> "+12345678900" to sets["l10nHello"].orEmpty()
                }
                val simInfo = if (type == "sms" || type == "call") "SIM 1 / Carrier" else null
                val message = format(
                    provider, type, sender, text, simInfo, System.currentTimeMillis(), sets,
                )
                previews += mapOf(
                    "destination" to provider.substringBefore('_'), "type" to type,
                    "title" to message.title, "message" to message.text,
                )
            }
        }
        return previews
    }

    private fun applyTemplate(template: String, context: TemplateContext): String {
        var formatted = Regex("\\\$date\\((.*?)\\)").replace(template) { match ->
            val pattern = match.groupValues[1]
            val formatter = dateFormatterCache.getOrPut(pattern) {
                DateTimeFormatter.ofPattern(pattern)
            }
            context.dateTime.format(formatter)
        }

        formatted = formatted
            .replace("\$sender", context.sender)
            .replace("\$text", context.text)
            .replace("\$slot", context.slot)
            .replace("\$carrier", context.carrier)
            .replace("\$device", context.device)

        return formatted
    }

    fun generateId(rawId: String): String {
        return MessageDigest.getInstance("SHA-256")
            .digest(rawId.toByteArray())
            .joinToString(separator = "") { byte -> "%02x".format(byte.toInt() and 0xff) }
            .take(16)
    }

    fun escapeHtml(t: String) = t.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
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
    @Volatile
    @PublishedApi
    internal var isDebugEnabled = false

    @Volatile
    private var logDir: File? = null

    private val fileScope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
    private val fileMutex = Mutex()

    fun configure(context: Context, enabled: Boolean) {
        isDebugEnabled = enabled
        logDir = File(context.applicationContext.filesDir, "logs")
    }

    inline fun d(tag: String, e: Throwable? = null, message: () -> String) {
        if (!isDebugEnabled) return
        val text = message()
        if (e == null) Log.d(tag, text) else Log.d(tag, text, e)
        saveToFile("DEBUG", tag, text, e)
    }

    fun i(tag: String, message: String, e: Throwable? = null) {
        if (e == null) Log.i(tag, message) else Log.i(tag, message, e)
        saveToFile("INFO", tag, message, e)
    }

    fun w(tag: String, message: String, e: Throwable? = null) {
        if (e == null) Log.w(tag, message) else Log.w(tag, message, e)
        saveToFile("WARN", tag, message, e)
    }

    fun e(tag: String, message: String, e: Throwable? = null) {
        if (e == null) Log.e(tag, message) else Log.e(tag, message, e)
        saveToFile("ERROR", tag, message, e)
    }

    @PublishedApi
    internal fun saveToFile(level: String, tag: String, message: String, e: Throwable?) {
        val dir = logDir ?: return
        val line = JSONObject()
            .put("time", DateTimeFormatter.ISO_INSTANT.format(Instant.now()))
            .put("level", level)
            .put("tag", tag)
            .put("message", message)
            .apply {
                e?.let {
                    put("exception", "${it::class.java.simpleName}: ${it.message ?: "unknown"}")
                }
            }
            .toString() + '\n'

        fileScope.launch {
            try {
                fileMutex.withLock { appendLine(dir, line) }
            } catch (_: Exception) { }
        }
    }

    private fun appendLine(dir: File, line: String) {
        if (!dir.exists() && !dir.mkdirs()) return
        val activeFile = File(dir, "app.log")
        val bytes = line.toByteArray(Charsets.UTF_8)
        
        // Rotate log files if the active file exceeds 512KB
        if (activeFile.length() + bytes.size > 512 * 1024L) {
            File(dir, "app.prev.log").delete()
            activeFile.renameTo(File(dir, "app.prev.log"))
        }
        FileOutputStream(activeFile, true).use { it.write(bytes) }
    }

    fun sanitizeString(value: String): String =
        value.replace("\"", "'") // replace double quotes to avoid parsing issues
            .replace("\r\n", "\\n").replace("\n", "\\n").replace("\r", "\\n")
}
