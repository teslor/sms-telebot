// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.content.Context
import android.content.Intent
import android.os.Build
import android.telephony.SmsMessage
import android.telephony.SubscriptionInfo
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager

object SimInfoResolver {

    private val SLOT_KEYS = arrayOf(
        "slot", "android.telephony.extra.SLOT_INDEX", "slotId", "slot_id", "slotIdx",
        "simSlot", "sim_slot", "simslot", "simId", "sim_id", "simnum", "key_sim_slot",
        "phone_sim", "sim_index", "com.android.phone.extra.slot"
    )

    private val SUB_KEYS = arrayOf(
        "subscription", "android.telephony.extra.SUBSCRIPTION_INDEX",
        "subscription_id", "subId", "sub_id"
    )

    fun getInfo(
        context: Context,
        intent: Intent,
        smsMessages: Array<SmsMessage>? = null,
    ): String {
        val subscriptionManager = context.getSystemService(SubscriptionManager::class.java)
        val slotIndex = firstPresentIntExtra(intent, SLOT_KEYS)
        var subscriptionId = firstPresentIntExtra(intent, SUB_KEYS)
            ?: smsMessages?.firstOrNull()?.let { subIdFromSmsMessage(it) }

        // For incoming calls without SIM keys in intent (common case)
        if (smsMessages == null && subscriptionId == null) {
            subscriptionId = findRingingSubscriptionId(context, subscriptionManager)
        }

        val subscription = findSubscription(
            subscriptionManager = subscriptionManager,
            slotIndex = slotIndex,
            subscriptionId = subscriptionId,
            allowDefaultSms = smsMessages != null,
        )
        val simNumber = (subscription?.simSlotIndex ?: slotIndex)?.plus(1)
        val carrierName = subscription?.carrierName?.toString()?.takeIf { it.isNotBlank() }
            ?: subscription?.displayName?.toString()?.takeIf { it.isNotBlank() }

        val parts = mutableListOf<String>()
        if (simNumber != null) parts.add("SIM $simNumber")
        if (!carrierName.isNullOrBlank()) parts.add(carrierName)
        return parts.joinToString(" / ")
    }

    private fun firstPresentIntExtra(intent: Intent, keys: Array<String>): Int? {
        val extras = intent.extras ?: return null
        for (key in keys) {
            if (!extras.containsKey(key)) continue
            val intValue = when (val value = @Suppress("DEPRECATION") extras.get(key)) {
                is Number -> value.toInt()
                is String -> value.toIntOrNull()
                is IntArray -> value.firstOrNull()
                else -> null
            }
            if (intValue != null && intValue >= 0) return intValue
        }
        return null
    }

    // OEM-hidden API; often present when SMS intent extras omit subId
    private fun subIdFromSmsMessage(message: SmsMessage): Int? {
        return try {
            val method = message.javaClass.getMethod("getSubId")
            (method.invoke(message) as? Int)?.takeIf { it >= 0 }
        } catch (_: Exception) {
            null
        }
    }

    private fun findSubscription(
        subscriptionManager: SubscriptionManager?,
        slotIndex: Int?,
        subscriptionId: Int?,
        allowDefaultSms: Boolean,
    ): SubscriptionInfo? {
        if (subscriptionManager == null) return null

        return try {
            val subscriptions = subscriptionManager.activeSubscriptionInfoList.orEmpty()
            subscriptionId?.let { id -> subscriptions.firstOrNull { it.subscriptionId == id } }
                ?: slotIndex?.let { slot -> subscriptions.firstOrNull { it.simSlotIndex == slot } }
                ?: subscriptions.singleOrNull()
                ?: if (allowDefaultSms) {
                    defaultSmsSubscriptionId()?.let { id ->
                        subscriptions.firstOrNull { it.subscriptionId == id }
                    }
                } else {
                    null
                }
        } catch (_: SecurityException) {
            null
        }
    }

    private fun defaultSmsSubscriptionId(): Int? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) return null
        return SubscriptionManager.getDefaultSmsSubscriptionId().takeIf { it >= 0 }
    }

    // Find SIM card that is currently ringing (Android 7.0+)
    private fun findRingingSubscriptionId(
        context: Context,
        subscriptionManager: SubscriptionManager?
    ): Int? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N || subscriptionManager == null) return null
        val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager ?: return null

        return try {
            @Suppress("MissingPermission")
            val subscriptions = subscriptionManager.activeSubscriptionInfoList.orEmpty()
            if (subscriptions.isEmpty()) return null
            if (subscriptions.size == 1) return subscriptions.first().subscriptionId // only one SIM card

            var ringingSubId: Int? = null
            var ringingCount = 0

            for (subInfo in subscriptions) {
                val subTm = telephonyManager.createForSubscriptionId(subInfo.subscriptionId)
                @Suppress("DEPRECATION")
                val isRinging = subTm.callState == TelephonyManager.CALL_STATE_RINGING
                if (isRinging) {
                    ringingSubId = subInfo.subscriptionId
                    ringingCount++
                }
            }
            // Trust the status only if exactly 1 SIM card is ringing
            if (ringingCount == 1) ringingSubId else null
        } catch (_: Throwable) {
            null
        }
    }
}
