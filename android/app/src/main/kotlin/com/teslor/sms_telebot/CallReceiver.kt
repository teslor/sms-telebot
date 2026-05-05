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

        val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager ?: return
        @Suppress("DEPRECATION")
        if (telephonyManager.callState != TelephonyManager.CALL_STATE_RINGING) return

        val dbManager = DbManager.getInstance(context)
        if (!dbManager.getBoolSetting("isRunning")) return
        if (!dbManager.getBoolSetting("forwardCalls")) return

        @Suppress("DEPRECATION")
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
        val sender = incomingNumber
        val now = System.currentTimeMillis()

        // System may send multiple RINGING broadcasts
        // Within a 30-second window, the ID for the same number will be the same
        val timeWindow = now / 30000L
        val callId = MessageHelpers.generateId("$sender|$timeWindow")

        MessageProcessor.processAndForward(
            context = context,
            id = callId,
            type = "call",
            sender = sender,
            body = "",
            sourceAt = now,
            receivedAt = now,
        )
    }
}
