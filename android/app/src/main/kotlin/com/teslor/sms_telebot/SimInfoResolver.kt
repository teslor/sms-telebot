// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.content.Context
import android.content.Intent
import android.telephony.SubscriptionInfo
import android.telephony.SubscriptionManager

object SimInfoResolver {

    private val SLOT_KEYS = arrayOf(
        "slot", "android.telephony.extra.SLOT_INDEX", "slotId", "slot_id", "slotIdx",
        "simSlot", "sim_slot", "simslot", "simId", "sim_id", "simnum", "key_sim_slot",
        "phone_sim", "sim_index", "phone", "phoneId", "com.android.phone.extra.slot"
    )

    private val SUB_KEYS = arrayOf(
        "subscription", "android.telephony.extra.SUBSCRIPTION_INDEX",
        "subscription_id", "subId", "sub_id"
    )

    fun getInfo(context: Context, intent: Intent): String {
        val subscriptionManager = context.getSystemService(SubscriptionManager::class.java)
        val slotIndex = firstPresentIntExtra(intent, SLOT_KEYS)
        val subscriptionId = firstPresentIntExtra(intent, SUB_KEYS)
        val subscription = findSubscription(subscriptionManager, slotIndex, subscriptionId)
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
            val intValue = when (val value = @Suppress("DEPRECATION") extras.get(key)) {
                is Number -> value.toInt()
                is String -> value.toIntOrNull()
                else -> null
            }
            if (intValue != null) return intValue
        }
        return null
    }

    private fun findSubscription(
        subscriptionManager: SubscriptionManager?,
        slotIndex: Int?,
        subscriptionId: Int?
    ): SubscriptionInfo? {
        if (subscriptionManager == null) return null

        return try {
            val subscriptions = subscriptionManager.activeSubscriptionInfoList.orEmpty()
            val bySubscription = subscriptionId?.let {
                id -> subscriptions.firstOrNull { it.subscriptionId == id }
            }
            val bySlot = slotIndex?.let { 
                slot -> subscriptions.firstOrNull { it.simSlotIndex == slot }
            }
            val bySingleSubscription = subscriptions.singleOrNull()

            bySubscription ?: bySlot ?: bySingleSubscription
        } catch (_: SecurityException) {
            null
        }
    }
}
