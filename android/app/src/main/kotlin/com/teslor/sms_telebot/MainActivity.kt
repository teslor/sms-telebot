package com.teslor.sms_telebot

import android.content.pm.ApplicationInfo
import android.util.Log
import androidx.lifecycle.lifecycleScope
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MAIN_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (isDebugBuild()) Log.d("MainChannel", "${call.method} called")

                when (call.method) {
                    "sendToTelegramBot" -> {
                        val configJson = call.argument<String>("configJson")
                        val sender = call.argument<String>("sender") ?: ""
                        val body = call.argument<String>("body") ?: ""
                        val deviceLabel = call.argument<String>("deviceLabel") ?: ""
                        val l10nSmsFrom = call.argument<String>("l10nSmsFrom") ?: ""

                        lifecycleScope.launch(Dispatchers.IO) {
                            try {
                                val ok = TelegramBotProvider.send(
                                    configJson = configJson,
                                    payload = SmsForwardPayload(
                                        sender = sender,
                                        body = body,
                                        deviceLabel = deviceLabel,
                                        l10nSmsFrom = l10nSmsFrom
                                    )
                                )

                                withContext(Dispatchers.Main) {
                                    result.success(ok)
                                }
                            } catch (e: Exception) {
                                withContext(Dispatchers.Main) {
                                    result.error("send_to_telegram_failed", e.message, null)
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
