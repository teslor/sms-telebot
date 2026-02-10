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

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @sms_welcome.
  ///
  /// In en, this message translates to:
  /// **'Tap Start to begin\nforwarding SMS'**
  String get sms_welcome;

  /// No description provided for @sms_empty.
  ///
  /// In en, this message translates to:
  /// **'No incoming SMS\nin current session'**
  String get sms_empty;

  /// No description provided for @sms_hello.
  ///
  /// In en, this message translates to:
  /// **'Hello from SMS Telebot! =^•⩊•^='**
  String get sms_hello;

  /// No description provided for @sms_from.
  ///
  /// In en, this message translates to:
  /// **'SMS from'**
  String get sms_from;

  /// No description provided for @sms_received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get sms_received;

  /// No description provided for @sms_sent.
  ///
  /// In en, this message translates to:
  /// **'Forwarded'**
  String get sms_sent;

  /// No description provided for @sms_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get sms_start;

  /// No description provided for @sms_stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get sms_stop;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'FILTERS'**
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
  /// **'Add filters for SMS text'**
  String get filters_textInfo;

  /// No description provided for @filters_test.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get filters_test;

  /// No description provided for @filters_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get filters_save;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settings;

  /// No description provided for @settings_token.
  ///
  /// In en, this message translates to:
  /// **'Bot token'**
  String get settings_token;

  /// No description provided for @settings_tokenInfo.
  ///
  /// In en, this message translates to:
  /// **'Bot token you\'ve got from @BotFather'**
  String get settings_tokenInfo;

  /// No description provided for @settings_chatId.
  ///
  /// In en, this message translates to:
  /// **'Chat ID'**
  String get settings_chatId;

  /// No description provided for @settings_chatIdInfo.
  ///
  /// In en, this message translates to:
  /// **'ID of a chat with your bot (optional)'**
  String get settings_chatIdInfo;

  /// No description provided for @settings_deviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Device label'**
  String get settings_deviceLabel;

  /// No description provided for @settings_deviceLabelInfo.
  ///
  /// In en, this message translates to:
  /// **'Custom label (optional)'**
  String get settings_deviceLabelInfo;

  /// No description provided for @settings_test.
  ///
  /// In en, this message translates to:
  /// **'Test & Save'**
  String get settings_test;

  /// No description provided for @help_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get help_about;

  /// No description provided for @help_appInfo.
  ///
  /// In en, this message translates to:
  /// **'App to automatically forward incoming SMS messages to a Telegram bot'**
  String get help_appInfo;

  /// No description provided for @help_howToUse.
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get help_howToUse;

  /// No description provided for @help_howToUse_01.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t have a Telegram bot yet, use @BotFather bot to create one and get its token. It\'s simple and free.'**
  String get help_howToUse_01;

  /// No description provided for @help_howToUse_02.
  ///
  /// In en, this message translates to:
  /// **'Open a chat with your bot in Telegram, start a conversation, or send any message. This is needed to automatically retrieve the chat id for the next step.'**
  String get help_howToUse_02;

  /// No description provided for @help_howToUse_03.
  ///
  /// In en, this message translates to:
  /// **'Go to the app, in bot settings, enter the token, and test settings (you can also set the chat id if you know it). If the test is successful, the settings are saved, and a hello message is sent to the Telegram chat.'**
  String get help_howToUse_03;

  /// No description provided for @help_howToUse_04.
  ///
  /// In en, this message translates to:
  /// **'That\'s it! The app is now ready to forward incoming SMS to your bot. Tap Start to enable SMS forwarding, or tap Stop to turn it off.'**
  String get help_howToUse_04;

  /// No description provided for @help_howToUse_04l.
  ///
  /// In en, this message translates to:
  /// **'When forwarding SMS from multiple devices, you can set a device label in settings to identify the receiving phone.'**
  String get help_howToUse_04l;

  /// No description provided for @help_howToUse_05.
  ///
  /// In en, this message translates to:
  /// **'It is recommended to disable battery optimization for the app, since the system may restrict background activity to save power.'**
  String get help_howToUse_05;

  /// No description provided for @help_howToUse_06.
  ///
  /// In en, this message translates to:
  /// **'Make sure to keep the internet connection enabled for the app to work.'**
  String get help_howToUse_06;

  /// No description provided for @help_filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get help_filters;

  /// No description provided for @help_filters_01.
  ///
  /// In en, this message translates to:
  /// **'You can set filters for sender or text of incoming SMS messages. A filter is triggered if a sender number/name or text contains the specified characters.'**
  String get help_filters_01;

  /// No description provided for @help_filters_02.
  ///
  /// In en, this message translates to:
  /// **'There are two modes: whitelist (SMS is forwarded if at least one filter matches) and blacklist (SMS is not forwarded if any filter matches). In whitelist mode, if no filters are set, no SMS messages will be forwarded to the bot.'**
  String get help_filters_02;

  /// No description provided for @help_filters_03.
  ///
  /// In en, this message translates to:
  /// **'Use two forward slashes for regex. For example, filter /^\\d*555\$/ matches all numbers, that end with 555'**
  String get help_filters_03;

  /// No description provided for @help_filters_04.
  ///
  /// In en, this message translates to:
  /// **'To check whether a specific SMS message will be forwarded based on the current filters, enter the required sender and/or message in the input fields and click the button to verify.'**
  String get help_filters_04;
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
