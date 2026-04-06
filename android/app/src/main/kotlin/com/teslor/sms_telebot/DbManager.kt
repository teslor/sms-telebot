// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteException
import android.util.Log

data class SmsData(val sender: String, val body: String, val status: Int)
data class ForwardingRule(val id: Int, val filterMode: Int, val filtersJson: String?)
data class ForwardingRuleConfig(val id: Int, val provider: String, val configJson: String?)

class DbManager private constructor(private val context: Context) {

    private val TAG = "Database"
    private val dbLock = Any()
    @Volatile
    private var database: SQLiteDatabase? = null

    companion object {
        @Volatile
        private var instance: DbManager? = null

        // Singleton pattern to keep a single DB instance for the whole app
        fun getInstance(context: Context): DbManager = instance ?: synchronized(this) {
            instance ?: DbManager(context.applicationContext).also { instance = it }
        }
    }

    // Open once and reuse the same connection across all calls
    private fun getOrOpenDatabase(): SQLiteDatabase? {
        database?.let { if (it.isOpen) return it }

        val mainDb = context.getDatabasePath("main.db")
        if (!mainDb.exists()) return null

        // Slow path: ensure only one thread opens/stores the connection
        synchronized(dbLock) {
            database?.let { if (it.isOpen) return it }

            return try {
                SQLiteDatabase.openDatabase(
                    mainDb.absolutePath,
                    null,
                    SQLiteDatabase.OPEN_READWRITE
                ).apply {
                    enableWriteAheadLogging()
                    setForeignKeyConstraintsEnabled(true)
                }.also { opened ->
                    database = opened
                }
            } catch (e: SQLiteException) {
                Log.e(TAG, "Error opening database. Maybe it doesn't exist yet", e)
                null
            }
        }
    }

    private inline fun <T> withDatabase(block: (SQLiteDatabase) -> T): T? {
        val db = getOrOpenDatabase() ?: return null
        return try {
            block(db)
        } catch (e: SQLiteException) {
            Log.e(TAG, "Database operation failed", e)
            null
        }
    }

    // ================================================================================
    // APP_SETTINGS
    // ================================================================================

    // Read a specific setting by key
    fun getSetting(key: String): String? {
        return withDatabase { db ->
            db.query(
                "app_settings", arrayOf("value"), "key = ?", arrayOf(key), null, null, null
            ).use {
                if (it.moveToFirst()) it.getString(0) else null
            }
        }
    }

    // Read a boolean setting
    fun getBoolSetting(key: String, defaultValue: Boolean = false): Boolean {
        return getSetting(key)?.let { it == "1" || it.equals("true", ignoreCase = true) } ?: defaultValue
    }

    // ================================================================================
    // FORWARDING_RULES
    // ================================================================================

    // Get all active rules for filtering
    fun getActiveRules(): List<ForwardingRule> {
        return withDatabase { db ->
            db.query(
                "forwarding_rules",
                arrayOf("id", "filter_mode", "filters_json"),
                "is_active = 1",
                null, null, null, "name ASC"
            ).use { cursor ->
                val list = mutableListOf<ForwardingRule>()
                while (cursor.moveToNext()) {
                    list.add(
                        ForwardingRule(
                            id = cursor.getInt(0),
                            filterMode = cursor.getInt(1),
                            filtersJson = cursor.getString(2)
                        )
                    )
                }
                list
            }
        } ?: emptyList()
    }

    // Get rules by IDs for forwarding
    fun getRulesByIds(ids: IntArray): List<ForwardingRuleConfig> {
        if (ids.isEmpty()) return emptyList()
        val placeholders = ids.joinToString(",") { "?" }
        val stringArgs = ids.map { it.toString() }.toTypedArray()

        return withDatabase { db ->
            db.query(
                "forwarding_rules",
                arrayOf("id", "provider", "config_json"),
                "id IN ($placeholders) AND is_active = 1",
                stringArgs, null, null, "name ASC"
            ).use { cursor ->
                val list = mutableListOf<ForwardingRuleConfig>()
                while (cursor.moveToNext()) {
                    list.add(
                        ForwardingRuleConfig(
                            id = cursor.getInt(0),
                            provider = cursor.getString(1),
                            configJson = cursor.getString(2)
                        )
                    )
                }
                list
            }
        } ?: emptyList()
    }

    // ================================================================================
    // SMS_HISTORY
    // ================================================================================

    // Get SMS data by ID
    fun getSmsById(id: String): SmsData? {
        return withDatabase { db ->
            db.query(
                "sms_history", arrayOf("sender", "body", "status"), "id = ?", arrayOf(id), null, null, null
            ).use {
                if (it.moveToFirst()) SmsData(it.getString(0), it.getString(1), it.getInt(2)) else null
            }
        }
    }

    // Get ID of the last received SMS
    fun getLastReceivedSmsId(): String? {
        return withDatabase { db ->
            db.query(
                "sms_history", arrayOf("id"), null, null, null, null, "received_at DESC", "1"
            ).use {
                if (it.moveToFirst()) it.getString(0) else null
            }
        }
    }

    // Create a new record
    fun insertSmsHistory(id: String, sender: String, body: String, smscAt: Long, receivedAt: Long, sentAt: Long? = null, status: Int = 0): Boolean {
        return withDatabase { db ->
            val values = ContentValues().apply {
                put("id", id); put("sender", sender); put("body", body); put("smsc_at", smscAt)
                put("received_at", receivedAt); put("sent_at", sentAt); put("status", status)
            }
            db.insertWithOnConflict("sms_history", null, values, SQLiteDatabase.CONFLICT_REPLACE) != -1L
        } ?: false
    }

    // Update a specific record by ID
    fun updateSmsHistory(id: String, updates: Map<String, Any?>): Boolean {
        if (updates.isEmpty()) return false
        return withDatabase { db ->
            val values = ContentValues().apply {
                updates.forEach { (k, v) ->
                    when (v) {
                        is String -> put(k, v); is Int -> put(k, v); is Long -> put(k, v)
                        is Boolean -> put(k, if (v) 1 else 0); is Float -> put(k, v); is Double -> put(k, v)
                        null -> putNull(k); else -> put(k, v.toString())
                    }
                }
            }
            db.update("sms_history", values, "id = ?", arrayOf(id)) > 0
        } ?: false
    }

    // Delete old SMS records
    fun deleteOldSms(timestampLimit: Long): Int {
        return withDatabase { db ->
            db.delete("sms_history", "received_at < ?", arrayOf(timestampLimit.toString()))
        } ?: 0
    }
}
