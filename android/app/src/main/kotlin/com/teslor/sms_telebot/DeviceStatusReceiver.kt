// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.BatteryManager
import android.util.Log
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
 * Receives device status update (low battery, charger connected/disconnected)
 * and schedules its processing via WorkManager.
 */
class DeviceStatusReceiver : BroadcastReceiver() {

    private val sender = "System"

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return

        val dbManager = DbManager.getInstance(context)
        if (!dbManager.getBoolSetting("isRunning")) return

        val body = when (action) {
            Intent.ACTION_BATTERY_LOW -> {
                if (!dbManager.getBoolSetting("notifyLowBattery")) return
                val bm = context.getSystemService(Context.BATTERY_SERVICE) as? BatteryManager
                val level = bm
                    ?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                    ?.takeIf { it in 1..100 } ?: 15
                val l10nLowBattery = dbManager.getSetting("l10nLowBattery").orEmpty().ifBlank { "Low battery" }
                "$l10nLowBattery: $level%"
            }
            Intent.ACTION_POWER_CONNECTED -> {
                if (!dbManager.getBoolSetting("notifyChargerState")) return
                dbManager.getSetting("l10nChargerConnected").orEmpty().ifBlank { "Charger connected" }
            }
            Intent.ACTION_POWER_DISCONNECTED -> {
                if (!dbManager.getBoolSetting("notifyChargerState")) return
                dbManager.getSetting("l10nChargerDisconnected").orEmpty().ifBlank { "Charger disconnected" }
            }
            else -> return
        }

        val pendingResult = goAsync()
        CoroutineScope(Dispatchers.IO).launch {
            try {
                processSystemAlert(context, action, body)
            } finally {
                pendingResult.finish()
            }
        }
    }

    private fun processSystemAlert(context: Context, action: String, body: String) {
        val dbManager = DbManager.getInstance(context)

        // Within time window, the ID will be the same
        val windowMs = when (action) {
            Intent.ACTION_BATTERY_LOW -> 2 * 60 * 60 * 1000L // 2 hours
            else -> 5 * 60 * 1000L // 5 minutes
        }
        val now = System.currentTimeMillis()
        val timeWindow = now / windowMs
        val messageId = MessageHelpers.generateId("$sender|$timeWindow|$action")
        Log.d("DeviceStatusReceiver", "messageId: $messageId")

        // Check if the event has already been processed in the current window
        if (dbManager.getMessageById(messageId) != null) return

        // Save battery alert to messages_history
        dbManager.insertMessagesHistory(
            id = messageId,
            type = "sys",
            sender = sender,
            body = body,
            sourceAt = 0,
            receivedAt = now,
            status = SendStatus.RECEIVED
        )

        val activeRules = dbManager.getActiveRules()
        val matchedRuleIds = mutableListOf<Int>()

        // Iterate through all rules and check filters
        for (rule in activeRules) {
            if (rule.filterMode == 0) {
                matchedRuleIds.add(rule.id)
            } else {
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

        // Enqueue ForwardWorker
        val inputData = Data.Builder()
            .putString("message_id", messageId)
            .putIntArray("rule_ids", matchedRuleIds.toIntArray())
            .build()

        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()

        val request = OneTimeWorkRequestBuilder<ForwardWorker>()
            .setInputData(inputData)
            .setConstraints(constraints)
            .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
            .addTag(ForwardWorker.TAG)
            .build()

        WorkManager.getInstance(context).enqueueUniqueWork(
            "sys_forward:$messageId",
            ExistingWorkPolicy.KEEP,
            request
        )
    }
}
