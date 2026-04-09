// Copyright (c) 2025-2026 Pavel D. (teslor)
// SPDX-License-Identifier: AGPL-3.0-or-later

package com.teslor.sms_telebot

import android.content.pm.ApplicationInfo
import android.util.Log
import androidx.lifecycle.lifecycleScope
import androidx.work.WorkManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : FlutterActivity() {

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
                                val sendResult = SmsProviderGateway.send(
                                    providerId = provider,
                                    configJson = configJson,
                                    secret = secret,
                                    payload = SmsForwardPayload(
                                        sender = sender,
                                        body = body,
                                        deviceLabel = deviceLabel,
                                        l10nSmsFrom = ""
                                    )
                                )

                                withContext(Dispatchers.Main) {
                                    result.success(sendResult.toMap())
                                }
                            } catch (e: Exception) {
                                withContext(Dispatchers.Main) {
                                    result.success(
                                        ProviderSendResult(
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
                        val sms = call.argument<String>("sms") ?: ""
                        val whitelistSenders = call.argument<List<String>>("whitelistSenders") ?: emptyList()
                        val whitelistBody = call.argument<List<String>>("whitelistBody") ?: emptyList()
                        val blacklistSenders = call.argument<List<String>>("blacklistSenders") ?: emptyList()
                        val blacklistBody = call.argument<List<String>>("blacklistBody") ?: emptyList()

                        val lists = SmsFilters.Lists(
                            whitelistSenders = whitelistSenders,
                            whitelistBody = whitelistBody,
                            blacklistSenders = blacklistSenders,
                            blacklistBody = blacklistBody
                        )

                        val ok = SmsFilters.checkFilters(
                            mode = mode,
                            sender = sender,
                            sms = sms,
                            filters = lists
                        )

                        result.success(ok)
                    }
                    "isValidRegex" -> {
                        val text = call.argument<String>("text") ?: ""
                        val isValid = SmsFilters.isValidRegex(text)
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

                    "stopWorkers" -> {
                        WorkManager.getInstance(applicationContext).cancelAllWork()
                        result.success(true)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    companion object {
        private const val MAIN_CHANNEL = "sms_telebot/main"
    }

    private fun isDebugBuild(): Boolean {
        return (applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0
    }
}
