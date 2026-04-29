// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat

/**
 * Listens for system boot completion and app updates.
 * Restarts ForegroundService if it was enabled.
 */
class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return

        if (action == Intent.ACTION_BOOT_COMPLETED || 
            action == Intent.ACTION_MY_PACKAGE_REPLACED) {

            val dbManager = DbManager.getInstance(context)
            if (!dbManager.getBoolSetting("isRunning")) return
            if (!dbManager.getBoolSetting("enableForeground")) return

            val serviceIntent = Intent(context, ForegroundService::class.java)
            ContextCompat.startForegroundService(context, serviceIntent)
        }
    }
}
