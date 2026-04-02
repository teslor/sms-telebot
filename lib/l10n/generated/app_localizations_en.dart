// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get action_cancel => 'Cancel';

  @override
  String get action_delete => 'Delete';

  @override
  String get action_duplicate => 'Duplicate';

  @override
  String get action_save => 'Save';

  @override
  String get action_test => 'Test';

  @override
  String get action_testAndSave => 'Test and save';

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
  String get rule => 'Rule';

  @override
  String get rule_add => 'Add forwarding rule';

  @override
  String get rule_copySuffix => 'copy';

  @override
  String get rule_deleteHeader => 'Delete rule?';

  @override
  String get rule_deleteText => 'This action cannot be undone.';

  @override
  String get rules => 'RULES';

  @override
  String get rules_empty => 'No rules yet\nCreate your first one!';

  @override
  String get connection => 'Connection';

  @override
  String get telebot => 'Telegram bot';

  @override
  String get telebot_token => 'Bot token';

  @override
  String get telebot_tokenInfo => 'Bot token you\'ve got from @BotFather';

  @override
  String get telebot_chatId => 'Chat ID';

  @override
  String get telebot_chatIdInfo => 'ID of a chat with your bot (optional)';

  @override
  String get smtp => 'SMTP server';

  @override
  String get smtp_host => 'SMTP host';

  @override
  String get smtp_protocol => 'Protocol';

  @override
  String get smtp_protocolEmpty => 'None';

  @override
  String get smtp_port => 'Port';

  @override
  String get smtp_login => 'Login';

  @override
  String get smtp_loginInfo => 'Usually full email address';

  @override
  String get smtp_password => 'Password';

  @override
  String get smtp_passwordInfo => 'Usually password for external apps';

  @override
  String get smtp_fromEmail => 'From email';

  @override
  String get smtp_fromEmailInfo => 'Optional – login if empty';

  @override
  String get smtp_toEmail => 'To email';

  @override
  String get smtp_toEmailInfo => 'Recipient email address';

  @override
  String get smtp_subject => 'Subject';

  @override
  String get smtp_subjectInfo => 'Email subject (optional)';

  @override
  String get filters => 'Filters';

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
  String get settings => 'SETTINGS';

  @override
  String get settings_deviceLabel => 'Device label';

  @override
  String get settings_deviceLabelInfo => 'Custom label (optional)';

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
      'It is recommended to disable battery optimization for the app, since the system may restrict background activity to save power.';

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

  @override
  String get error_badRequest =>
      'Request was rejected. Check the entered connection parameters.';

  @override
  String get error_invalidParams =>
      'Invalid connection parameters. Correct them and try again.';

  @override
  String get error_networkError =>
      'Check your internet connection and try again.';

  @override
  String get error_networkTimeout =>
      'Request timed out. Check your internet and make sure connection parameters are correct.';

  @override
  String get error_rateLimited =>
      'You are sending requests too fast. Please wait a moment and try again.';

  @override
  String get error_serverError =>
      'The server is currently unavailable. Please try again later.';

  @override
  String get error_smtpAddressRejected =>
      'The server rejected the sender or recipient email. Check the addresses.';

  @override
  String get error_smtpError =>
      'The server returned an error. Check the entered connection parameters.';

  @override
  String get error_smtp_forbidden =>
      'Action was rejected by the server. Check access permissions.';

  @override
  String get error_smtp_unauthorized =>
      'Authorization error. Check your login and password.';

  @override
  String get error_tbot_conflict =>
      'Unable to get chat ID. Remove the active webhook or enter the ID manually.';

  @override
  String get error_tbot_forbidden =>
      'Telegram denied this action. Make sure the bot has access to the chat.';

  @override
  String get error_tbot_unauthorized =>
      'Authorization error. Enter a valid token and try again.';

  @override
  String get error_tbot_uninitialized =>
      'Unable to get chat ID. Start a conversation with your bot in Telegram and try again.';

  @override
  String get error_unexpectedError =>
      'An unexpected error occurred. Please try again later.';
}
