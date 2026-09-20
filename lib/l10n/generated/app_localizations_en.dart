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
  String get action_close => 'Close';

  @override
  String get action_continue => 'Continue';

  @override
  String get action_delete => 'Delete';

  @override
  String get action_duplicate => 'Duplicate';

  @override
  String get action_exit => 'Exit';

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
  String get msg_hello => 'Hello! ^._.^';

  @override
  String get msg_received => 'Received';

  @override
  String get msg_sent => 'Forwarded';

  @override
  String get msg_start => 'Start';

  @override
  String get msg_stop => 'Stop';

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
  String get rules_setup => 'Rule setup';

  @override
  String get config => 'Config';

  @override
  String get connection => 'Connection';

  @override
  String get tbot_token => 'Bot token';

  @override
  String get tbot_chatId => 'Chat ID';

  @override
  String get tbot_chatIdInfo => 'Default: auto-detect';

  @override
  String get tbot_server => 'Server URL';

  @override
  String tbot_serverInfo(Object url) {
    return 'Default: $url';
  }

  @override
  String get ntfy_topic => 'Topic';

  @override
  String get ntfy_priority => 'Priority';

  @override
  String get ntfy_priority_01 => 'Min';

  @override
  String get ntfy_priority_02 => 'Low';

  @override
  String get ntfy_priority_03 => 'Default';

  @override
  String get ntfy_priority_04 => 'High';

  @override
  String get ntfy_priority_05 => 'Max';

  @override
  String get ntfy_token => 'Access token';

  @override
  String get ntfy_tokenInfo => 'Bearer token; default: no token';

  @override
  String get ntfy_server => 'Server URL';

  @override
  String ntfy_serverInfo(Object url) {
    return 'Default: $url';
  }

  @override
  String get smtp_host => 'SMTP host';

  @override
  String get smtp_protocol => 'Protocol';

  @override
  String get smtp_protocolEmpty => 'None';

  @override
  String get smtp_port => 'Port';

  @override
  String get smtp_insecureTls => 'Relaxed certificate validation';

  @override
  String get smtp_insecureTlsInfo =>
      'Enable only if you have connection errors (especially on older devices). This reduces connection security.';

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
  String get smtp_fromEmailInfo => 'Default: login';

  @override
  String get smtp_toEmail => 'To email';

  @override
  String get smtp_toEmailInfo => 'Default: login';

  @override
  String get smtp_subject => 'Subject';

  @override
  String get smtp_subjectInfo => 'Default: auto';

  @override
  String get sms_receiver => 'Receiver';

  @override
  String get sms_number => 'Phone number';

  @override
  String get sms_numberInfo => 'Example: +12345678900';

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
  String get options => 'Options';

  @override
  String get options_priority => 'Rule priority';

  @override
  String get options_priorityInfo =>
      'Rule is ignored if a higher-priority rule triggers';

  @override
  String get options_priority_01 => 'Highest';

  @override
  String get options_priority_02 => 'High';

  @override
  String get options_priority_03 => 'Medium';

  @override
  String get options_priority_04 => 'Low';

  @override
  String get options_priority_05 => 'Lowest';

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
  String get settings_attachSimInfo => 'Attach SIM info';

  @override
  String get settings_format => 'Message format';

  @override
  String get settings_formatDefault => 'Default';

  @override
  String get settings_formatPaste => 'Paste';

  @override
  String get settings_formatPreview => 'Preview';

  @override
  String get settings_formatReset => 'Reset';

  @override
  String get settings_formatError => 'Invalid template format.';

  @override
  String get settings_deviceLabel => 'Device label';

  @override
  String get settings_deviceLabelInfo => 'Default: no label';

  @override
  String get help_about => 'About';

  @override
  String get help_appInfo =>
      'Smart forwarding of SMS, notifications for incoming calls and battery status.';

  @override
  String get help_info => 'Intro';

  @override
  String get help_info_01 =>
      'Forward messages to Telegram, ntfy, email, or via SMS. Configure multiple destinations easily!';

  @override
  String get help_info_02 =>
      'Define what to forward and where using rules. Duplicate or toggle them on/off when needed.';

  @override
  String get help_info_03 =>
      'Messages are forwarded according to active rules. The app automatically retries if a connection fails (e.g., no internet).';

  @override
  String get help_opts_01 =>
      'First, select the events you want to track. The app generates and forwards messages for each event based on your rules.';

  @override
  String get help_opts_02 =>
      'Permanent background mode improves delivery reliability (especially for system notifications) but uses more battery. A persistent notification will appear in the notification shade. Enable only when necessary.';

  @override
  String get help_opts_03 =>
      'Enable the switch to add SIM card data (slot and operator) when forwarding incoming SMS and calls. SIM data is not available on some systems (especially for calls).';

  @override
  String get help_opts_04 =>
      'If you want to change the message format, download the template file, make your changes, and paste the template text in the settings.';

  @override
  String get help_opts_04h => 'Download template';

  @override
  String get help_opts_05 =>
      'Assign a device label when forwarding from multiple phones. The label is attached to each message for easy identification.';

  @override
  String get help_opts_06 =>
      'Disable battery optimization for this app to prevent the system from restricting background activity.';

  @override
  String get help_rule_01 =>
      'Test and save the settings (a welcome message will be sent upon successful test). Then enable the rule in the list and tap Start to begin forwarding!';

  @override
  String get help_tbot_01 =>
      'Don\'t have a bot? Use Telegram\'s @BotFather to create one and get an API token.';

  @override
  String get help_tbot_02 =>
      'Open a chat with your bot in the Telegram app and send any message. This will allow for automatic detection of your Chat ID.';

  @override
  String get help_tbot_03 =>
      'Add a Telegram rule and paste your token. Optionally, you can set the Chat ID manually.';

  @override
  String get help_tbot_04 =>
      'You can also specify a custom API server URL to use it instead of the official Telegram server.';

  @override
  String help_ntfy_01(Object url) {
    return 'In the ntfy app or web version ($url), subscribe to a new topic using a name that\'s hard to guess.';
  }

  @override
  String get help_ntfy_02 =>
      'Create a rule, enter the topic name, and optionally set a notification priority.';

  @override
  String get help_ntfy_03 =>
      'Public topics are accessible to anyone who knows their name. For better security, use authentication and access token.';

  @override
  String get help_ntfy_04 =>
      'The official ntfy.sh server is used by default, but you can specify a custom server.';

  @override
  String get help_smtp_01 =>
      'It is recommended to create a dedicated email account (not an alias) for forwarding. This is especially relevant for Gmail and similar providers.';

  @override
  String get help_smtp_02 =>
      'Add a rule and enter your SMTP details. Most providers require an \'App Password\' (generate one in your account security settings).';

  @override
  String get help_sms_01 =>
      'The app can forward events as outgoing SMS to specific phone numbers.';

  @override
  String get help_sms_02 =>
      'Add a rule and specify the recipient\'s number. Use international format for mobile numbers (start with +).';

  @override
  String get help_sms_03 =>
      'Outgoing SMS uses the default SIM card set in your phone settings.';

  @override
  String get help_filters => 'Filters';

  @override
  String get help_filters_01 =>
      'For any rule, you can set filters for sender or message text. A filter is triggered if a sender number/name or text contains the specified keywords.';

  @override
  String get help_filters_02 =>
      'Choose between Whitelist (forward if at least one filter matches) or Blacklist (block if any filter matches). Note: Whitelist with no filters blocks all messages.';

  @override
  String get help_filters_03 =>
      'Wrap patterns in // for regex syntax. Example: /^\\d*555\$/ matches all numbers ending in 555.';

  @override
  String get help_filters_04 =>
      'Check your filters by entering a sample sender or message text and tapping the test button to see if it matches.';

  @override
  String get help_filters_05 =>
      'The specified filters apply to all event types, not just incoming SMS.';

  @override
  String get help_options_01 =>
      'Rule priority determines the processing order. If a rule triggers (message sent), lower-priority rules are skipped. Rules with equal priority trigger simultaneously.';

  @override
  String get consent_welcome =>
      'Welcome!\nBy continuing, you confirm that you have read this information:';

  @override
  String get consent_item_01 =>
      'Depending on the features you enable, the app may receive data about incoming SMS and calls and send SMS to the numbers you specify.';

  @override
  String get consent_item_02 =>
      'Data is sent only to the services you configure yourself. No hidden servers or analytics.';

  @override
  String get consent_item_03 =>
      'Sensitive permissions are requested only when you enable the corresponding features.';

  @override
  String get consent_details => 'Learn more: ';

  @override
  String get consent_privacyPolicy => 'privacy policy';

  @override
  String get error_badRequest =>
      'The server rejected the request. Check the connection parameters.';

  @override
  String get error_forbidden =>
      'Authorization error. Check access permissions.';

  @override
  String get error_invalidParams => 'Invalid connection parameters.';

  @override
  String get error_networkError =>
      'Connection error. Check your internet connection or network settings.';

  @override
  String get error_networkTimeout =>
      'Request timed out. Check the network or connection parameters.';

  @override
  String get error_rateLimited => 'Request limit exceeded. Try again later.';

  @override
  String get error_serverError => 'Server error. Try again later.';

  @override
  String get error_smtpAddressRejected =>
      'The server rejected the sender or recipient email. Check the addresses.';

  @override
  String get error_smtpError =>
      'The server returned an error. Check the connection parameters.';

  @override
  String get error_smtp_unauthorized =>
      'Access error. Check your login and password.';

  @override
  String get error_tbot_conflict =>
      'Unable to get chat ID. Remove the active webhook or enter the ID manually.';

  @override
  String get error_tbot_forbidden =>
      'Authorization error. Make sure the bot has access to the chat.';

  @override
  String get error_tbot_unauthorized => 'Access error. Check the token.';

  @override
  String get error_tbot_uninitialized =>
      'Unable to get chat ID. Start a conversation with your bot in Telegram and try again.';

  @override
  String get error_unauthorized => 'Access error. Check your credentials.';

  @override
  String get error_unexpectedError => 'Couldn\'t complete the action.';

  @override
  String get error_secretsError =>
      'Unable to access secure storage. Try again. If the error persists, restart the app and check passwords/tokens in the forwarding rules.';

  @override
  String get warn_secretsRecovered =>
      'Secure storage was recovered after a crash, saved passwords/tokens may have been deleted. Check the forwarding rules and enter the data again.';

  @override
  String get warn_permissionsRequired =>
      'To start monitoring, grant the required permissions.';
}
