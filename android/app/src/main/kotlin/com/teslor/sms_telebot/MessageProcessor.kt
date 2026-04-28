// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.content.Context
import androidx.work.Constraints
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager

object MessageProcessor {

    fun processAndForward(
        context: Context,
        id: String,
        type: String,
        sender: String,
        body: String,
        sourceAt: Long,
        receivedAt: Long
    ) {
        val dbManager = DbManager.getInstance(context)

        // Check if the message has already been processed in its time window
        if (dbManager.getMessageById(id) != null) return

        // Save message data to messages_history
        dbManager.insertMessagesHistory(
            id = id,
            type = type,
            sender = sender,
            body = body,
            sourceAt = sourceAt,
            receivedAt = receivedAt,
            status = SendStatus.RECEIVED
        )

        // Get all active forwarding rules
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

        // Prepare WorkManager input
        val inputData = Data.Builder()
            .putString("message_id", id)
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

        // Ensure only one work request is enqueued per message id
        WorkManager.getInstance(context).enqueueUniqueWork(
            "$type:$id",
            ExistingWorkPolicy.KEEP,
            request
        )
    }
}
