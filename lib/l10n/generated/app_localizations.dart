import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @action_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get action_cancel;

  /// No description provided for @action_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get action_continue;

  /// No description provided for @action_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get action_delete;

  /// No description provided for @action_duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get action_duplicate;

  /// No description provided for @action_exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get action_exit;

  /// No description provided for @action_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get action_save;

  /// No description provided for @action_test.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get action_test;

  /// No description provided for @service_title.
  ///
  /// In en, this message translates to:
  /// **'SMS Telebot is active'**
  String get service_title;

  /// No description provided for @service_text.
  ///
  /// In en, this message translates to:
  /// **'Monitoring events'**
  String get service_text;

  /// No description provided for @msg_list.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get msg_list;

  /// No description provided for @msg_welcome.
  ///
  /// In en, this message translates to:
  /// **'Tap Start\nto enable monitoring'**
  String get msg_welcome;

  /// No description provided for @msg_empty.
  ///
  /// In en, this message translates to:
  /// **'No messages\nin the last 24 hours'**
  String get msg_empty;

  /// No description provided for @msg_hello.
  ///
  /// In en, this message translates to:
  /// **'Hello! ^._.^'**
  String get msg_hello;

  /// No description provided for @msg_received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get msg_received;

  /// No description provided for @msg_sent.
  ///
  /// In en, this message translates to:
  /// **'Forwarded'**
  String get msg_sent;

  /// No description provided for @msg_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get msg_start;

  /// No description provided for @msg_stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get msg_stop;

  /// No description provided for @msg_sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get msg_sms;

  /// No description provided for @msg_call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get msg_call;

  /// No description provided for @msg_lowBattery.
  ///
  /// In en, this message translates to:
  /// **'Low battery'**
  String get msg_lowBattery;

  /// No description provided for @msg_chargerConnected.
  ///
  /// In en, this message translates to:
  /// **'Charger connected'**
  String get msg_chargerConnected;

  /// No description provided for @msg_chargerDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Charger disconnected'**
  String get msg_chargerDisconnected;

  /// No description provided for @rule.
  ///
  /// In en, this message translates to:
  /// **'Rule'**
  String get rule;

  /// No description provided for @rule_add.
  ///
  /// In en, this message translates to:
  /// **'Add rule'**
  String get rule_add;

  /// No description provided for @rule_copySuffix.
  ///
  /// In en, this message translates to:
  /// **'copy'**
  String get rule_copySuffix;

  /// No description provided for @rule_deleteHeader.
  ///
  /// In en, this message translates to:
  /// **'Delete rule?'**
  String get rule_deleteHeader;

  /// No description provided for @rule_deleteText.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get rule_deleteText;

  /// No description provided for @rule_noParams.
  ///
  /// In en, this message translates to:
  /// **'Please configure this rule before enabling it.'**
  String get rule_noParams;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rules;

  /// No description provided for @rules_empty.
  ///
  /// In en, this message translates to:
  /// **'No rules yet.\nAdd your first one!'**
  String get rules_empty;

  /// No description provided for @config.
  ///
  /// In en, this message translates to:
  /// **'Config'**
  String get config;

  /// No description provided for @connection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// No description provided for @tbot.
  ///
  /// In en, this message translates to:
  /// **'Telegram bot'**
  String get tbot;

  /// No description provided for @tbot_token.
  ///
  /// In en, this message translates to:
  /// **'Bot token'**
  String get tbot_token;

  /// No description provided for @tbot_chatId.
  ///
  /// In en, this message translates to:
  /// **'Chat ID'**
  String get tbot_chatId;

  /// No description provided for @tbot_chatIdInfo.
  ///
  /// In en, this message translates to:
  /// **'Default: auto-detect'**
  String get tbot_chatIdInfo;

  /// No description provided for @tbot_apiUrl.
  ///
  /// In en, this message translates to:
  /// **'API URL'**
  String get tbot_apiUrl;

  /// No description provided for @tbot_apiUrlInfo.
  ///
  /// In en, this message translates to:
  /// **'Default: standard Telegram URL'**
  String get tbot_apiUrlInfo;

  /// No description provided for @smtp.
  ///
  /// In en, this message translates to:
  /// **'SMTP server'**
  String get smtp;

  /// No description provided for @smtp_host.
  ///
  /// In en, this message translates to:
  /// **'SMTP host'**
  String get smtp_host;

  /// No description provided for @smtp_protocol.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get smtp_protocol;

  /// No description provided for @smtp_protocolEmpty.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get smtp_protocolEmpty;

  /// No description provided for @smtp_port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get smtp_port;

  /// No description provided for @smtp_insecureTls.
  ///
  /// In en, this message translates to:
  /// **'Relaxed certificate validation'**
  String get smtp_insecureTls;

  /// No description provided for @smtp_insecureTlsInfo.
  ///
  /// In en, this message translates to:
  /// **'Enable only if you have connection errors (especially on older devices). This reduces connection security.'**
  String get smtp_insecureTlsInfo;

  /// No description provided for @smtp_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get smtp_login;

  /// No description provided for @smtp_loginInfo.
  ///
  /// In en, this message translates to:
  /// **'Usually full email address'**
  String get smtp_loginInfo;

  /// No description provided for @smtp_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get smtp_password;

  /// No description provided for @smtp_passwordInfo.
  ///
  /// In en, this message translates to:
  /// **'Usually password for external apps'**
  String get smtp_passwordInfo;

  /// No description provided for @smtp_fromEmail.
  ///
  /// In en, this message translates to:
  /// **'From email'**
  String get smtp_fromEmail;

  /// No description provided for @smtp_fromEmailInfo.
  ///
  /// In en, this message translates to:
  /// **'Default: login'**
  String get smtp_fromEmailInfo;

  /// No description provided for @smtp_toEmail.
  ///
  /// In en, this message translates to:
  /// **'To email'**
  String get smtp_toEmail;

  /// No description provided for @smtp_toEmailInfo.
  ///
  /// In en, this message translates to:
  /// **'Default: login'**
  String get smtp_toEmailInfo;

  /// No description provided for @smtp_subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get smtp_subject;

  /// No description provided for @smtp_subjectInfo.
  ///
  /// In en, this message translates to:
  /// **'Default: auto'**
  String get smtp_subjectInfo;

  /// No description provided for @sms_receiver.
  ///
  /// In en, this message translates to:
  /// **'Receiver'**
  String get sms_receiver;

  /// No description provided for @sms_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get sms_number;

  /// No description provided for @sms_numberInfo.
  ///
  /// In en, this message translates to:
  /// **'Example: +12345678900'**
  String get sms_numberInfo;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @filters_off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get filters_off;

  /// No description provided for @filters_whitelist.
  ///
  /// In en, this message translates to:
  /// **'Whitelist'**
  String get filters_whitelist;

  /// No description provided for @filters_blacklist.
  ///
  /// In en, this message translates to:
  /// **'Blacklist'**
  String get filters_blacklist;

  /// No description provided for @filters_sender.
  ///
  /// In en, this message translates to:
  /// **'Sender'**
  String get filters_sender;

  /// No description provided for @filters_senderInfo.
  ///
  /// In en, this message translates to:
  /// **'Add filters for numbers or names'**
  String get filters_senderInfo;

  /// No description provided for @filters_text.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get filters_text;

  /// No description provided for @filters_textInfo.
  ///
  /// In en, this message translates to:
  /// **'Add text filters'**
  String get filters_textInfo;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @options_priority.
  ///
  /// In en, this message translates to:
  /// **'Rule priority'**
  String get options_priority;

  /// No description provided for @options_priorityInfo.
  ///
  /// In en, this message translates to:
  /// **'Rule is ignored if a higher-priority rule triggers'**
  String get options_priorityInfo;

  /// No description provided for @options_priority_01.
  ///
  /// In en, this message translates to:
  /// **'Highest'**
  String get options_priority_01;

  /// No description provided for @options_priority_02.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get options_priority_02;

  /// No description provided for @options_priority_03.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get options_priority_03;

  /// No description provided for @options_priority_04.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get options_priority_04;

  /// No description provided for @options_priority_05.
  ///
  /// In en, this message translates to:
  /// **'Lowest'**
  String get options_priority_05;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settings_forwardEvents.
  ///
  /// In en, this message translates to:
  /// **'Events to forward'**
  String get settings_forwardEvents;

  /// No description provided for @settings_forwardSms.
  ///
  /// In en, this message translates to:
  /// **'Incoming SMS'**
  String get settings_forwardSms;

  /// No description provided for @settings_forwardCalls.
  ///
  /// In en, this message translates to:
  /// **'Incoming calls'**
  String get settings_forwardCalls;

  /// No description provided for @settings_notifyLowBattery.
  ///
  /// In en, this message translates to:
  /// **'Low battery'**
  String get settings_notifyLowBattery;

  /// No description provided for @settings_notifyChargerState.
  ///
  /// In en, this message translates to:
  /// **'Charger connection'**
  String get settings_notifyChargerState;

  /// No description provided for @settings_enableForeground.
  ///
  /// In en, this message translates to:
  /// **'Always run in background'**
  String get settings_enableForeground;

  /// No description provided for @settings_attachSimInfo.
  ///
  /// In en, this message translates to:
  /// **'Attach SIM info'**
  String get settings_attachSimInfo;

  /// No description provided for @settings_deviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Device label'**
  String get settings_deviceLabel;

  /// No description provided for @settings_deviceLabelInfo.
  ///
  /// In en, this message translates to:
  /// **'Default: no label'**
  String get settings_deviceLabelInfo;

  /// No description provided for @help_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get help_about;

  /// No description provided for @help_appInfo.
  ///
  /// In en, this message translates to:
  /// **'Smart forwarding of SMS, notifications for incoming calls and battery status.'**
  String get help_appInfo;

  /// No description provided for @help_info.
  ///
  /// In en, this message translates to:
  /// **'Intro'**
  String get help_info;

  /// No description provided for @help_info_01.
  ///
  /// In en, this message translates to:
  /// **'Forward messages to Telegram bots, email (SMTP), or via SMS. Configure multiple destinations easily!'**
  String get help_info_01;

  /// No description provided for @help_info_02.
  ///
  /// In en, this message translates to:
  /// **'Define what to forward and where using rules. Duplicate or toggle them on/off when needed.'**
  String get help_info_02;

  /// No description provided for @help_info_03.
  ///
  /// In en, this message translates to:
  /// **'Messages are forwarded according to active rules. The app automatically retries if a connection fails (e.g., no internet).'**
  String get help_info_03;

  /// No description provided for @help_opts_01.
  ///
  /// In en, this message translates to:
  /// **'First, select the events you want to track. The app generates and forwards messages for each event based on your rules.'**
  String get help_opts_01;

  /// No description provided for @help_opts_02.
  ///
  /// In en, this message translates to:
  /// **'Permanent background mode improves delivery reliability (especially for system notifications) but uses more battery. A persistent notification will appear in the notification shade. Enable only when necessary.'**
  String get help_opts_02;

  /// No description provided for @help_opts_025.
  ///
  /// In en, this message translates to:
  /// **'Enable the switch to add SIM card data (slot and operator) when forwarding incoming SMS and calls. SIM data is not available on some systems (especially for calls).'**
  String get help_opts_025;

  /// No description provided for @help_opts_03.
  ///
  /// In en, this message translates to:
  /// **'Assign a device label when forwarding from multiple phones. The label is attached to each message for easy identification.'**
  String get help_opts_03;

  /// No description provided for @help_opts_04.
  ///
  /// In en, this message translates to:
  /// **'Disable battery optimization for this app to prevent the system from restricting background activity.'**
  String get help_opts_04;

  /// No description provided for @help_tbot.
  ///
  /// In en, this message translates to:
  /// **'Setting Up a Telegram Bot'**
  String get help_tbot;

  /// No description provided for @help_tbot_01.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have a bot? Use Telegram\'s @BotFather to create one and get an API token. It\'s free and easy.'**
  String get help_tbot_01;

  /// No description provided for @help_tbot_02.
  ///
  /// In en, this message translates to:
  /// **'Open a chat with your bot in Telegram and send any message. This allows the app to automatically detect your Chat ID.'**
  String get help_tbot_02;

  /// No description provided for @help_tbot_03.
  ///
  /// In en, this message translates to:
  /// **'In the app, add a Telegram bot rule and paste your token (optional: manually set Chat ID). Test the connection, then save. You\'ll receive a hello message if it works.'**
  String get help_tbot_03;

  /// No description provided for @help_tbot_04.
  ///
  /// In en, this message translates to:
  /// **'Done! Enable the rule and tap Start to begin forwarding messages.'**
  String get help_tbot_04;

  /// No description provided for @help_tbot_05.
  ///
  /// In en, this message translates to:
  /// **'Optionally, specify a custom API server URL to use it instead of the official Telegram server.'**
  String get help_tbot_05;

  /// No description provided for @help_smtp.
  ///
  /// In en, this message translates to:
  /// **'Setting Up a SMTP Server'**
  String get help_smtp;

  /// No description provided for @help_smtp_01.
  ///
  /// In en, this message translates to:
  /// **'It is recommended to create a dedicated email account (not an alias) for forwarding. This is especially relevant for Gmail and similar providers.'**
  String get help_smtp_01;

  /// No description provided for @help_smtp_02.
  ///
  /// In en, this message translates to:
  /// **'Add a rule and enter your SMTP details. Most providers require an \'App Password\' (generate one in your account security settings).'**
  String get help_smtp_02;

  /// No description provided for @help_smtp_03.
  ///
  /// In en, this message translates to:
  /// **'Test and save your settings, enable the rule, then tap Start.'**
  String get help_smtp_03;

  /// No description provided for @help_sms.
  ///
  /// In en, this message translates to:
  /// **'Sending SMS'**
  String get help_sms;

  /// No description provided for @help_sms_01.
  ///
  /// In en, this message translates to:
  /// **'The app can forward events as outgoing SMS to specific phone numbers.'**
  String get help_sms_01;

  /// No description provided for @help_sms_02.
  ///
  /// In en, this message translates to:
  /// **'Add a rule and specify the recipient\'s number. Use international format for mobile numbers (start with +).'**
  String get help_sms_02;

  /// No description provided for @help_sms_03.
  ///
  /// In en, this message translates to:
  /// **'Outgoing SMS uses the default SIM card set in your phone settings.'**
  String get help_sms_03;

  /// No description provided for @help_filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get help_filters;

  /// No description provided for @help_filters_01.
  ///
  /// In en, this message translates to:
  /// **'For any rule, you can set filters for sender or message text. A filter is triggered if a sender number/name or text contains the specified keywords.'**
  String get help_filters_01;

  /// No description provided for @help_filters_02.
  ///
  /// In en, this message translates to:
  /// **'Choose between Whitelist (forward if at least one filter matches) or Blacklist (block if any filter matches). Note: Whitelist with no filters blocks all messages.'**
  String get help_filters_02;

  /// No description provided for @help_filters_03.
  ///
  /// In en, this message translates to:
  /// **'Wrap patterns in // for regex syntax. Example: /^\\d*555\$/ matches all numbers ending in 555.'**
  String get help_filters_03;

  /// No description provided for @help_filters_04.
  ///
  /// In en, this message translates to:
  /// **'Check your filters by entering a sample sender or message text and tapping the test button to see if it matches.'**
  String get help_filters_04;

  /// No description provided for @help_filters_05.
  ///
  /// In en, this message translates to:
  /// **'The specified filters apply to all event types, not just incoming SMS.'**
  String get help_filters_05;

  /// No description provided for @consent_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!\nBy continuing, you confirm that you have read this information:'**
  String get consent_welcome;

  /// No description provided for @consent_item_01.
  ///
  /// In en, this message translates to:
  /// **'Depending on the features you enable, the app may receive data about incoming SMS and calls and send SMS to the numbers you specify.'**
  String get consent_item_01;

  /// No description provided for @consent_item_02.
  ///
  /// In en, this message translates to:
  /// **'Data is sent only to the services you configure yourself. No hidden servers or analytics.'**
  String get consent_item_02;

  /// No description provided for @consent_item_03.
  ///
  /// In en, this message translates to:
  /// **'Sensitive permissions are requested only when you enable the corresponding features.'**
  String get consent_item_03;

  /// No description provided for @consent_item_04.
  ///
  /// In en, this message translates to:
  /// **'Because of the permissions used, Google Play Protect and antivirus software may show false warnings.'**
  String get consent_item_04;

  /// No description provided for @consent_details.
  ///
  /// In en, this message translates to:
  /// **'Learn more: '**
  String get consent_details;

  /// No description provided for @consent_privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'privacy policy'**
  String get consent_privacyPolicy;

  /// No description provided for @error_badRequest.
  ///
  /// In en, this message translates to:
  /// **'Request was rejected. Check the entered connection parameters.'**
  String get error_badRequest;

  /// No description provided for @error_invalidParams.
  ///
  /// In en, this message translates to:
  /// **'Invalid connection parameters. Correct them and try again.'**
  String get error_invalidParams;

  /// No description provided for @error_networkError.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get error_networkError;

  /// No description provided for @error_networkTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Check your internet and make sure connection parameters are correct.'**
  String get error_networkTimeout;

  /// No description provided for @error_rateLimited.
  ///
  /// In en, this message translates to:
  /// **'You are sending requests too fast. Please wait a moment and try again.'**
  String get error_rateLimited;

  /// No description provided for @error_serverError.
  ///
  /// In en, this message translates to:
  /// **'The server is currently unavailable. Please try again later.'**
  String get error_serverError;

  /// No description provided for @error_smtpAddressRejected.
  ///
  /// In en, this message translates to:
  /// **'The server rejected the sender or recipient email. Check the addresses.'**
  String get error_smtpAddressRejected;

  /// No description provided for @error_smtpError.
  ///
  /// In en, this message translates to:
  /// **'The server returned an error. Check the entered connection parameters.'**
  String get error_smtpError;

  /// No description provided for @error_smtp_forbidden.
  ///
  /// In en, this message translates to:
  /// **'Action was rejected by the server. Check access permissions.'**
  String get error_smtp_forbidden;

  /// No description provided for @error_smtp_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Authorization error. Check your login and password.'**
  String get error_smtp_unauthorized;

  /// No description provided for @error_tbot_conflict.
  ///
  /// In en, this message translates to:
  /// **'Unable to get chat ID. Remove the active webhook or enter the ID manually.'**
  String get error_tbot_conflict;

  /// No description provided for @error_tbot_forbidden.
  ///
  /// In en, this message translates to:
  /// **'Telegram denied this action. Make sure the bot has access to the chat.'**
  String get error_tbot_forbidden;

  /// No description provided for @error_tbot_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Authorization error. Enter a valid token and try again.'**
  String get error_tbot_unauthorized;

  /// No description provided for @error_tbot_uninitialized.
  ///
  /// In en, this message translates to:
  /// **'Unable to get chat ID. Start a conversation with your bot in Telegram and try again.'**
  String get error_tbot_uninitialized;

  /// No description provided for @error_unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again later.'**
  String get error_unexpectedError;

  /// No description provided for @error_secretsError.
  ///
  /// In en, this message translates to:
  /// **'Unable to access secure storage. Try again. If the error persists, restart the app and check passwords/tokens in the forwarding rules.'**
  String get error_secretsError;

  /// No description provided for @warn_secretsRecovered.
  ///
  /// In en, this message translates to:
  /// **'Secure storage was recovered after a crash, saved passwords/tokens may have been deleted. Check the forwarding rules and enter the data again.'**
  String get warn_secretsRecovered;

  /// No description provided for @warn_permissionsRequired.
  ///
  /// In en, this message translates to:
  /// **'To start monitoring, please grant the required permissions.'**
  String get warn_permissionsRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
