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
  String get service_title => 'SMS Telebot ist aktiv';

  @override
  String get service_text => 'Ereignisüberwachung läuft';

  @override
  String get msg_list => 'Nachrichten';

  @override
  String get msg_welcome =>
      'Tippen Sie auf Start,\num die Überwachung zu aktivieren';

  @override
  String get msg_empty => 'Keine Nachrichten\nin den letzten 24 Stunden';

  @override
  String get msg_hello => 'Hallo! =^•⩊•^=';

  @override
  String get msg_received => 'Empfangen';

  @override
  String get msg_sent => 'Weitergeleitet';

  @override
  String get msg_start => 'Start';

  @override
  String get msg_stop => 'Stopp';

  @override
  String get msg_sms => 'SMS';

  @override
  String get msg_call => 'Anruf';

  @override
  String get msg_lowBattery => 'Niedriger Akkustand';

  @override
  String get msg_chargerConnected => 'Ladegerät angeschlossen';

  @override
  String get msg_chargerDisconnected => 'Ladegerät getrennt';

  @override
  String get rule => 'Regel';

  @override
  String get rule_add => 'Regel hinzufügen';

  @override
  String get rule_copySuffix => 'Kopie';

  @override
  String get rule_deleteHeader => 'Regel löschen?';

  @override
  String get rule_deleteText =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get rule_noParams =>
      'Bitte konfigurieren Sie diese Regel, bevor Sie sie aktivieren.';

  @override
  String get rules => 'Regeln';

  @override
  String get rules_empty => 'Noch keine Regeln.\nFügen Sie die erste hinzu!';

  @override
  String get connection => 'Verbindung';

  @override
  String get tbot => 'Telegram-Bot';

  @override
  String get tbot_token => 'Bot-Token';

  @override
  String get tbot_chatId => 'Chat-ID';

  @override
  String get tbot_chatIdInfo => 'Standard: automatische Erkennung';

  @override
  String get tbot_apiUrl => 'API-URL';

  @override
  String get tbot_apiUrlInfo => 'Standard: Telegram-Standard-URL';

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
  String get smtp_fromEmailInfo => 'Standard: Login';

  @override
  String get smtp_toEmail => 'Empfänger-E-Mail';

  @override
  String get smtp_toEmailInfo => 'Standard: Login';

  @override
  String get smtp_subject => 'Betreff';

  @override
  String get smtp_subjectInfo => 'Standard: kein Betreff';

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
  String get filters_textInfo => 'Textfilter hinzufügen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get settings_forwardEvents => 'Weiterzuleitende Ereignisse';

  @override
  String get settings_forwardSms => 'Eingehende SMS';

  @override
  String get settings_forwardCalls => 'Eingehende Anrufe';

  @override
  String get settings_notifyLowBattery => 'Niedriger Akkustand';

  @override
  String get settings_notifyChargerState => 'Ladegerät-Status';

  @override
  String get settings_enableForeground => 'Immer im Hintergrund ausführen';

  @override
  String get settings_deviceLabel => 'Gerätename';

  @override
  String get settings_deviceLabelInfo => 'Standard: keine Bezeichnung';

  @override
  String get help_about => 'Über';

  @override
  String get help_appInfo =>
      'App zum automatischen Weiterleiten eingehender SMS.\nZusätzliche Funktionen: Benachrichtigungen über eingehende Anrufe und den Akkustatus.';

  @override
  String get help_info => 'Einführung';

  @override
  String get help_info_01 =>
      'Mit dieser App können Sie Nachrichten an einen Telegram-Bot oder eine E-Mail-Adresse mit SMTP-Zugang weiterleiten. Sie können mehrere Bots oder E-Mail-Adressen hinzufügen.';

  @override
  String get help_info_02 =>
      'Für jede Verbindung wird eine Weiterleitungsregel erstellt – sie legt fest, welche Nachrichten wohin gesendet werden. Regeln können bei Bedarf dupliziert, aktiviert oder deaktiviert werden.';

  @override
  String get help_info_03 =>
      'Die App prüft aktive Regeln und versucht, neue Nachrichten weiterzuleiten. Falls dies aus technischen Gründen fehlschlägt (z. B. kein Internet), versucht die App es später erneut.';

  @override
  String get help_info_04 =>
      'Stellen Sie sicher, dass die Internetverbindung aktiv bleibt, damit die App korrekt funktioniert.';

  @override
  String get help_opts_01 =>
      'Wählen Sie zuerst die Ereignisse aus, die Sie weiterleiten möchten. Während die App läuft, wird für jedes Ereignis entsprechend den festgelegten Regeln eine Nachricht erstellt und gesendet.';

  @override
  String get help_opts_02 =>
      'Der dauerhafte Hintergrundmodus verbessert die Zuverlässigkeit der Zustellung (insbesondere bei Systembenachrichtigungen), erhöht aber den Akkuverbrauch deutlich. In diesem Modus wird eine permanente Benachrichtigung angezeigt. Aktivieren Sie ihn nur bei Bedarf.';

  @override
  String get help_opts_03 =>
      'Wenn Sie Nachrichten von mehreren Geräten weiterleiten, können Sie eine Gerätebezeichnung festlegen. Diese wird mitgesendet, damit das sendende Gerät leichter erkennbar ist.';

  @override
  String get help_opts_04 =>
      'Es wird empfohlen, die Akkuoptimierung für diese App zu deaktivieren, da das System die Hintergrundaktivität zur Energieeinsparung einschränken kann.';

  @override
  String get help_tbot => 'Telegram-Bot verbinden';

  @override
  String get help_tbot_01 =>
      'Falls Sie noch keinen Telegram-Bot haben, erstellen Sie einen mit @BotFather und erhalten Sie dessen Token. Es ist einfach und kostenlos.';

  @override
  String get help_tbot_02 =>
      'Öffnen Sie einen Chat mit Ihrem Bot in Telegram, starten Sie ein Gespräch oder senden Sie eine Nachricht. Dies ist erforderlich, um die Chat-ID automatisch abzurufen.';

  @override
  String get help_tbot_03 =>
      'Erstellen Sie in der App eine Regel für den Telegram-Bot und geben Sie das Token ein (optional auch die Chat-ID). Testen Sie die Einstellungen und speichern Sie diese. Bei Erfolg erhalten Sie eine Begrüßungsnachricht.';

  @override
  String get help_tbot_04 =>
      'Fertig! Jetzt ist alles bereit, um Nachrichten an Ihren Bot weiterzuleiten. Aktivieren Sie die Regel und tippen Sie auf Start.';

  @override
  String get help_tbot_05 =>
      'Optional können Sie auch eine benutzerdefinierte API-Server-URL festlegen und diese anstelle des offiziellen Telegram-Servers verwenden.';

  @override
  String get help_smtp => 'SMTP-Server verbinden';

  @override
  String get help_smtp_01 =>
      'Für die Nachrichtenweiterleitung empfiehlt es sich, eine eigene E-Mail-Adresse einzurichten (kein Alias): Diese dient auch als Login. Das ist besonders bei Gmail und ähnlichen Diensten wichtig.';

  @override
  String get help_smtp_02 =>
      'Erstellen Sie eine Regel und füllen Sie die Verbindungsparameter aus. Meist wird ein App-Passwort benötigt (in den Sicherheitseinstellungen Ihres E-Mail-Anbieters zu erstellen).';

  @override
  String get help_smtp_03 =>
      'Einstellungen testen und speichern, Regel aktivieren und auf Start drücken.';

  @override
  String get help_filters => 'Filter';

  @override
  String get help_filters_01 =>
      'Sie können Filter für Absender oder Nachrichtentext festlegen. Ein Filter greift, wenn Absendernummer/-name oder Text die angegebenen Zeichen enthalten.';

  @override
  String get help_filters_02 =>
      'Es gibt zwei Modi: Whitelist (Nachricht wird weitergeleitet, wenn mindestens ein Filter passt) und Blacklist (Nachricht wird nicht weitergeleitet, wenn ein Filter passt). Im Whitelist-Modus werden ohne Filter keine Nachrichten weitergeleitet.';

  @override
  String get help_filters_03 =>
      'Verwenden Sie zwei Schrägstriche für Regex. Zum Beispiel trifft Filter /^\\d*555\$/ auf alle Nummern zu, die mit 555 enden';

  @override
  String get help_filters_04 =>
      'Um zu prüfen, ob eine bestimmte Nachricht mit den aktuellen Filtern weitergeleitet wird, geben Sie Absender und/oder Nachrichtentext ein und tippen Sie auf die Prüfen-Schaltfläche.';

  @override
  String get help_filters_05 =>
      'Die angegebenen Filter gelten für alle Ereignistypen, nicht nur für eingehende SMS.';

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

  @override
  String get error_secretsError =>
      'Kein Zugriff auf den sicheren Speicher. Versuchen Sie es erneut. Wenn der Fehler bestehen bleibt, starten Sie die App neu und prüfen Sie Passwörter/Tokens in den Weiterleitungsregeln.';

  @override
  String get warn_secretsRecovered =>
      'Der sichere Speicher wurde nach einem Absturz wiederhergestellt. Gespeicherte Passwörter/Tokens wurden möglicherweise gelöscht. Prüfen Sie die Weiterleitungsregeln und geben Sie die Daten erneut ein.';

  @override
  String get warn_permissionsRequired =>
      'Um mit der Überwachung zu beginnen, erteilen Sie bitte die erforderlichen Berechtigungen.';
}
