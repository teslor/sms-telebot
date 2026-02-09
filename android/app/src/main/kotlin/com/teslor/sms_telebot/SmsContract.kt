package com.teslor.sms_telebot

object SmsContract {

    // SharedPreferences keys
    object Prefs {
        private const val P = "flutter."

        // General
        const val IS_RUNNING = "${P}isRunning"

        // Settings
        const val BOT_TOKEN = "${P}botToken"
        const val CHAT_ID = "${P}chatId"
        const val DEVICE_LABEL = "${P}deviceLabel"
        const val FILTER_MODE = "${P}filterMode"
        val FILTER_KEYS = listOf("${P}wSenders", "${P}wSms", "${P}bSenders", "${P}bSms")
        const val L10N_SMS_FROM = "${P}l10nSmsFrom"

        // Received SMS
        const val SMS_RECEIVED_COUNT = "${P}smsReceivedCount"
        const val SMS_RECEIVED_LAST_ID = "${P}smsReceivedLastId"

        // Sent (forwarded) SMS
        const val SMS_SENT_COUNT = "${P}smsSentCount"
        const val SMS_SENT_LAST_IDS = "${P}smsSentLastIds"
        const val SMS_SENT_LAST_ID = "${P}smsSentLastId"
        const val SMS_SENT_LAST_DATA = "${P}smsSentLastData"

        const val CAP_LAST_IDS = 20
    }
}
