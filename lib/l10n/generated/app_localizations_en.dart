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
  String get msg_list => 'Messages';

  @override
  String get msg_welcome => 'Tap Start\nto enable monitoring';

  @override
  String get msg_empty => 'No messages\nin the last 24 hours';

  @override
  String get msg_hello => 'Hello! =^•⩊•^=';

  @override
  String get msg_received => 'Received';

  @override
  String get msg_sent => 'Forwarded';

  @override
  String get msg_start => 'Start';

  @override
  String get msg_stop => 'Stop';

  @override
  String get msg_sms => 'SMS';

  @override
  String get msg_call => 'Call';

  @override
  String get msg_lowBattery => 'Low battery';

  @override
  String get msg_chargerConnected => 'Charger connected';

  @override
  String get msg_chargerDisconnected => 'Charger disconnected';

  @override
  String get rule => 'Rule';

  @override
  String get rule_add => 'Add rule';

  @override
  String get rule_copySuffix => 'copy';

  @override
  String get rule_deleteHeader => 'Delete rule?';

  @override
  String get rule_deleteText => 'This action cannot be undone.';

  @override
  String get rule_noParams => 'Please configure this rule before enabling it.';

  @override
  String get rules => 'Rules';

  @override
  String get rules_empty => 'No rules yet.\nAdd your first one!';

  @override
  String get connection => 'Connection';

  @override
  String get tbot => 'Telegram bot';

  @override
  String get tbot_token => 'Bot token';

  @override
  String get tbot_tokenInfo => 'Bot token you\'ve got from @BotFather';

  @override
  String get tbot_chatId => 'Chat ID';

  @override
  String get tbot_chatIdInfo => 'ID of a chat with your bot (optional)';

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
  String get filters_textInfo => 'Add text filters';

  @override
  String get settings => 'Settings';

  @override
  String get settings_forwardEvents => 'Events to forward';

  @override
  String get settings_forwardSms => 'Incoming SMS';

  @override
  String get settings_forwardCalls => 'Incoming calls';

  @override
  String get settings_notifyLowBattery => 'Low battery';

  @override
  String get settings_notifyChargerState => 'Charger connection';

  @override
  String get settings_enableForeground => 'Always run in background';

  @override
  String get settings_deviceLabel => 'Device label';

  @override
  String get settings_deviceLabelInfo => 'Custom label (optional)';

  @override
  String get help_about => 'About';

  @override
  String get help_appInfo =>
      'App to automatically forward incoming SMS.\nAdditional features: notifications for incoming calls and battery status.';

  @override
  String get help_info => 'Intro';

  @override
  String get help_info_01 =>
      'With this app, you can forward messages to a Telegram bot or an email address with SMTP access. You can add multiple bots or email addresses!';

  @override
  String get help_info_02 =>
      'A forwarding rule is created for each connection — it defines which messages to send and where. Rules can be duplicated, enabled, or disabled as needed.';

  @override
  String get help_info_03 =>
      'The app checks active rules and attempts to forward a new message. If it fails due to technical reasons (e.g., no internet), the app will retry later.';

  @override
  String get help_info_04 =>
      'Make sure to keep the internet connection enabled for the app to work.';

  @override
  String get help_opts_01 =>
      'First, select the events you want to forward. As the app runs, a message is generated and sent for each event according to the specified rules.';

  @override
  String get help_opts_02 =>
      'Permanent background mode improves reliability of message delivery (especially for system notifications), but significantly increases battery consumption. In this mode, a persistent notification appears in the notification shade. Not recommended to enable unless necessary.';

  @override
  String get help_opts_03 =>
      'When forwarding messages from multiple phones, you can set a device label — it is sent along with the message to identify the receiving phone.';

  @override
  String get help_opts_04 =>
      'It is recommended to disable battery optimization for the app, since the system may restrict background activity to save power.';

  @override
  String get help_tbot => 'Connecting a Telegram Bot';

  @override
  String get help_tbot_01 =>
      'If you don\'t have a Telegram bot yet, use @BotFather bot to create one and get its token. It\'s simple and free.';

  @override
  String get help_tbot_02 =>
      'Open a chat with your bot in Telegram, start a conversation, or send any message. This is needed to automatically retrieve the chat id for the next step.';

  @override
  String get help_tbot_03 =>
      'In the app, create a Telegram bot rule and enter the token (you can also set a Chat ID if you know it). Test the settings, then save. A welcome message will arrive upon a successful test.';

  @override
  String get help_tbot_04 =>
      'Done! Everything is set up to forward messages to your bot. Enable the rule and press Start to begin.';

  @override
  String get help_smtp => 'Connecting an SMTP Server';

  @override
  String get help_smtp_01 =>
      'It is best to create a dedicated email for message forwarding (not an alias): it will also serve as your login. This is especially relevant for Gmail and similar services.';

  @override
  String get help_smtp_02 =>
      'Create a rule and fill in the connection details. Usually, an \'App Password\' is required (generated in your email provider\'s security settings).';

  @override
  String get help_smtp_03 =>
      'Test and save the settings, enable the rule, and press Start.';

  @override
  String get help_filters => 'Filters';

  @override
  String get help_filters_01 =>
      'You can set filters for sender or message text. A filter is triggered if a sender number/name or text contains the specified characters.';

  @override
  String get help_filters_02 =>
      'There are two modes: whitelist (message is forwarded if at least one filter matches) and blacklist (message is not forwarded if any filter matches). In whitelist mode, if no filters are set, no messages will be forwarded.';

  @override
  String get help_filters_03 =>
      'Use two forward slashes for regex. For example, filter /^\\d*555\$/ matches all numbers, that end with 555';

  @override
  String get help_filters_04 =>
      'To check whether a specific message will be forwarded based on the current filters, enter the required sender and/or message text in the input fields and click the button to verify.';

  @override
  String get help_filters_05 =>
      'The specified filters are applied to all event types, not just incoming SMS.';

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

  @override
  String get error_secretsError =>
      'Unable to access secure storage. Try again. If the error persists, restart the app and check passwords/tokens in the forwarding rules.';

  @override
  String get warn_secretsRecovered =>
      'Secure storage was recovered after a crash, saved passwords/tokens may have been deleted. Check the forwarding rules and enter the data again.';

  @override
  String get warn_permissionsRequired =>
      'To start monitoring, please grant the required permissions.';
}
