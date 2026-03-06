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
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder

/**
 * Background worker that sends an incoming SMS to providers.
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
        val dbHelper = DbHelper.getInstance(applicationContext)
        val isRunning = dbHelper.getBoolSetting("is_running")
        if (!isRunning) return@withContext Result.success()

        // Read input data from receiver
        val smsId = inputData.getString("sms_id") ?: return@withContext Result.failure()
        val ruleIds = inputData.getIntArray("rule_ids") ?: return@withContext Result.failure()

        // Check if SMS exists and was not already sent
        val smsData = dbHelper.getSmsById(smsId) ?: return@withContext Result.failure()
        if (smsData.status != 0) {
            return@withContext Result.success() // already processed (deduplication)
        }

        // Get rules from DB by their IDs
        val rules = dbHelper.getRulesByIds(ruleIds)
        if (rules.isEmpty()) return@withContext Result.success()

        // Read common settings
        val deviceLabel = dbHelper.getSetting("device_label").orEmpty()
        val l10nSmsFrom = dbHelper.getSetting("l10n_sms_from").orEmpty().ifBlank { "SMS from" }

        // Start parallel sending
        val results = coroutineScope {
            rules.map { rule ->
                async {
                    processRule(rule, smsData.sender, smsData.body, deviceLabel, l10nSmsFrom)
                }
            }.awaitAll()
        }

        val successCount = results.count { it } // count the number of successful sends

        return@withContext if (successCount > 0) {
            // If at least one send is successful - save the status
            val newStatus = if (successCount == rules.size) 1 else 2 // 1 = all ok, 2 = partially
            
            dbHelper.updateSmsHistory(
                id = smsId,
                updates = mapOf(
                    "status" to newStatus,
                    "sent_at" to System.currentTimeMillis()
                )
            )
            Result.success() // do not repeat the task
        } else {
            Result.retry() // if ALL sends failed - schedule a retry
        }
    }

    // Router by providers for forwarding
    private fun processRule(
        rule: ForwardingRuleConfig, 
        sender: String, 
        body: String, 
        deviceLabel: String, 
        l10nSmsFrom: String
    ): Boolean {
        return when (rule.provider.lowercase()) {
            SmsContract.Providers.TELEGRAM_BOT -> sendToTelegram(rule.configJson, sender, body, deviceLabel, l10nSmsFrom)
            else -> true // unknown provider is considered successful to avoid endless retry
        }
    }

    // Logic for forwarding specifically to Telegram Bot
    private fun sendToTelegram(
        configJson: String?, 
        sender: String, 
        body: String, 
        deviceLabel: String, 
        l10nSmsFrom: String
    ): Boolean {
        if (configJson.isNullOrBlank()) return false
        
        return try {
            val json = JSONObject(configJson)
            val token = json.optString("botToken", "")
            val chatId = json.optString("chatId", "")
            if (token.isBlank() || chatId.isBlank()) return false

            val senderEscaped = escapeHtml(sender)
            val deviceLabelEscaped = escapeHtml(deviceLabel)
            val bodyEscaped = escapeHtml(body)
            val deviceInfo = if (deviceLabelEscaped.isNotBlank()) " <i>($deviceLabelEscaped)</i>" else ""
            val message = "$l10nSmsFrom <b>$senderEscaped</b>$deviceInfo:\n$bodyEscaped"

            val code = sendTelegramMessageRequest(token, chatId, message)
            code == 200
        } catch (e: Exception) {
            false
        }
    }

    // Send SMS payload to Telegram Bot API
    private fun sendTelegramMessageRequest(token: String, chatId: String, msg: String): Int? {
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
        private const val FOREGROUND_NOTIFICATION_ID = 1001
        private const val FOREGROUND_CHANNEL_ID = "sms_telebot_forwarding"
    }
}
