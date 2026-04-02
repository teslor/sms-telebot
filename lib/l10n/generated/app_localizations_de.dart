// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get action_cancel => 'Abbrechen';

  @override
  String get action_delete => 'Löschen';

  @override
  String get action_duplicate => 'Duplizieren';

  @override
  String get action_save => 'Speichern';

  @override
  String get action_test => 'Testen';

  @override
  String get action_testAndSave => 'Testen & Speichern';

  @override
  String get sms => 'SMS';

  @override
  String get sms_welcome =>
      'Tippen Sie auf Start, um\nSMS-Weiterleitung zu starten';

  @override
  String get sms_empty => 'Keine eingehenden SMS\nin aktueller Sitzung';

  @override
  String get sms_hello => 'Hallo von SMS Telebot! =^•⩊•^=';

  @override
  String get sms_from => 'SMS von';

  @override
  String get sms_received => 'Empfangen';

  @override
  String get sms_sent => 'Weitergeleitet';

  @override
  String get sms_start => 'Start';

  @override
  String get sms_stop => 'Stopp';

  @override
  String get rule => 'Regel';

  @override
  String get rule_add => 'Weiterleitungsregel hinzufügen';

  @override
  String get rule_copySuffix => 'Kopie';

  @override
  String get rule_deleteHeader => 'Regel löschen?';

  @override
  String get rule_deleteText =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get rules => 'REGELN';

  @override
  String get rules_empty => 'Noch keine Regeln\nErstellen Sie die erste!';

  @override
  String get connection => 'Verbindung';

  @override
  String get telebot => 'Telegram-Bot';

  @override
  String get telebot_token => 'Bot-Token';

  @override
  String get telebot_tokenInfo => 'Token vom @BotFather erhalten';

  @override
  String get telebot_chatId => 'Chat-ID';

  @override
  String get telebot_chatIdInfo => 'ID des Chats mit Ihrem Bot (optional)';

  @override
  String get smtp => 'SMTP-Server';

  @override
  String get smtp_host => 'SMTP-Host';

  @override
  String get smtp_protocol => 'Protokoll';

  @override
  String get smtp_protocolEmpty => 'Keins';

  @override
  String get smtp_port => 'Port';

  @override
  String get smtp_login => 'Anmeldung';

  @override
  String get smtp_loginInfo => 'Normalerweise die vollständige E-Mail-Adresse';

  @override
  String get smtp_password => 'Passwort';

  @override
  String get smtp_passwordInfo => 'Normalerweise Passwort für externe Apps';

  @override
  String get smtp_fromEmail => 'Absender-E-Mail';

  @override
  String get smtp_fromEmailInfo => 'Optional - Anmeldung, falls leer';

  @override
  String get smtp_toEmail => 'Empfänger-E-Mail';

  @override
  String get smtp_toEmailInfo => 'E-Mail-Adresse des Empfängers';

  @override
  String get smtp_subject => 'Betreff';

  @override
  String get smtp_subjectInfo => 'E-Mail-Betreff (optional)';

  @override
  String get filters => 'Filter';

  @override
  String get filters_off => 'Aus';

  @override
  String get filters_whitelist => 'Whitelist';

  @override
  String get filters_blacklist => 'Blacklist';

  @override
  String get filters_sender => 'Absender';

  @override
  String get filters_senderInfo => 'Filter für Nummern oder Namen hinzufügen';

  @override
  String get filters_text => 'Nachricht';

  @override
  String get filters_textInfo => 'Filter für SMS-Text hinzufügen';

  @override
  String get settings => 'EINSTELLUNGEN';

  @override
  String get settings_deviceLabel => 'Gerätename';

  @override
  String get settings_deviceLabelInfo =>
      'Benutzerdefinierte Bezeichnung (optional)';

  @override
  String get help_about => 'Über';

  @override
  String get help_appInfo =>
      'App zum automatischen Weiterleiten eingehender SMS an einen Telegram-Bot';

  @override
  String get help_howToUse => 'Anleitung';

  @override
  String get help_howToUse_01 =>
      'Falls Sie noch keinen Telegram-Bot haben, erstellen Sie einen mit @BotFather und erhalten Sie dessen Token. Es ist einfach und kostenlos.';

  @override
  String get help_howToUse_02 =>
      'Öffnen Sie einen Chat mit Ihrem Bot in Telegram, starten Sie ein Gespräch oder senden Sie eine Nachricht. Dies ist erforderlich, um die Chat-ID automatisch abzurufen.';

  @override
  String get help_howToUse_03 =>
      'Öffnen Sie die App, geben Sie in den Bot-Einstellungen das Token ein und testen Sie die Einstellungen (Sie können auch die Chat-ID angeben, falls bekannt). Bei erfolgreichem Test werden die Einstellungen gespeichert und eine Begrüßungsnachricht an den Telegram-Chat gesendet.';

  @override
  String get help_howToUse_04 =>
      'Fertig! Die App ist jetzt bereit, eingehende SMS an Ihren Bot weiterzuleiten. Tippen Sie auf Start, um die SMS-Weiterleitung zu aktivieren, oder auf Stopp, um sie zu deaktivieren.';

  @override
  String get help_howToUse_04l =>
      'Beim Weiterleiten von SMS von mehreren Geräten können Sie in den Einstellungen ein Gerätelabel festlegen, um das empfangende Telefon zu identifizieren.';

  @override
  String get help_howToUse_05 =>
      'Es wird empfohlen, die Akkuoptimierung für diese App zu deaktivieren, da das System zur Energieeinsparung die Arbeit von Apps im Hintergrund einschränken kann.';

  @override
  String get help_howToUse_06 =>
      'Stellen Sie sicher, dass die Internetverbindung aktiviert ist, damit die App funktioniert.';

  @override
  String get help_filters => 'Filter';

  @override
  String get help_filters_01 =>
      'Sie können Filter für Absender oder Text eingehender SMS festlegen. Ein Filter wird ausgelöst, wenn Nummer/Name des Absenders oder Text die angegebenen Zeichen enthalten.';

  @override
  String get help_filters_02 =>
      'Es gibt zwei Modi: Whitelist (SMS wird weitergeleitet, wenn mindestens ein Filter zutrifft) und Blacklist (SMS wird nicht weitergeleitet, wenn ein Filter zutrifft). Im Whitelist-Modus werden ohne Filter keine SMS an den Bot weitergeleitet.';

  @override
  String get help_filters_03 =>
      'Verwenden Sie zwei Schrägstriche für Regex. Zum Beispiel trifft Filter /^\\d*555\$/ auf alle Nummern zu, die mit 555 enden';

  @override
  String get help_filters_04 =>
      'Um zu prüfen, ob eine bestimmte SMS basierend auf den aktuellen Filtern weitergeleitet wird, geben Sie den Absender und/oder die Nachricht in die Felder ein und klicken Sie auf die Schaltfläche.';

  @override
  String get error_badRequest =>
      'Anfrage wurde abgelehnt. Prüfen Sie die eingegebenen Verbindungsparameter.';

  @override
  String get error_invalidParams =>
      'Ungültige Verbindungsparameter. Korrigieren Sie diese und versuchen Sie es erneut.';

  @override
  String get error_networkError =>
      'Internetverbindung prüfen und erneut versuchen.';

  @override
  String get error_networkTimeout =>
      'Zeitüberschreitung. Prüfen Sie Ihre Internetverbindung und stellen Sie sicher, dass die Verbindungsparameter korrekt sind.';

  @override
  String get error_rateLimited =>
      'Zu viele Anfragen. Bitte warten Sie kurz und versuchen Sie es erneut.';

  @override
  String get error_serverError =>
      'Der Server ist derzeit nicht verfügbar. Bitte später versuchen.';

  @override
  String get error_smtpAddressRejected =>
      'Der Server hat die E-Mail des Absenders oder Empfängers abgelehnt. Prüfen Sie die Adressen.';

  @override
  String get error_smtpError =>
      'Der Server hat einen Fehler zurückgegeben. Prüfen Sie die eingegebenen Verbindungsparameter.';

  @override
  String get error_smtp_forbidden =>
      'Aktion wurde vom Server abgelehnt. Prüfen Sie die Zugriffsrechte.';

  @override
  String get error_smtp_unauthorized =>
      'Autorisierungsfehler. Prüfen Sie Login und Passwort.';

  @override
  String get error_tbot_conflict =>
      'Chat-ID konnte nicht abgerufen werden. Entfernen Sie den aktiven Webhook oder geben Sie die ID manuell ein.';

  @override
  String get error_tbot_forbidden =>
      'Telegram hat die Aktion verweigert. Bot-Zugriff auf den Chat prüfen.';

  @override
  String get error_tbot_unauthorized =>
      'Autorisierungsfehler. Geben Sie ein gültiges Token ein und versuchen Sie es erneut.';

  @override
  String get error_tbot_uninitialized =>
      'Chat-ID konnte nicht abgerufen werden. Starten Sie einen Dialog mit Ihrem Bot in Telegram und versuchen Sie es erneut.';

  @override
  String get error_unexpectedError =>
      'Ein unerwarteter Fehler ist aufgetreten. Bitte später versuchen.';
}
