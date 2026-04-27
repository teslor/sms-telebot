// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.telephony.TelephonyManager
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
 * Receives incoming call and schedules its processing via WorkManager.
 */
class CallReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != TelephonyManager.ACTION_PHONE_STATE_CHANGED) return

        // Catch only the moment when the call starts (when the phone rings)
        val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE)
        if (state != TelephonyManager.EXTRA_STATE_RINGING) return

        // Check permissions (for Android 9+ READ_CALL_LOG is required to get the number)
        val statePerm = ContextCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE)
        val logPerm = ContextCompat.checkSelfPermission(context, Manifest.permission.READ_CALL_LOG)
        if (statePerm != PackageManager.PERMISSION_GRANTED || logPerm != PackageManager.PERMISSION_GRANTED) return

        val dbManager = DbManager.getInstance(context)
        if (!dbManager.getBoolSetting("isRunning")) return
        if (!dbManager.getBoolSetting("forwardCalls")) return

        val incomingNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)
        if (incomingNumber.isNullOrBlank()) return

        // Call goAsync() to avoid blocking UI thread when reading/writing DB
        val pendingResult = goAsync()
        CoroutineScope(Dispatchers.IO).launch {
            try {
                processCall(context, incomingNumber)
            } finally {
                pendingResult.finish() // mandatory to finish BroadcastReceiver
            }
        }
    }

    private fun processCall(context: Context, incomingNumber: String) {
        val dbManager = DbManager.getInstance(context)

        val sender = incomingNumber
        val body = ""
        val timestamp = System.currentTimeMillis()

        // Within a 30-second window, the ID for the same number will be the same
        // System may send multiple RINGING broadcasts
        val timeWindow = timestamp / 30000L
        val callId = MessageHelpers.generateId("$sender|$timeWindow")

        if (dbManager.getMessageById(callId) != null) return

        // Save call information to messages_history
        dbManager.insertMessagesHistory(
            id = callId,
            type = "call",
            sender = sender,
            body = body,
            sourceAt = timestamp,
            receivedAt = timestamp,
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
            .putString("message_id", callId)
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

        // Ensure only one work request is enqueued per call id
        WorkManager.getInstance(context).enqueueUniqueWork(
            "call_forward:$callId",
            ExistingWorkPolicy.KEEP,
            request
        )
    }
}
