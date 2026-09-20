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
  String get action_close => 'Schließen';

  @override
  String get action_continue => 'Fortfahren';

  @override
  String get action_delete => 'Löschen';

  @override
  String get action_duplicate => 'Duplizieren';

  @override
  String get action_exit => 'Verlassen';

  @override
  String get action_save => 'Speichern';

  @override
  String get action_test => 'Testen';

  @override
  String get msg_list => 'Nachrichten';

  @override
  String get msg_welcome =>
      'Tippen Sie auf Start,\num die Überwachung zu aktivieren';

  @override
  String get msg_empty => 'Keine Nachrichten\nin den letzten 24 Stunden';

  @override
  String get msg_hello => 'Hallo! ^._.^';

  @override
  String get msg_received => 'Empfangen';

  @override
  String get msg_sent => 'Weitergeleitet';

  @override
  String get msg_start => 'Start';

  @override
  String get msg_stop => 'Stopp';

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
  String get rules_setup => 'Regel einrichten';

  @override
  String get config => 'Parameter';

  @override
  String get connection => 'Verbindung';

  @override
  String get tbot_token => 'Bot-Token';

  @override
  String get tbot_chatId => 'Chat-ID';

  @override
  String get tbot_chatIdInfo => 'Standard: automatische Erkennung';

  @override
  String get tbot_server => 'Server-URL';

  @override
  String tbot_serverInfo(Object url) {
    return 'Standard: $url';
  }

  @override
  String get ntfy_topic => 'Thema';

  @override
  String get ntfy_priority => 'Priorität';

  @override
  String get ntfy_priority_01 => 'Minimum';

  @override
  String get ntfy_priority_02 => 'Niedrig';

  @override
  String get ntfy_priority_03 => 'Standard';

  @override
  String get ntfy_priority_04 => 'Hoch';

  @override
  String get ntfy_priority_05 => 'Maximum';

  @override
  String get ntfy_token => 'Access-Token';

  @override
  String get ntfy_tokenInfo => 'Bearer-Token; Standard: kein Token';

  @override
  String get ntfy_server => 'Server-URL';

  @override
  String ntfy_serverInfo(Object url) {
    return 'Standard: $url';
  }

  @override
  String get smtp_host => 'SMTP-Host';

  @override
  String get smtp_protocol => 'Protokoll';

  @override
  String get smtp_protocolEmpty => 'Keins';

  @override
  String get smtp_port => 'Port';

  @override
  String get smtp_insecureTls => 'Vereinfachte Zertifikatsprüfung';

  @override
  String get smtp_insecureTlsInfo =>
      'Nur bei Verbindungsfehlern aktivieren (besonders bei älteren Geräten). Dies verringert die Verbindungssicherheit.';

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
  String get smtp_subjectInfo => 'Standard: auto';

  @override
  String get sms_receiver => 'Empfänger';

  @override
  String get sms_number => 'Telefonnummer';

  @override
  String get sms_numberInfo => 'Beispiel: +12345678900';

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
  String get options => 'Parameter';

  @override
  String get options_priority => 'Regelpriorität';

  @override
  String get options_priorityInfo =>
      'Regel wird ignoriert, wenn eine Regel mit höherer Priorität ausgelöst wird';

  @override
  String get options_priority_01 => 'Höchste';

  @override
  String get options_priority_02 => 'Hoch';

  @override
  String get options_priority_03 => 'Mittel';

  @override
  String get options_priority_04 => 'Niedrig';

  @override
  String get options_priority_05 => 'Niedrigste';

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
  String get settings_attachSimInfo => 'SIM-Info anhängen';

  @override
  String get settings_format => 'Nachrichtenformat';

  @override
  String get settings_formatDefault => 'Standard';

  @override
  String get settings_formatPaste => 'Einfügen';

  @override
  String get settings_formatPreview => 'Vorschau anzeigen';

  @override
  String get settings_formatReset => 'Zurücksetzen';

  @override
  String get settings_formatError => 'Ungültiges Vorlagformat.';

  @override
  String get settings_deviceLabel => 'Gerätename';

  @override
  String get settings_deviceLabelInfo => 'Standard: keine Bezeichnung';

  @override
  String get help_about => 'Über';

  @override
  String get help_appInfo =>
      'Intelligente Weiterleitung von SMS sowie Benachrichtigungen zu eingehenden Anrufen und zum Akkustatus.';

  @override
  String get help_info => 'Einführung';

  @override
  String get help_info_01 =>
      'Leiten Sie Nachrichten an Telegram, ntfy, per E-Mail oder als SMS weiter. Mehrere Ziele lassen sich einfach kombinieren!';

  @override
  String get help_info_02 =>
      'Verwenden Sie Regeln, um festzulegen, was wohin weitergeleitet wird. Regeln lassen sich bei Bedarf einfach duplizieren oder deaktivieren.';

  @override
  String get help_info_03 =>
      'Nachrichten werden gemäß den aktiven Regeln weitergeleitet. Tritt ein Verbindungsfehler auf (z. B. kein Internet), erfolgen Wiederholungsversuche automatisch.';

  @override
  String get help_opts_01 =>
      'Wählen Sie zuerst die Ereignisse aus, die Sie weiterleiten möchten. Während die App läuft, wird für jedes Ereignis entsprechend den festgelegten Regeln eine Nachricht erstellt und gesendet.';

  @override
  String get help_opts_02 =>
      'Der dauerhafte Hintergrundmodus verbessert die Zuverlässigkeit der Zustellung (insbesondere bei Systembenachrichtigungen), erhöht aber den Akkuverbrauch deutlich. In diesem Modus wird eine permanente Benachrichtigung angezeigt. Aktivieren Sie ihn nur bei Bedarf.';

  @override
  String get help_opts_03 =>
      'Aktivieren Sie den Schalter, um beim Weiterleiten eingehender SMS und Anrufe SIM-Daten (Slot und Anbieter) hinzuzufügen. Auf manchen Systemen sind SIM-Daten nicht verfügbar (insbesondere bei Anrufen).';

  @override
  String get help_opts_04 =>
      'Wenn Sie das Nachrichtenformat ändern möchten, laden Sie die Vorlagendatei herunter, nehmen Sie Ihre Änderungen vor und fügen Sie den Vorlagentext in den Einstellungen ein.';

  @override
  String get help_opts_04h => 'Vorlage öffnen';

  @override
  String get help_opts_05 =>
      'Wenn Sie die App auf mehreren Telefonen verwenden, können Sie eine Gerätebezeichnung festlegen. Diese wird zusammen mit der Nachricht gesendet, um das empfangende Telefon zu identifizieren.';

  @override
  String get help_opts_06 =>
      'Es wird empfohlen, die Akkuoptimierung für diese App zu deaktivieren, da das System die Hintergrundaktivität zur Energieeinsparung einschränken kann.';

  @override
  String get help_rule_01 =>
      'Testen und speichern Sie die Einstellungen (bei erfolgreichem Test wird eine Begrüßungsnachricht gesendet). Aktivieren Sie anschließend die Regel in der Liste und tippen Sie auf Start, um die Weiterleitung zu starten!';

  @override
  String get help_tbot_01 =>
      'Noch keinen Bot? Erstellen Sie einen mit Telegrams @BotFather und erhalten Sie ein API-Token.';

  @override
  String get help_tbot_02 =>
      'Öffnen Sie in der Telegram-App einen Chat mit Ihrem Bot und senden Sie eine beliebige Nachricht. So kann Ihre Chat-ID automatisch erkannt werden.';

  @override
  String get help_tbot_03 =>
      'Fügen Sie eine Telegram-Regel hinzu und tragen Sie Ihr Token ein. Optional können Sie die Chat-ID manuell festlegen.';

  @override
  String get help_tbot_04 =>
      'Sie können auch eine eigene API-Server-URL angeben, um sie statt des offiziellen Telegram-Servers zu verwenden.';

  @override
  String help_ntfy_01(Object url) {
    return 'Abonnieren Sie in der ntfy-App oder der Webversion ($url) ein neues Thema mit einem Namen, der schwer zu erraten ist.';
  }

  @override
  String get help_ntfy_02 =>
      'Erstellen Sie eine Regel, geben Sie den Themennamen ein und legen Sie optional eine Benachrichtigungspriorität fest.';

  @override
  String get help_ntfy_03 =>
      'Öffentliche Themen sind für jeden zugänglich, der ihren Namen kennt. Für mehr Sicherheit nutzen Sie Authentifizierung und Access-Token.';

  @override
  String get help_ntfy_04 =>
      'Standardmäßig wird der offizielle Server ntfy.sh verwendet, Sie können aber einen eigenen Server angeben.';

  @override
  String get help_smtp_01 =>
      'Es wird empfohlen, eine separate E-Mail-Adresse (kein Alias) speziell für die Nachrichtenweiterleitung zu erstellen und als Login zu verwenden. Das ist besonders bei Gmail und ähnlichen Diensten wichtig.';

  @override
  String get help_smtp_02 =>
      'Erstellen Sie eine Regel und füllen Sie die Verbindungsparameter aus. Meist wird ein App-Passwort benötigt (in den Sicherheitseinstellungen Ihres E-Mail-Anbieters zu erstellen).';

  @override
  String get help_sms_01 =>
      'Die App unterstützt das Weiterleiten von Nachrichten als ausgehende SMS.';

  @override
  String get help_sms_02 =>
      'Erstellen Sie eine Regel und geben Sie die Telefonnummer des Empfängers ein. Die Mobilnummer muss mit dem Symbol + beginnen (internationales Format).';

  @override
  String get help_sms_03 =>
      'SMS werden über die in den Telefoneinstellungen standardmäßig ausgewählte SIM-Karte gesendet.';

  @override
  String get help_filters => 'Filter';

  @override
  String get help_filters_01 =>
      'Für jede Regel können Sie Filter für Absender und Nachrichtentext festlegen. Ein Filter greift, wenn Absendernummer/-name oder der Text die angegebenen Zeichen enthält.';

  @override
  String get help_filters_02 =>
      'Es gibt zwei Modi: Whitelist (Nachricht wird weitergeleitet, wenn mindestens ein Filter passt) und Blacklist (Nachricht wird nicht weitergeleitet, wenn ein Filter passt). Im Whitelist-Modus werden ohne Filter keine Nachrichten weitergeleitet.';

  @override
  String get help_filters_03 =>
      'Verwenden Sie zwei /-Zeichen, um einen regulären Ausdruck als Filter festzulegen. Zum Beispiel passt der Filter /^\\d*555\$/ auf Nummern, die mit 555 enden.';

  @override
  String get help_filters_04 =>
      'Um zu prüfen, ob eine bestimmte Nachricht mit den aktuellen Filtern weitergeleitet wird, geben Sie Absender und/oder Nachrichtentext ein und tippen Sie auf die Prüfen-Schaltfläche.';

  @override
  String get help_filters_05 =>
      'Die angegebenen Filter gelten für alle Ereignistypen, nicht nur für eingehende SMS.';

  @override
  String get help_options_01 =>
      'Die Regelpriorität bestimmt die Verarbeitungsreihenfolge. Wenn eine Regel ausgelöst wird (Nachricht gesendet), werden Regeln mit niedrigerer Priorität übersprungen. Regeln mit gleicher Priorität werden gleichzeitig ausgeführt.';

  @override
  String get consent_welcome =>
      'Willkommen!\nWenn Sie fortfahren, bestätigen Sie, dass Sie diese Informationen gelesen haben:';

  @override
  String get consent_item_01 =>
      'Je nach aktivierten Funktionen kann die App Daten über eingehende SMS und Anrufe empfangen sowie SMS an die von Ihnen angegebenen Nummern senden.';

  @override
  String get consent_item_02 =>
      'Daten werden nur an die von Ihnen selbst eingerichteten Dienste übertragen. Es gibt keine versteckten Server und keine Analyse.';

  @override
  String get consent_item_03 =>
      'Sensible Berechtigungen werden nur aktiviert, wenn Sie die entsprechenden Funktionen einschalten.';

  @override
  String get consent_details => 'Mehr erfahren: ';

  @override
  String get consent_privacyPolicy => 'Datenschutzerklärung';

  @override
  String get error_badRequest =>
      'Der Server hat die Anfrage abgelehnt. Prüfen Sie die Verbindungsparameter.';

  @override
  String get error_forbidden =>
      'Autorisierungsfehler. Prüfen Sie die Zugriffsrechte.';

  @override
  String get error_invalidParams => 'Ungültige Verbindungsparameter.';

  @override
  String get error_networkError =>
      'Verbindungsfehler. Prüfen Sie die Internetverbindung oder Netzwerkeinstellungen.';

  @override
  String get error_networkTimeout =>
      'Zeitüberschreitung. Prüfen Sie das Netzwerk oder die Verbindungsparameter.';

  @override
  String get error_rateLimited =>
      'Anfragelimit überschritten. Versuchen Sie es später erneut.';

  @override
  String get error_serverError =>
      'Serverfehler. Versuchen Sie es später erneut.';

  @override
  String get error_smtpAddressRejected =>
      'Der Server hat die E-Mail des Absenders oder Empfängers abgelehnt. Prüfen Sie die Adressen.';

  @override
  String get error_smtpError =>
      'Der Server hat einen Fehler zurückgegeben. Prüfen Sie die Verbindungsparameter.';

  @override
  String get error_smtp_unauthorized =>
      'Zugriffsfehler. Prüfen Sie Login und Passwort.';

  @override
  String get error_tbot_conflict =>
      'Chat-ID konnte nicht abgerufen werden. Entfernen Sie den aktiven Webhook oder geben Sie die ID manuell ein.';

  @override
  String get error_tbot_forbidden =>
      'Autorisierungsfehler. Stellen Sie sicher, dass der Bot Zugriff auf den Chat hat.';

  @override
  String get error_tbot_unauthorized => 'Zugriffsfehler. Prüfen Sie das Token.';

  @override
  String get error_tbot_uninitialized =>
      'Chat-ID konnte nicht abgerufen werden. Starten Sie einen Dialog mit Ihrem Bot in Telegram und versuchen Sie es erneut.';

  @override
  String get error_unauthorized =>
      'Zugriffsfehler. Prüfen Sie Ihre Zugangsdaten.';

  @override
  String get error_unexpectedError =>
      'Die Aktion konnte nicht ausgeführt werden.';

  @override
  String get error_secretsError =>
      'Kein Zugriff auf den sicheren Speicher. Versuchen Sie es erneut. Wenn der Fehler bestehen bleibt, starten Sie die App neu und prüfen Sie Passwörter/Tokens in den Weiterleitungsregeln.';

  @override
  String get warn_secretsRecovered =>
      'Der sichere Speicher wurde nach einem Absturz wiederhergestellt. Gespeicherte Passwörter/Tokens wurden möglicherweise gelöscht. Prüfen Sie die Weiterleitungsregeln und geben Sie die Daten erneut ein.';

  @override
  String get warn_permissionsRequired =>
      'Erteilen Sie die erforderlichen Berechtigungen, um die Überwachung zu starten.';
}
