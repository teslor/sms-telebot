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
import kotlin.random.Random
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

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

        // Call goAsync() to avoid blocking UI thread when reading/writing DB
        val pendingResult = goAsync()

        CoroutineScope(Dispatchers.IO).launch {
            try {
                processSmsInBackground(context, intent)
            } finally {
                pendingResult.finish() // mandatory to finish BroadcastReceiver
            }
        }
    }

    private fun processSmsInBackground(context: Context, intent: Intent) {
        val dbHelper = DbHelper.getInstance(context)
        val isRunning = dbHelper.getBoolSetting("is_running")
        if (!isRunning) return

        // Extract all message parts, for multipart SMS we concatenate bodies
        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        if (messages.isEmpty()) return

        val sender = messages[0].originatingAddress.orEmpty()
        val body = messages.joinToString(separator = "") { it.messageBody.orEmpty() }
        val timestamp = messages[0].timestampMillis

        if (sender.isBlank() || body.isBlank()) return

        // Within a 5 second window, the ID for the same sender/body will be the same
        val timeWindow = timestamp / 5000L
        val smsId = "$sender|$timeWindow|${body.hashCode()}"

        // Android/network may redeliver the same SMS back-to-back
        // If it's a duplicate, do not schedule background work
        val lastReceivedId = dbHelper.getLastReceivedSmsId()
        if (smsId == lastReceivedId) return

        // Immediately save all SMS information to sms_history
        dbHelper.insertSmsHistory(
            id = smsId,
            sender = sender,
            body = body,
            receivedAt = timestamp,
            status = 0 // 0 = received, not yet sent
        )

        // Cleanup old SMS with 10% probability
        if (Random.nextInt(10) == 0) {
            // Take current device time minus 24 hours in milliseconds
            val timeLimit = System.currentTimeMillis() - (24 * 60 * 60 * 1000L)
            dbHelper.deleteOldSms(timeLimit)
        }

        // Get all active forwarding rules
        val activeRules = dbHelper.getActiveRules()
        val matchedRuleIds = mutableListOf<Int>()

        // Iterate through all rules and check filters
        for (rule in activeRules) {
            if (rule.filterMode == 0) {
                // If filters are disabled, the rule automatically matches
                matchedRuleIds.add(rule.id)
            } else {
                // Decode JSON filters only if filterMode != 0
                val filters = SmsFilters.fromJson(rule.filtersJson)
                val isMatched = SmsFilters.checkFilters(
                    mode = rule.filterMode,
                    sender = sender,
                    sms = body,
                    filters = filters
                )
                if (isMatched) matchedRuleIds.add(rule.id)
            }
        }

        // If no rule passes filtering, break the process
        if (matchedRuleIds.isEmpty()) return

        // Prepare WorkManager input, keep it minimal and serializable
        val inputData = Data.Builder()
            .putString("sms_id", smsId)
            .putIntArray("rule_ids", matchedRuleIds.toIntArray())
            .build()

        // Require network for forwarding; if offline, WorkManager retries later
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
}
