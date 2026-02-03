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
                if (call.method != "checkFilters") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }

                val mode = call.argument<Int>("mode") ?: 0
                val sender = call.argument<String>("sender") ?: ""
                val sms = call.argument<String>("sms") ?: ""
                val wSenders = call.argument<List<String>>("wSenders") ?: emptyList()
                val wSms = call.argument<List<String>>("wSms") ?: emptyList()
                val bSenders = call.argument<List<String>>("bSenders") ?: emptyList()
                val bSms = call.argument<List<String>>("bSms") ?: emptyList()

                if (isDebugBuild()) {
                    Log.d("FiltersChannel", "checkFilters called (mode=$mode)")
                }

                val lists = SmsFilters.Lists(
                    wSenders = wSenders,
                    wSms = wSms,
                    bSenders = bSenders,
                    bSms = bSms
                )

                val ok = SmsFilters.checkFilters(
                    mode = mode,
                    sender = sender,
                    sms = sms,
                    filters = lists
                )

                result.success(ok)
            }
    }

    companion object {
        private const val FILTERS_CHANNEL = "sms_telebot/filters"
    }

    private fun isDebugBuild(): Boolean {
        return (applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0
    }
}
