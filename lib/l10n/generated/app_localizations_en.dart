// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sms => 'SMS';

  @override
  String get sms_welcome => 'Tap Start to begin\nforwarding SMS';

  @override
  String get sms_empty => 'No incoming SMS\nin current session';

  @override
  String get sms_hello => 'Hello from SMS Telebot! =^•⩊•^=';

  @override
  String get sms_from => 'SMS from';

  @override
  String get sms_received => 'Received';

  @override
  String get sms_sent => 'Forwarded';

  @override
  String get sms_start => 'Start';

  @override
  String get sms_stop => 'Stop';

  @override
  String get filters => 'FILTERS';

  @override
  String get filters_off => 'Off';

  @override
  String get filters_whitelist => 'Whitelist';

  @override
  String get filters_blacklist => 'Blacklist';

  @override
  String get filters_sender => 'Sender';

  @override
  String get filters_senderInfo => 'Add filters for numbers or names';

  @override
  String get filters_text => 'Message';

  @override
  String get filters_textInfo => 'Add filters for SMS text';

  @override
  String get filters_test => 'Test';

  @override
  String get filters_save => 'Save';

  @override
  String get settings => 'SETTINGS';

  @override
  String get settings_token => 'Bot token';

  @override
  String get settings_tokenInfo => 'Bot token you\'ve got from @BotFather';

  @override
  String get settings_chatId => 'Chat ID';

  @override
  String get settings_chatIdInfo => 'ID of a chat with your bot (optional)';

  @override
  String get settings_deviceLabel => 'Device label';

  @override
  String get settings_deviceLabelInfo => 'Custom label (optional)';

  @override
  String get settings_test => 'Test & Save';

  @override
  String get help_about => 'About';

  @override
  String get help_appInfo =>
      'App to automatically forward incoming SMS messages to a Telegram bot';

  @override
  String get help_howToUse => 'How to use';

  @override
  String get help_howToUse_01 =>
      'If you don\'t have a Telegram bot yet, use @BotFather bot to create one and get its token. It\'s simple and free.';

  @override
  String get help_howToUse_02 =>
      'Open a chat with your bot in Telegram, start a conversation, or send any message. This is needed to automatically retrieve the chat id for the next step.';

  @override
  String get help_howToUse_03 =>
      'Go to the app, in bot settings, enter the token, and test settings (you can also set the chat id if you know it). If the test is successful, the settings are saved, and a hello message is sent to the Telegram chat.';

  @override
  String get help_howToUse_04 =>
      'That\'s it! The app is now ready to forward incoming SMS to your bot. Tap Start to enable SMS forwarding, or tap Stop to turn it off.';

  @override
  String get help_howToUse_04l =>
      'When forwarding SMS from multiple devices, you can set a device label in settings to identify the receiving phone.';

  @override
  String get help_howToUse_05 =>
      'Some phones may limit background activity to save power. If you notice long delivery delays, disable battery optimization for the app.';

  @override
  String get help_howToUse_06 =>
      'Make sure to keep the internet connection enabled for the app to work.';

  @override
  String get help_filters => 'Filters';

  @override
  String get help_filters_01 =>
      'You can set filters for sender or text of incoming SMS messages. A filter is triggered if a sender number/name or text contains the specified characters.';

  @override
  String get help_filters_02 =>
      'There are two modes: whitelist (SMS is forwarded if at least one filter matches) and blacklist (SMS is not forwarded if any filter matches). In whitelist mode, if no filters are set, no SMS messages will be forwarded to the bot.';

  @override
  String get help_filters_03 =>
      'Use two forward slashes for regex. For example, filter /^\\d*555\$/ matches all numbers, that end with 555';

  @override
  String get help_filters_04 =>
      'To check whether a specific SMS message will be forwarded based on the current filters, enter the required sender and/or message in the input fields and click the button to verify.';
}
