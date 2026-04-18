// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.provider.Telephony
import androidx.core.content.ContextCompat
import androidx.work.Constraints
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/**
 * Receives SMS and schedules its processing via WorkManager.
 */
class SmsReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return

        val permission = ContextCompat.checkSelfPermission(context, Manifest.permission.RECEIVE_SMS)
        if (permission != PackageManager.PERMISSION_GRANTED) return

        val dbManager = DbManager.getInstance(context)
        if (!dbManager.getBoolSetting("isRunning")) return
        if (!dbManager.getBoolSetting("forwardSms")) return

        // Call goAsync() to avoid blocking UI thread when reading/writing DB
        val pendingResult = goAsync()
        CoroutineScope(Dispatchers.IO).launch {
            try {
                processSms(context, intent)
            } finally {
                pendingResult.finish() // mandatory to finish BroadcastReceiver
            }
        }
    }

    private fun processSms(context: Context, intent: Intent) {
        val dbManager = DbManager.getInstance(context)

        // Extract all message parts, concatenate bodies for multipart SMS
        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        if (messages.isEmpty()) return

        val sender = messages[0].originatingAddress.orEmpty()
        val body = messages.joinToString(separator = "") { it.messageBody.orEmpty() }
        val timestamp = messages[0].timestampMillis

        if (sender.isBlank() || body.isBlank()) return

        // Within a 5-second window, the ID for the same sender/body will be the same
        val timeWindow = timestamp / 5000L
        val smsId = MessageHelpers.generateId("$sender|$timeWindow|$body")

        // Android/network may redeliver the same SMS back-to-back
        // If it's a duplicate, do not schedule background work
        if (dbManager.getMessageById(smsId) != null) return

        // Immediately save all SMS information to messages_history
        val deviceReceivedAt = System.currentTimeMillis()
        dbManager.insertMessagesHistory(
            id = smsId,
            type = "sms",
            sender = sender,
            body = body,
            sourceAt = timestamp,
            receivedAt = deviceReceivedAt,
            status = SendStatus.RECEIVED
        )

        // Get all active forwarding rules
        val activeRules = dbManager.getActiveRules()
        val matchedRuleIds = mutableListOf<Int>()

        // Iterate through all rules and check filters
        for (rule in activeRules) {
            if (rule.filterMode == 0) {
                // If filters are disabled, the rule automatically matches
                matchedRuleIds.add(rule.id)
            } else {
                // Decode JSON filters only if filterMode != 0
                val filters = MessageFilters.fromJson(rule.filtersJson)
                val isMatched = MessageFilters.checkFilters(
                    mode = rule.filterMode,
                    sender = sender,
                    body = body,
                    filters = filters
                )
                if (isMatched) matchedRuleIds.add(rule.id)
            }
        }
        if (matchedRuleIds.isEmpty()) return

        // Prepare WorkManager input, keep it minimal and serializable
        val inputData = Data.Builder()
            .putString("message_id", smsId)
            .putIntArray("rule_ids", matchedRuleIds.toIntArray())
            .build()

        // Require network for forwarding; if offline, WorkManager retries later
        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()

        // Expedited work tries to run ASAP; if quota is exceeded, it falls back
        val request = OneTimeWorkRequestBuilder<ForwardWorker>()
            .setInputData(inputData)
            .setConstraints(constraints)
            .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
            .addTag(ForwardWorker.TAG)
            .build()

        // Ensure only one work request is enqueued per SMS id
        WorkManager.getInstance(context).enqueueUniqueWork(
            "sms_forward:$smsId",
            ExistingWorkPolicy.KEEP,
            request
        )
    }
}
