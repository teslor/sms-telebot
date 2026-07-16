// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.content.Context
import android.content.SharedPreferences
import androidx.core.content.edit
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import java.io.File
import java.security.KeyStore

data class SecretResult(
    val isSuccess: Boolean,
    val code: String,
    val data: String? = null
) {
    fun toMap(): Map<String, Any?> {
        return mapOf(
            "isSuccess" to isSuccess,
            "code" to code,
            "data" to data
        )
    }
}

@Suppress("DEPRECATION")
class SecureStorageManager private constructor(context: Context) {

    // Use applicationContext to avoid memory leaks when called from background services and workers
    private val appContext = context.applicationContext

    @Volatile
    private var recoveredWithDataLoss = false

    private val sharedPreferences: SharedPreferences? by lazy {
        initSecurePrefs()
    }

    companion object {
        private const val TAG = "SecureStorage"
        private const val PREFS_FILENAME = "secrets"

        @Volatile
        private var instance: SecureStorageManager? = null

        fun getInstance(context: Context): SecureStorageManager {
            return instance ?: synchronized(this) {
                instance ?: SecureStorageManager(context).also { instance = it }
            }
        }
    }

    private fun initSecurePrefs(): SharedPreferences? {
        return try {
            recoveredWithDataLoss = false
            createSecurePrefs()
        } catch (e: Exception) {
            resetSecurePrefs(e) // recreate with data loss
        }
    }

    private fun createSecurePrefs(): SharedPreferences {
        val masterKey = MasterKey.Builder(appContext)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
            .build()

        return EncryptedSharedPreferences.create(
            appContext, PREFS_FILENAME, masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )
    }

    private fun resetSecurePrefs(cause: Throwable): SharedPreferences? {
        AppLog.e(TAG, "Failed to initialize secure storage; recreating", cause)

        // Step 1: remove corrupted encrypted prefs file and retry
        clearCorruptedPrefsFile()
        try {
            val prefs = createSecurePrefs()
            recoveredWithDataLoss = true
            AppLog.w(TAG, "Recovered after prefs cleanup; encrypted data is no longer available")
            return prefs
        } catch (e: Exception) {
            AppLog.e(TAG, "Failed to recover after prefs cleanup; started keystore reset", e)
        }

        // Step 2: reset master key alias and recreate storage from scratch
        clearMasterKeyAlias()
        clearCorruptedPrefsFile()
        return try {
            val prefs = createSecurePrefs()
            recoveredWithDataLoss = true
            AppLog.w(TAG, "Recovered after Keystore reset; encrypted data is no longer available")
            prefs
        } catch (e: Exception) {
            AppLog.e(TAG, "Failed to recreate secure storage after Keystore reset", e)
            null
        }
    }

    private fun clearCorruptedPrefsFile() {
        try {
            val parentPath = appContext.filesDir.parent
            if (parentPath == null) {
                AppLog.w(TAG, "Cannot clear corrupted prefs: parent dir is null")
                return
            }

            val dir = File(parentPath, "shared_prefs")
            val file = File(dir, "$PREFS_FILENAME.xml")

            if (file.exists()) {
                val deleted = file.delete()
                if (deleted) {
                    AppLog.i(TAG, "Corrupted storage file deleted")
                } else {
                    AppLog.w(TAG, "Failed to delete corrupted storage file")
                }
            }
        } catch (e: Exception) {
            AppLog.e(TAG, "Failed to delete corrupted storage file", e)
        }
    }

    private fun clearMasterKeyAlias() {
        try {
            val keyStore = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
            val alias = MasterKey.DEFAULT_MASTER_KEY_ALIAS
            if (keyStore.containsAlias(alias)) {
                keyStore.deleteEntry(alias)
                AppLog.i(TAG, "Master key alias deleted: $alias")
            }
        } catch (e: Exception) {
            AppLog.e(TAG, "Failed to delete master key alias", e)
        }
    }

    // Save a secret (password, token etc.)
    fun saveSecret(id: String, secret: String): SecretResult {
        val prefs = sharedPreferences ?: return SecretResult(isSuccess = false, code = ResultCode.SECRETS_ERROR)
        return try {
            prefs.edit { putString(id, secret) }
            SecretResult(isSuccess = true, code = ResultCode.OK)
        } catch (e: Exception) {
            AppLog.e(TAG, "Failed to write secret (id=$id)", e)
            SecretResult(isSuccess = false, code = ResultCode.SECRETS_ERROR)
        }
    }

    // Read a secret
    fun readSecret(id: String): SecretResult {
        val prefs = sharedPreferences ?: return SecretResult(isSuccess = false, code = ResultCode.SECRETS_ERROR)
        return try {
            val value = prefs.getString(id, null)
            if (recoveredWithDataLoss && value == null) {
                SecretResult(isSuccess = false, code = ResultCode.SECRETS_RECOVERED)
            } else {
                SecretResult(isSuccess = true, code = ResultCode.OK, data = value)
            }
        } catch (e: Exception) {
            AppLog.e(TAG, "Failed to read secret (id=$id)", e)
            SecretResult(isSuccess = false, code = ResultCode.SECRETS_ERROR)
        }
    }

    // Delete a secret
    fun deleteSecret(id: String): SecretResult {
        val prefs = sharedPreferences ?: return SecretResult(isSuccess = false, code = ResultCode.SECRETS_ERROR)
        return try {
            prefs.edit { remove(id) }
            SecretResult(isSuccess = true, code = ResultCode.OK)
        } catch (e: Exception) {
            AppLog.e(TAG, "Failed to delete secret (id=$id)", e)
            SecretResult(isSuccess = false, code = ResultCode.SECRETS_ERROR)
        }
    }
}
