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
        val prefs = applicationContext.getSharedPreferences("FlutterSharedPreferences",Context.MODE_PRIVATE)
        val isRunning = prefs.getBoolean(SmsContract.Prefs.IS_RUNNING, false)
        if (!isRunning) return@withContext Result.success()

        val sender = inputData.getString(KEY_SENDER).orEmpty()
        val body = inputData.getString(KEY_BODY).orEmpty()
        val timestamp = inputData.getLong(KEY_TIMESTAMP, 0L)
        val smsId = "$timestamp|${body.hashCode()}"

        // Robust deduplication for Telegram side: protects against delayed network redelivery (A -> B -> A),
        // WorkManager retries, and rare OEM/Android broadcast duplicates
        val smsSentLastIds = getSmsSentLastIds(prefs)
        if (smsSentLastIds.contains(smsId)) {
            return@withContext Result.success() // already sent successfully earlier -> success
        }

        val token = prefs.getString(SmsContract.Prefs.BOT_TOKEN, "").orEmpty()
        val chatId = prefs.getString(SmsContract.Prefs.CHAT_ID, "").orEmpty()
        val deviceLabel = prefs.getString(SmsContract.Prefs.DEVICE_LABEL, "").orEmpty()
        if (token.isBlank() || chatId.isBlank()) return@withContext Result.failure()

        val l10nSmsFrom = prefs.getString(SmsContract.Prefs.L10N_SMS_FROM, "SMS from").orEmpty().ifBlank { "SMS from" }
        val senderEscaped = escapeHtml(sender)
        val deviceLabelEscaped = escapeHtml(deviceLabel)
        val bodyEscaped = escapeHtml(body)
        val deviceInfo = if (deviceLabelEscaped.isNotBlank()) " <i>($deviceLabelEscaped)</i>" else ""
        val message = "$l10nSmsFrom <b>$senderEscaped</b>$deviceInfo:\n$bodyEscaped"

        val code = sendTelegramMessage(token, chatId, message)
        if (code == 200) {
            updateSentStats(
                prefs = prefs,
                smsSentLastIds = smsSentLastIds,
                smsId = smsId,
                sender = sender,
                body = body,
                timestamp = System.currentTimeMillis()
            )
            return@withContext Result.success()
        }

        return@withContext when {
            code == 429 -> Result.retry()
            code != null && code in 400..499 -> Result.failure()
            else -> Result.retry()
        }
    }

    /**
     * Sends a Telegram message using a simple POST request.
     *
     * Returns the HTTP status code, or null on IO errors.
     */
    private fun sendTelegramMessage(token: String, chatId: String, msg: String): Int? {
        val url = URL("https://api.telegram.org/bot$token/sendMessage")
        val postData = buildString {
            append("chat_id=").append(URLEncoder.encode(chatId, "UTF-8"))
            append("&text=").append(URLEncoder.encode(msg, "UTF-8"))
            append("&parse_mode=HTML")
        }
        val postBytes = postData.toByteArray(Charsets.UTF_8)

        var connection: HttpURLConnection? = null
        return try {
            connection = url.openConnection() as HttpURLConnection
            connection.requestMethod = "POST"
            connection.doOutput = true
            connection.connectTimeout = 15_000
            connection.readTimeout = 15_000
            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
            connection.setFixedLengthStreamingMode(postBytes.size)
            connection.outputStream.use { it.write(postBytes) }
            connection.responseCode
        } catch (e: Exception) {
            null
        } finally {
            connection?.disconnect()
        }
    }

    private fun getSmsSentLastIds(prefs: android.content.SharedPreferences): MutableList<String> {
        val raw = prefs.getString(SmsContract.Prefs.SMS_SENT_LAST_IDS, "[]") ?: "[]"

        return try {
            val json = JSONArray(raw)
            MutableList(json.length()) { index -> json.optString(index) }
                .filter { it.isNotBlank() }
                .toMutableList()
        } catch (_: Exception) {
            mutableListOf()
        }
    }

    private fun updateSentStats(
        prefs: android.content.SharedPreferences,
        smsSentLastIds: MutableList<String>,
        smsId: String,
        sender: String,
        body: String,
        timestamp: Long
    ) {
        smsSentLastIds.add(smsId)
        val updatedIds = smsSentLastIds.takeLast(SmsContract.Prefs.CAP_LAST_IDS)

        var sentCount = try {
            prefs.getInt(SmsContract.Prefs.SMS_SENT_COUNT, 0)
        } catch (_: ClassCastException) {
            prefs.getLong(SmsContract.Prefs.SMS_SENT_COUNT, 0L).toInt()
        }
        sentCount += 1

        val smsJson = JSONObject()
            .put("time", timestamp.toString())
            .put("sender", sender)
            .put("sms", body)

        prefs.edit()
            .putInt(SmsContract.Prefs.SMS_SENT_COUNT, sentCount)
            .putString(SmsContract.Prefs.SMS_SENT_LAST_IDS, JSONArray(updatedIds).toString())
            .putString(SmsContract.Prefs.SMS_SENT_LAST_ID, smsId)
            .putString(SmsContract.Prefs.SMS_SENT_LAST_DATA, smsJson.toString())
            .apply()
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

    private fun escapeHtml(text: String): String {
        return text
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
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
