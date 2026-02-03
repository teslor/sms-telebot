package com.teslor.sms_telebot

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.work.CoroutineWorker
import androidx.work.ForegroundInfo
import androidx.work.WorkerParameters
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder

/**
 * Background worker that sends an incoming SMS to Telegram.
 */
class SmsForwardWorker(
    appContext: Context,
    params: WorkerParameters
) : CoroutineWorker(appContext, params) {

    override suspend fun getForegroundInfo(): ForegroundInfo {
        // Required for expedited WorkManager tasks; provide a minimal notification
        val notification = createForegroundNotification()
        return ForegroundInfo(FOREGROUND_NOTIFICATION_ID, notification)
    }

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        val sender = inputData.getString(KEY_SENDER).orEmpty()
        val body = inputData.getString(KEY_BODY).orEmpty()

        if (sender.isBlank() || body.isBlank()) {
            return@withContext Result.failure()
        }

        // Read settings saved by Flutter (shared_preferences)
        val prefs = applicationContext.getSharedPreferences(
            "FlutterSharedPreferences",
            Context.MODE_PRIVATE
        )

        val isRunning = prefs.getBoolean("flutter.isRunning", false)
        if (!isRunning) {
            return@withContext Result.success()
        }

        val token = prefs.getString("flutter.botToken", "").orEmpty()
        val chatId = prefs.getString("flutter.chatId", "").orEmpty()
        val deviceLabel = prefs.getString("flutter.deviceLabel", "").orEmpty()
        // SharedPreferences may store Dart int as Long on Android
        val filterMode = try {
            prefs.getInt("flutter.filterMode", 0)
        } catch (_: ClassCastException) {
            prefs.getLong("flutter.filterMode", 0L).toInt()
        }

        var sendResult = false
        var workerResult: Result = Result.failure()

        val filters = SmsFilters.fromPrefs(prefs)
        if (token.isBlank() || chatId.isBlank()) {
            // No configuration yet; don't retry endlessly
            sendResult = false
            workerResult = Result.failure()
        } else {
            val shouldSend = SmsFilters.checkFilters(
                mode = filterMode,
                sender = sender,
                sms = body,
                filters = filters
            )

            if (!shouldSend) {
                // Filtered out: nothing to do, but this is not an error
                sendResult = false
                workerResult = Result.success()
            } else {
                val deviceInfo = if (deviceLabel.isNotBlank()) " <i>($deviceLabel)</i>" else ""
                val message = "SMS from <b>$sender</b>$deviceInfo:\n$body"

                val code = sendTelegramMessage(token, chatId, message)
                sendResult = code == 200
                workerResult = when {
                    code == 200 -> Result.success()
                    code in 400..499 -> Result.failure()
                    else -> Result.retry()
                }
            }
        }

        // Update UI stats in SharedPreferences and notify Flutter (if running)
        updateUiStats(prefs, sender, body, inputData.getLong(KEY_TIMESTAMP, 0L), sendResult)

        return@withContext workerResult
    }

    /**
     * Sends a Telegram message using a simple GET request.
     *
     * Returns the HTTP status code, or null on IO errors.
     */
    private fun sendTelegramMessage(token: String, chatId: String, msg: String): Int? {
        val encoded = URLEncoder.encode(msg, "UTF-8")
        val url = URL(
            "https://api.telegram.org/bot$token/sendMessage" +
                "?chat_id=$chatId&text=$encoded&parse_mode=HTML"
        )

        return try {
            val connection = url.openConnection() as HttpURLConnection
            connection.requestMethod = "GET"
            connection.connectTimeout = 15_000
            connection.readTimeout = 15_000
            connection.connect()
            connection.responseCode
        } catch (e: Exception) {
            null
        }
    }

    private fun createForegroundNotification(): Notification {
        val manager = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = FOREGROUND_CHANNEL_ID

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "SMS Telebot Forwarding",
                NotificationManager.IMPORTANCE_LOW
            )
            manager.createNotificationChannel(channel)
            Notification.Builder(applicationContext, channelId)
        } else {
            Notification.Builder(applicationContext)
        }

        return builder
            .setContentTitle("SMS Telebot")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setOngoing(true)
            .build()
    }

    private fun updateUiStats(
        prefs: android.content.SharedPreferences,
        sender: String,
        body: String,
        timestamp: Long,
        sent: Boolean
    ) {
        val smsId = "$timestamp|$sender|${body.hashCode()}"
        val lastId = prefs.getString("flutter.lastSmsId", null)
        val lastSent = prefs.getBoolean("flutter.lastSmsSent", false)

        val receivedCountStart = try {
            prefs.getInt("flutter.smsReceived", 0)
        } catch (_: ClassCastException) {
            prefs.getLong("flutter.smsReceived", 0L).toInt()
        }
        val sentCountStart = try {
            prefs.getInt("flutter.smsSentToBot", 0)
        } catch (_: ClassCastException) {
            prefs.getLong("flutter.smsSentToBot", 0L).toInt()
        }

        var receivedCount = receivedCountStart
        var sentCount = sentCountStart

        val isSameSms = lastId == smsId
        if (!isSameSms) {
            receivedCount += 1
        }
        if (sent && (!isSameSms || !lastSent)) {
            sentCount += 1
        }

        val latest = JSONObject()
            .put("time", timestamp.toString())
            .put("sender", sender)
            .put("sms", body)
            .put("sent", sent)

        prefs.edit()
            .putInt("flutter.smsReceived", receivedCount)
            .putInt("flutter.smsSentToBot", sentCount)
            .putString("flutter.latestSms", latest.toString())
            .putString("flutter.lastSmsId", smsId)
            .putBoolean("flutter.lastSmsSent", sent)
            .apply()

    }

    companion object {
        const val TAG = "sms_forward_worker"
        const val KEY_SENDER = "sender"
        const val KEY_BODY = "body"
        const val KEY_TIMESTAMP = "timestamp"
        private const val FOREGROUND_NOTIFICATION_ID = 1001
        private const val FOREGROUND_CHANNEL_ID = "sms_telebot_forwarding"
    }
}

/**
 * Filter logic equivalent to the Dart implementation.
 * Stored filters are JSON arrays in shared_preferences.
 */
object SmsFilters {
    private val filterKeys = listOf("wSenders", "wSms", "bSenders", "bSms")

    data class Lists(
        val wSenders: List<String>,
        val wSms: List<String>,
        val bSenders: List<String>,
        val bSms: List<String>
    )

    fun fromPrefs(prefs: android.content.SharedPreferences): Lists {
        fun readList(key: String): List<String> {
            val raw = prefs.getString("flutter.$key", "[]") ?: "[]"
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
}
