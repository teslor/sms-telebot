package com.teslor.sms_telebot

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.work.CoroutineWorker
import androidx.work.ForegroundInfo
import androidx.work.WorkerParameters
import java.util.concurrent.ConcurrentHashMap
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.withContext

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
        val dbManager = DbManager.getInstance(applicationContext)
        val secretStorage = SecureStorageManager.getInstance(applicationContext)
        val isRunning = dbManager.getBoolSetting("isRunning")
        if (!isRunning) return@withContext Result.success()

        // Read input data from receiver
        val smsId = inputData.getString("sms_id") ?: return@withContext Result.failure()
        val ruleIds = inputData.getIntArray("rule_ids") ?: return@withContext Result.failure()

        // Guard against concurrent duplicate execution for the same SMS
        if (!inFlightSmsIds.add(smsId)) return@withContext Result.success()

        try {
            // Check if SMS exists and was not already sent
            val smsData = dbManager.getSmsById(smsId) ?: return@withContext Result.failure()
            if (smsData.status != 0) {
                return@withContext Result.success() // already processed (deduplication)
            }

            // Get rules from DB by their IDs
            val rules = dbManager.getRulesByIds(ruleIds)
            if (rules.isEmpty()) return@withContext Result.success()

            // Read common settings
            val deviceLabel = dbManager.getSetting("deviceLabel").orEmpty()
            val l10nSmsFrom = dbManager.getSetting("l10nSmsFrom").orEmpty().ifBlank { "SMS from" }

            // Start parallel sending
            val results = coroutineScope {
                rules.map { rule ->
                    async {
                        val secretResult = secretStorage.readSecret(rule.id.toString())
                        val secret = if (secretResult.isSuccess) secretResult.data ?: "" else ""
                        processRule(rule, secret, smsData.sender, smsData.body, deviceLabel, l10nSmsFrom)
                    }
                }.awaitAll()
            }

            val successCount = results.count { it.isSuccess } // count the number of successful sends
            val shouldRetry = results.any { !it.isSuccess && it.shouldRetry }

            return@withContext if (successCount > 0) {
                // If at least one send is successful - save the status
                val newStatus = if (successCount == rules.size) 1 else 2 // 1 = all ok, 2 = partially

                dbManager.updateSmsHistory(
                    id = smsId,
                    updates = mapOf(
                        "status" to newStatus,
                        "sent_at" to System.currentTimeMillis()
                    )
                )
                Result.success()
            } else if (shouldRetry) {
                Result.retry() // retry only when at least one failure is temporary
            } else {
                Result.failure() // all failures are permanent, no retry needed
            }
        } finally {
            inFlightSmsIds.remove(smsId)
        }
    }

    // Router by providers for forwarding
    private fun processRule(
        rule: ForwardingRuleConfig,
        secret: String,
        sender: String,
        body: String,
        deviceLabel: String,
        l10nSmsFrom: String
    ): ProviderSendResult {
        return SmsProviderGateway.send(
            providerId = rule.provider,
            configJson = rule.configJson ?: "",
            secret = secret,
            payload = SmsForwardPayload(
                sender = sender,
                body = body,
                deviceLabel = deviceLabel,
                l10nSmsFrom = l10nSmsFrom
            )
        )
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

    companion object {
        const val TAG = "sms_forward_worker"
        private const val FOREGROUND_NOTIFICATION_ID = 1001
        private const val FOREGROUND_CHANNEL_ID = "sms_telebot_forwarding"
        private val inFlightSmsIds = ConcurrentHashMap.newKeySet<String>()
    }
}
