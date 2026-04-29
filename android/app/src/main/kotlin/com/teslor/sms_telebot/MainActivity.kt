// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.content.Intent
import android.content.pm.ApplicationInfo
import android.util.Log
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import androidx.work.WorkManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/**
 * Main activity that handles method calls from Flutter.
 */
class MainActivity : FlutterActivity() {

    companion object {
        private const val MAIN_CHANNEL = "sms_telebot/main"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val secureStorage = SecureStorageManager.getInstance(context)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MAIN_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (isDebugBuild()) Log.d("MainChannel", "${call.method} called")

                when (call.method) {
                    "sendToProvider" -> {
                        val provider = call.argument<String>("provider") ?: ""
                        val configJson = call.argument<String>("configJson") ?: ""
                        val secret = call.argument<String>("secret") ?: ""
                        val sender = call.argument<String>("sender") ?: ""
                        val body = call.argument<String>("body") ?: ""
                        val deviceLabel = call.argument<String>("deviceLabel") ?: ""

                        lifecycleScope.launch(Dispatchers.IO) {
                            try {
                                val sendResult = SendProviderGateway.send(
                                    providerId = provider,
                                    configJson = configJson,
                                    secret = secret,
                                    type = "app",
                                    payload = SendProviderPayload(
                                        sender = sender,
                                        body = body,
                                        receivedAt = System.currentTimeMillis(),
                                        labels = mapOf(
                                            "deviceLabel" to deviceLabel,
                                        ),
                                    )
                                )

                                withContext(Dispatchers.Main) {
                                    result.success(sendResult.toMap())
                                }
                            } catch (e: Exception) {
                                withContext(Dispatchers.Main) {
                                    result.success(
                                        SendProviderResult(
                                            isSuccess = false,
                                            code = ResultCode.UNEXPECTED_ERROR,
                                            info = e.message ?: "Unexpected error"
                                        ).toMap()
                                    )
                                }
                            }
                        }
                    }

                    "checkFilters" -> {
                        val mode = call.argument<Int>("mode") ?: 0
                        val sender = call.argument<String>("sender") ?: ""
                        val body = call.argument<String>("body") ?: ""
                        val whitelistSenders = call.argument<List<String>>("whitelistSenders") ?: emptyList()
                        val whitelistBody = call.argument<List<String>>("whitelistBody") ?: emptyList()
                        val blacklistSenders = call.argument<List<String>>("blacklistSenders") ?: emptyList()
                        val blacklistBody = call.argument<List<String>>("blacklistBody") ?: emptyList()

                        val lists = MessageFilters.Lists(
                            whitelistSenders = whitelistSenders,
                            whitelistBody = whitelistBody,
                            blacklistSenders = blacklistSenders,
                            blacklistBody = blacklistBody
                        )

                        val ok = MessageFilters.checkFilters(
                            mode = mode,
                            sender = sender,
                            body = body,
                            filters = lists
                        )

                        result.success(ok)
                    }
                    "isValidRegex" -> {
                        val text = call.argument<String>("text") ?: ""
                        val isValid = MessageFilters.isValidRegex(text)
                        result.success(isValid)
                    }

                    "saveSecret" -> {
                        val id = call.argument<String>("id")
                        val secret = call.argument<String>("secret")
                        if (id != null && secret != null) {
                            val saveResult = secureStorage.saveSecret(id, secret)
                            result.success(saveResult.toMap())
                        } else {
                            result.success(SecretResult(isSuccess = false, code = ResultCode.UNEXPECTED_ERROR).toMap())
                        }
                    }
                    "readSecret" -> {
                        val id = call.argument<String>("id")
                        if (id != null) {
                            val readResult = secureStorage.readSecret(id)
                            result.success(readResult.toMap())
                        } else {
                            result.success(SecretResult(isSuccess = false, code = ResultCode.UNEXPECTED_ERROR).toMap())
                        }
                    }
                    "deleteSecret" -> {
                        val id = call.argument<String>("id")
                        if (id != null) {
                            val deleteResult = secureStorage.deleteSecret(id)
                            result.success(deleteResult.toMap())
                        } else {
                            result.success(SecretResult(isSuccess = false, code = ResultCode.UNEXPECTED_ERROR).toMap())
                        }
                    }

                    "startForegroundService" -> {
                        try {
                            ContextCompat.startForegroundService(
                                this, Intent(this, ForegroundService::class.java)
                            )
                            result.success(null)
                        } catch (e: SecurityException) {
                            Log.e("MainChannel", "SecurityException while starting ForegroundService", e)
                            result.error("security_exception", e.message, null)
                        } catch (e: IllegalStateException) {
                            Log.e("MainChannel", "ForegroundService start is not allowed in the current app state", e)
                            result.error("service_start_not_allowed", e.message, null)
                        } catch (e: Exception) {
                            Log.e("MainChannel", "Unexpected error while starting ForegroundService", e)
                            result.error("unexpected_error", e.message, null)
                        }
                    }
                    "stopForegroundService" -> {
                        stopService(Intent(this, ForegroundService::class.java))
                        result.success(null)
                    }
                    "stopWorkers" -> {
                        WorkManager.getInstance(applicationContext).cancelAllWork()
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun isDebugBuild(): Boolean {
        return (applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0
    }
}
