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
        // Extract all message parts, concatenate bodies for multipart SMS
        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        if (messages.isEmpty()) return

        val sender = messages[0].originatingAddress.orEmpty()
        val body = messages.joinToString(separator = "") { it.messageBody.orEmpty() }
        val timestamp = messages[0].timestampMillis
        if (sender.isBlank() || body.isBlank()) return

        // Android/network may redeliver the same SMS back-to-back
        // Within a 5-second window, the ID for the same sender/body will be the same
        val timeWindow = timestamp / 5000L
        val smsId = MessageHelpers.generateId("$sender|$body|$timeWindow")

        MessageProcessor.processAndForward(
            context = context,
            id = smsId,
            type = "sms",
            sender = sender,
            body = body,
            sourceAt = timestamp,
            receivedAt = System.currentTimeMillis()
        )
    }
}
