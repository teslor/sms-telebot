// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.pm.ServiceInfo
import android.os.Build
import androidx.work.CoroutineWorker
import androidx.work.ForegroundInfo
import androidx.work.WorkerParameters
import kotlinx.coroutines.CancellationException
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

        // Check if message exists and was not already sent
        val messageData = dbManager.getMessageById(messageId) ?: return@withContext Result.failure()
        val shouldBeProcessed =
            messageData.status == SendStatus.RECEIVED || messageData.status == SendStatus.FAILED_RETRY
        if (!shouldBeProcessed) return@withContext Result.success() // already processed

        // Get rules from DB
        val rules = dbManager.getRulesByIds(ruleIds)
        if (rules.isEmpty()) return@withContext Result.success()

        // Get labels, required for formatting
        val labels = mapOf(
            "deviceLabel" to dbManager.getSetting("deviceLabel").orEmpty(),
            "l10nSms" to dbManager.getSetting("l10nSms").orEmpty().ifBlank { "SMS" },
            "l10nCall" to dbManager.getSetting("l10nCall").orEmpty().ifBlank { "Call" },
        )

        val lastAttemptAt = System.currentTimeMillis()
        val newAttemptCount = messageData.attemptCount + 1
        val sendResults = mutableListOf<SendProviderResult>()
        var hasSuccessfulSends = false

        // Start parallel sending within each priority group
        // Lower priority rules are processed only if all higher priority rules failed
        val ruleNames = rules.joinToString(", ") { it.name }
        val senderMask = messageData.sender.let { if (it.length > 4) "${it.take(2)}***${it.takeLast(2)}" else "***" }
        AppLog.i(TAG, "Start processing message (type=${messageData.type}, sender=$senderMask, len=${messageData.body.length}, rules=\"$ruleNames\")")
        for ((priority, priorityRules) in rules.groupBy { it.priority }.toSortedMap()) { // keep priority order explicit
            val groupResults = coroutineScope {
                priorityRules.map { rule ->
                    async {
                        sendSemaphore.withPermit {
                            try {
                                val secret = if (rule.provider == SendProviderId.SMS_GATEWAY) {
                                    ""
                                } else {
                                    val secretResult = secretStorage.readSecret(rule.id.toString())
                                    if (secretResult.isSuccess) secretResult.data ?: "" else ""
                                }
                                processRule(
                                    rule, secret,
                                    messageData.type, messageData.sender, messageData.body,
                                    messageData.simInfo, messageData.receivedAt, labels
                                )
                            } catch (e: CancellationException) {
                                throw e
                            } catch (e: Exception) {
                                AppLog.e(TAG, "Rule failed with exception (name=${rule.name})", e)
                                SendProviderResult(isSuccess = false, code = "", info = "")
                            }
                        }
                    }
                }.awaitAll()
            }

            sendResults.addAll(groupResults)
            val groupHasSuccess = groupResults.any { it.isSuccess }
            AppLog.d(TAG) { "Priority group processed (priority=$priority, success=$groupHasSuccess, messageId=$messageId)" }
            if (groupHasSuccess) {
                hasSuccessfulSends = true
                break
            }
        }

        return@withContext if (hasSuccessfulSends) {
            val successCount = sendResults.count { it.isSuccess }
            val newStatus = if (successCount == sendResults.size) {
                SendStatus.SENT_ALL
            } else {
                SendStatus.SENT_PARTIAL
            }

            dbManager.updateMessagesHistory(
                id = messageId,
                updates = mapOf(
                    "status" to newStatus,
                    "sent_at" to System.currentTimeMillis(),
                    "last_attempt_at" to lastAttemptAt,
                    "attempt_count" to newAttemptCount,
                )
            )
            Result.success()
        } else if (sendResults.any { !it.isSuccess && it.shouldRetry }) {
            dbManager.updateMessagesHistory(
                id = messageId,
                updates = mapOf(
                    "status" to SendStatus.FAILED_RETRY,
                    "last_attempt_at" to lastAttemptAt,
                    "attempt_count" to newAttemptCount,
                )
            )
            Result.retry() // retry only when at least one failure is temporary
        } else {
            dbManager.updateMessagesHistory(
                id = messageId,
                updates = mapOf(
                    "status" to SendStatus.FAILED_FINAL,
                    "last_attempt_at" to lastAttemptAt,
                    "attempt_count" to newAttemptCount,
                )
            )
            Result.failure() // all failures are permanent, no retry needed
        }
    }

    // Router by providers for forwarding
    private fun processRule(
        rule: ForwardingRuleConfig, secret: String, type: String, sender: String,
        body: String, simInfo: String?, receivedAt: Long, labels: Map<String, String>
    ): SendProviderResult {
        return SendProviderGateway.send(
            context = applicationContext,
            providerId = rule.provider,
            configJson = rule.configJson ?: "",
            secret = secret,
            type = type,
            payload = SendProviderPayload(
                sender = sender,
                body = body,
                simInfo = simInfo,
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
}
