// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

/**
 * Runs permanently in the background and provides a notification.
 */
class ForegroundService : Service() {

    companion object {
        private const val CHANNEL_ID = "sms_telebot_foreground"
        private const val NOTIFICATION_ID = 1002
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val launchIntent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        val contentIntent = PendingIntent.getActivity(
            this, 0, launchIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val dbManager = DbManager.getInstance(this)
        val serviceTitle = dbManager.getSetting("l10nServiceTitle") ?: "SMS Telebot is active"
        val serviceText = dbManager.getSetting("l10nServiceText") ?: "Monitoring events"

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(serviceTitle)
            .setContentText(serviceText)
            .setSmallIcon(R.drawable.ic_notification)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
            .setContentIntent(contentIntent)
            .build()

        // Repeated starts are safe: Android updates the same foreground notification
        startForeground(NOTIFICATION_ID, notification)

        // Restart service after process termination if needed
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    // Create a notification channel for Android 8.0+
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val channel = NotificationChannel(
            CHANNEL_ID,
            "SMS Telebot foreground",
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            setShowBadge(false)
        }
        getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
    }
}
