package com.teslor.sms_telebot

import android.content.pm.ApplicationInfo
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FILTERS_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (isDebugBuild()) Log.d("FiltersChannel", "${call.method} called")

                when (call.method) {
                    "checkFilters" -> {
                        val mode = call.argument<Int>("mode") ?: 0
                        val sender = call.argument<String>("sender") ?: ""
                        val sms = call.argument<String>("sms") ?: ""
                        val whitelist_senders = call.argument<List<String>>("whitelist_senders") ?: emptyList()
                        val whitelist_body = call.argument<List<String>>("whitelist_body") ?: emptyList()
                        val blacklist_senders = call.argument<List<String>>("blacklist_senders") ?: emptyList()
                        val blacklist_body = call.argument<List<String>>("blacklist_body") ?: emptyList()

                        val lists = SmsFilters.Lists(
                            whitelist_senders = whitelist_senders,
                            whitelist_body = whitelist_body,
                            blacklist_senders = blacklist_senders,
                            blacklist_body = blacklist_body
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
        private const val FILTERS_CHANNEL = "sms_telebot/filters"
    }

    private fun isDebugBuild(): Boolean {
        return (applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0
    }
}
