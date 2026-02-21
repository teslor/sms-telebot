package com.teslor.sms_telebot

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import androidx.core.content.ContextCompat
import android.Manifest
import android.content.pm.PackageManager
import androidx.work.Constraints
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager

/**
 * Receives incoming SMS from the Android system.
 *
 * This receiver runs even if the Flutter UI process is not alive.
 * Its job is intentionally tiny: extract the SMS data and schedule
 * reliable background work via WorkManager.
 */
class SmsReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return

        val permission = ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.RECEIVE_SMS
        )
        if (permission != PackageManager.PERMISSION_GRANTED) return

        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val isRunning = prefs.getBoolean(SmsContract.Prefs.IS_RUNNING, false)
        if (!isRunning) return

        // Extract all message parts, for multipart SMS we concatenate bodies
        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        if (messages.isEmpty()) return

        val sender = messages[0].originatingAddress.orEmpty()
        val body = messages.joinToString(separator = "") { it.messageBody.orEmpty() }
        val timestamp = messages[0].timestampMillis

        if (sender.isBlank() || body.isBlank()) return

        val smsId = "$timestamp|${body.hashCode()}"

        // Android/network may redeliver the same SMS back-to-back
        // If it's a duplicate, do not schedule background work and do not bump counters
        val smsReceivedLastId = prefs.getString(SmsContract.Prefs.SMS_RECEIVED_LAST_ID, null)
        if (smsId == smsReceivedLastId) return

        updateReceivedStats(prefs, smsId)

        // Check user-defined filters to decide whether this SMS should be forwarded
        val filterMode = try {
            prefs.getInt(SmsContract.Prefs.FILTER_MODE, 0)
        } catch (_: ClassCastException) {
            prefs.getLong(SmsContract.Prefs.FILTER_MODE, 0L).toInt()
        }
        val filters = SmsFilters.fromPrefs(prefs)
        val shouldSend = SmsFilters.checkFilters(
            mode = filterMode,
            sender = sender,
            sms = body,
            filters = filters
        )
        if (!shouldSend) return

        // Prepare WorkManager input, keep it minimal and serializable
        val inputData = Data.Builder()
            .putString(SmsForwardWorker.KEY_SENDER, sender)
            .putString(SmsForwardWorker.KEY_BODY, body)
            .putLong(SmsForwardWorker.KEY_TIMESTAMP, timestamp)
            .build()

        // Require network for sending to Telegram; if offline, WorkManager retries later
        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()

        // Expedited work tries to run ASAP; if quota is exceeded, it falls back
        val request = OneTimeWorkRequestBuilder<SmsForwardWorker>()
            .setInputData(inputData)
            .setConstraints(constraints)
            .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
            .addTag(SmsForwardWorker.TAG)
            .build()

        // Ensure only one work request is enqueued per SMS id
        val uniqueWorkName = "sms_forward:$smsId"
        WorkManager.getInstance(context).enqueueUniqueWork(
            uniqueWorkName,
            ExistingWorkPolicy.KEEP,
            request
        )
    }

    private fun updateReceivedStats(
        prefs: android.content.SharedPreferences,
        smsId: String
    ) {
        // SharedPreferences may store Dart int as Long, so fallback to getLong
        var receivedCount = try {
            prefs.getInt(SmsContract.Prefs.SMS_RECEIVED_COUNT, 0)
        } catch (_: ClassCastException) {
            prefs.getLong(SmsContract.Prefs.SMS_RECEIVED_COUNT, 0L).toInt()
        }

        receivedCount += 1

        prefs.edit()
            .putInt(SmsContract.Prefs.SMS_RECEIVED_COUNT, receivedCount)
            .putString(SmsContract.Prefs.SMS_RECEIVED_LAST_ID, smsId)
            .apply()
    }
}
