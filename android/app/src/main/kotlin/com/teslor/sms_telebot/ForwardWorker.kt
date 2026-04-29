// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.pm.ServiceInfo
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import androidx.work.CoroutineWorker
import androidx.work.ForegroundInfo
import androidx.work.WorkerParameters
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.sync.Semaphore
import kotlinx.coroutines.sync.withPermit
import kotlinx.coroutines.withContext

/**
 * Background worker that forwards an incoming message via configured providers.
 */
class ForwardWorker(
    appContext: Context,
    params: WorkerParameters
) : CoroutineWorker(appContext, params) {

    companion object {
        const val TAG = "ForwardWorker"
        private const val CHANNEL_ID = "sms_telebot_worker"
        private const val NOTIFICATION_ID = 1001
        private val sendSemaphore = Semaphore(5)
    }

    override suspend fun getForegroundInfo(): ForegroundInfo {
        // Required for expedited WorkManager tasks; provide a minimal notification
        val notification = createForegroundNotification()

        // Use typed foreground service for Android 10+
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ForegroundInfo(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
            )
        } else {
            ForegroundInfo(NOTIFICATION_ID, notification)
        }
    }

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        val dbManager = DbManager.getInstance(applicationContext)
        if (!dbManager.getBoolSetting("isRunning")) return@withContext Result.success()
        val secretStorage = SecureStorageManager.getInstance(applicationContext)

        // Read input data from receiver
        val messageId = inputData.getString("message_id") ?: return@withContext Result.failure()
        val ruleIds = inputData.getIntArray("rule_ids") ?: return@withContext Result.failure()

        // Ensure device has internet connectivity
        if (!hasValidatedInternet()) {
            dbManager.updateMessagesHistory(
                id = messageId,
                updates = mapOf("status" to SendStatus.FAILED_RETRY)
            )
            return@withContext Result.retry()
        }

        // Check if message exists and was not already sent
        val messageData = dbManager.getMessageById(messageId) ?: return@withContext Result.failure()
        val shouldBeProcessed =
            messageData.status == SendStatus.RECEIVED || messageData.status == SendStatus.FAILED_RETRY
        if (!shouldBeProcessed) {
            return@withContext Result.success() // already processed
        }

        // Get rules from DB by their IDs
        val rules = dbManager.getRulesByIds(ruleIds)
        if (rules.isEmpty()) return@withContext Result.success()

        // Read labels, required for formatting
        val labels = mapOf(
            "deviceLabel" to dbManager.getSetting("deviceLabel").orEmpty(),
            "l10nSms" to dbManager.getSetting("l10nSms").orEmpty().ifBlank { "SMS" },
            "l10nCall" to dbManager.getSetting("l10nCall").orEmpty().ifBlank { "Call" },
        )

        // Start parallel sending
        val lastAttemptAt = System.currentTimeMillis()
        val nextAttemptCount = messageData.attemptCount + 1
        val results = coroutineScope {
            rules.map { rule ->
                async {
                    sendSemaphore.withPermit {
                        val secretResult = secretStorage.readSecret(rule.id.toString())
                        val secret = if (secretResult.isSuccess) secretResult.data ?: "" else ""
                        processRule(rule, secret, messageData.type, messageData.sender, messageData.body, messageData.receivedAt, labels)
                    }
                }
            }.awaitAll()
        }

        val successCount = results.count { it.isSuccess }
        val shouldRetry = results.any { !it.isSuccess && it.shouldRetry }

        return@withContext if (successCount > 0) {
            val newStatus = if (successCount == rules.size) SendStatus.SENT_ALL else SendStatus.SENT_PARTIAL

            dbManager.updateMessagesHistory(
                id = messageId,
                updates = mapOf(
                    "status" to newStatus,
                    "sent_at" to System.currentTimeMillis(),
                    "last_attempt_at" to lastAttemptAt,
                    "attempt_count" to nextAttemptCount,
                )
            )
            Result.success()
        } else if (shouldRetry) {
            dbManager.updateMessagesHistory(
                id = messageId,
                updates = mapOf(
                    "status" to SendStatus.FAILED_RETRY,
                    "last_attempt_at" to lastAttemptAt,
                    "attempt_count" to nextAttemptCount,
                )
            )
            Result.retry() // retry only when at least one failure is temporary
        } else {
            dbManager.updateMessagesHistory(
                id = messageId,
                updates = mapOf(
                    "status" to SendStatus.FAILED_FINAL,
                    "last_attempt_at" to lastAttemptAt,
                    "attempt_count" to nextAttemptCount,
                )
            )
            Result.failure() // all failures are permanent, no retry needed
        }
    }

    // Router by providers for forwarding
    private fun processRule(
        rule: ForwardingRuleConfig,
        secret: String,
        type: String,
        sender: String,
        body: String,
        receivedAt: Long,
        labels: Map<String, String>
    ): SendProviderResult {
        return SendProviderGateway.send(
            providerId = rule.provider,
            configJson = rule.configJson ?: "",
            secret = secret,
            type = type,
            payload = SendProviderPayload(
                sender = sender,
                body = body,
                receivedAt = receivedAt,
                labels = labels,
            )
        )
    }

    private fun createForegroundNotification(): Notification {
        val manager = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = CHANNEL_ID

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "SMS Telebot worker",
                NotificationManager.IMPORTANCE_LOW
            )
            manager.createNotificationChannel(channel)
            Notification.Builder(applicationContext, channelId)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(applicationContext)
        }

        return builder
            .setContentTitle("SMS Telebot")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setOngoing(true)
            .build()
    }

    private fun hasValidatedInternet(): Boolean {
        val connectivityManager =
            applicationContext.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val activeNetwork = connectivityManager.activeNetwork ?: return false
        val capabilities = connectivityManager.getNetworkCapabilities(activeNetwork) ?: return false
        return capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) &&
            capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)
    }
}
