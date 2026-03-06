package com.teslor.sms_telebot

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteException
import android.util.Log

data class SmsData(val sender: String, val body: String, val status: Int)
data class ForwardingRule(val id: Int, val filterMode: Int, val filtersJson: String?)
data class ForwardingRuleConfig(val id: Int, val provider: String, val configJson: String?)

class DbHelper private constructor(private val context: Context) {

    companion object {
        @Volatile
        private var instance: DbHelper? = null

        // Singleton pattern to keep a single DB instance for the whole app
        fun getInstance(context: Context): DbHelper = instance ?: synchronized(this) {
            instance ?: DbHelper(context.applicationContext).also { instance = it }
        }
    }

    // Try to open the database in read-write mode without creating it
    private fun openDatabase(): SQLiteDatabase? {
        val dbFile = context.getDatabasePath("sms_telebot.db")
        if (!dbFile.exists()) return null

        return try {
            SQLiteDatabase.openDatabase(dbFile.absolutePath, null, SQLiteDatabase.OPEN_READWRITE).apply {
                enableWriteAheadLogging() // Enable WAL mode for concurrent Dart/Kotlin access
                setForeignKeyConstraintsEnabled(true)
            }
        } catch (e: SQLiteException) {
            Log.e("DbHelper", "Error opening database. Maybe it doesn't exist yet", e)
            null
        }
    }

    // ================================================================================
    // APP_SETTINGS
    // ================================================================================

    // Read a specific setting by key
    fun getSetting(key: String): String? {
        return openDatabase()?.use { db ->
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
        return openDatabase()?.use { db ->
            db.query(
                "forwarding_rules",
                arrayOf("id", "filter_mode", "filters_json"),
                "is_active = 1",
                null, null, null, null
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

        return openDatabase()?.use { db ->
            db.query(
                "forwarding_rules",
                arrayOf("id", "provider", "config_json"),
                "id IN ($placeholders) AND is_active = 1",
                stringArgs, null, null, null
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
        return openDatabase()?.use { db ->
            db.query(
                "sms_history", arrayOf("sender", "body", "status"), "id = ?", arrayOf(id), null, null, null
            ).use {
                if (it.moveToFirst()) SmsData(it.getString(0), it.getString(1), it.getInt(2)) else null
            }
        }
    }

    // Get ID of the last received SMS
    fun getLastReceivedSmsId(): String? {
        return openDatabase()?.use { db ->
            db.query(
                "sms_history", arrayOf("id"), null, null, null, null, "received_at DESC", "1"
            ).use {
                if (it.moveToFirst()) it.getString(0) else null
            }
        }
    }

    // Create a new record
    fun insertSmsHistory(id: String, sender: String, body: String, smscAt: Long, receivedAt: Long, sentAt: Long? = null, status: Int = 0): Boolean {
        return openDatabase()?.use { db ->
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
        return openDatabase()?.use { db ->
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
        return openDatabase()?.use { db ->
            db.delete("sms_history", "received_at < ?", arrayOf(timestampLimit.toString()))
        } ?: 0
    }
}
