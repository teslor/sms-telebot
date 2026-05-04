// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get action_cancel => 'Annuler';

  @override
  String get action_delete => 'Supprimer';

  @override
  String get action_duplicate => 'Dupliquer';

  @override
  String get action_save => 'Enregistrer';

  @override
  String get action_test => 'Tester';

  @override
  String get msg_list => 'Messages';

  @override
  String get msg_welcome =>
      'Appuyez sur Démarrer\npour activer la surveillance';

  @override
  String get msg_empty => 'Aucun message\nau cours des 24 dernières heures';

  @override
  String get msg_hello => 'Bonjour ! =^•⩊•^=';

  @override
  String get msg_received => 'Reçu';

  @override
  String get msg_sent => 'Transféré';

  @override
  String get msg_start => 'Démarrer';

  @override
  String get msg_stop => 'Arrêter';

  @override
  String get msg_sms => 'SMS';

  @override
  String get msg_call => 'Appel';

  @override
  String get msg_lowBattery => 'Batterie faible';

  @override
  String get msg_chargerConnected => 'Chargeur branché';

  @override
  String get msg_chargerDisconnected => 'Chargeur débranché';

  @override
  String get rule => 'Règle';

  @override
  String get rule_add => 'Ajouter une règle';

  @override
  String get rule_copySuffix => 'copie';

  @override
  String get rule_deleteHeader => 'Supprimer la règle ?';

  @override
  String get rule_deleteText => 'Cette action est irréversible.';

  @override
  String get rule_noParams =>
      'Veuillez configurer cette règle avant de l\'activer.';

  @override
  String get rules => 'Règles';

  @override
  String get rules_empty =>
      'Aucune règle pour l\'instant.\nAjoutez la première !';

  @override
  String get connection => 'Connexion';

  @override
  String get tbot => 'Bot Telegram';

  @override
  String get tbot_token => 'Token du bot';

  @override
  String get tbot_tokenInfo => 'Token obtenu de @BotFather';

  @override
  String get tbot_chatId => 'ID du chat';

  @override
  String get tbot_chatIdInfo => 'ID du chat avec votre bot (facultatif)';

  @override
  String get smtp => 'Serveur SMTP';

  @override
  String get smtp_host => 'Hôte SMTP';

  @override
  String get smtp_protocol => 'Protocole';

  @override
  String get smtp_protocolEmpty => 'Aucun';

  @override
  String get smtp_port => 'Port';

  @override
  String get smtp_login => 'Identifiant';

  @override
  String get smtp_loginInfo => 'Généralement l\'adresse e-mail complète';

  @override
  String get smtp_password => 'Mot de passe';

  @override
  String get smtp_passwordInfo =>
      'Généralement le mot de passe pour applications externes';

  @override
  String get smtp_fromEmail => 'E-mail de l\'expéditeur';

  @override
  String get smtp_fromEmailInfo => 'Optionnel - identifiant si vide';

  @override
  String get smtp_toEmail => 'E-mail du destinataire';

  @override
  String get smtp_toEmailInfo => 'Adresse e-mail du destinataire';

  @override
  String get smtp_subject => 'Objet';

  @override
  String get smtp_subjectInfo => 'Objet de l\'e-mail (facultatif)';

  @override
  String get filters => 'Filtres';

  @override
  String get filters_off => 'Désactivé';

  @override
  String get filters_whitelist => 'Liste blanche';

  @override
  String get filters_blacklist => 'Liste noire';

  @override
  String get filters_sender => 'Expéditeur';

  @override
  String get filters_senderInfo => 'Ajoutez des filtres pour numéros ou noms';

  @override
  String get filters_text => 'Message';

  @override
  String get filters_textInfo => 'Ajouter des filtres de texte';

  @override
  String get settings => 'Paramètres';

  @override
  String get settings_forwardEvents => 'Événements à transférer';

  @override
  String get settings_forwardSms => 'SMS entrants';

  @override
  String get settings_forwardCalls => 'Appels entrants';

  @override
  String get settings_notifyLowBattery => 'Batterie faible';

  @override
  String get settings_notifyChargerState => 'État du chargeur';

  @override
  String get settings_enableForeground => 'Toujours exécuter en arrière-plan';

  @override
  String get settings_deviceLabel => 'Libellé de l\'appareil';

  @override
  String get settings_deviceLabelInfo => 'Libellé personnalisé (facultatif)';

  @override
  String get help_about => 'À propos';

  @override
  String get help_appInfo =>
      'Application pour transférer automatiquement les SMS entrants.\nFonctions supplémentaires : notifications d\'appels entrants et d\'état de batterie.';

  @override
  String get help_info => 'Introduction';

  @override
  String get help_info_01 =>
      'Avec cette application, vous pouvez transférer des messages vers un bot Telegram ou une adresse e-mail avec accès SMTP. Vous pouvez ajouter plusieurs bots ou adresses e-mail.';

  @override
  String get help_info_02 =>
      'Une règle de transfert est créée pour chaque connexion : elle définit quels messages envoyer et vers quelle destination. Les règles peuvent être dupliquées, activées ou désactivées selon vos besoins.';

  @override
  String get help_info_03 =>
      'L\'application vérifie les règles actives et tente de transférer chaque nouveau message. En cas d\'échec technique (par exemple sans internet), elle réessaiera plus tard.';

  @override
  String get help_info_04 =>
      'Assurez-vous de garder la connexion internet active pour que l\'application fonctionne correctement.';

  @override
  String get help_opts_01 =>
      'Commencez par sélectionner les événements à transférer. Pendant l\'exécution de l\'application, un message est généré et envoyé pour chaque événement selon les règles définies.';

  @override
  String get help_opts_02 =>
      'Le mode permanent en arrière-plan améliore la fiabilité de l\'envoi (surtout pour les notifications système), mais augmente fortement la consommation de batterie. Dans ce mode, une notification persistante apparaît. Il n\'est pas recommandé de l\'activer sans nécessité.';

  @override
  String get help_opts_03 =>
      'Lorsque vous transférez des messages depuis plusieurs téléphones, vous pouvez définir un libellé d\'appareil. Il est envoyé avec le message pour identifier le téléphone source.';

  @override
  String get help_opts_04 =>
      'Il est recommandé de désactiver l\'optimisation de batterie pour cette application, car le système peut limiter l\'activité en arrière-plan pour économiser l\'énergie.';

  @override
  String get help_tbot => 'Connexion au Bot Telegram';

  @override
  String get help_tbot_01 =>
      'Si vous n\'avez pas encore de bot Telegram, utilisez @BotFather pour en créer un et obtenir son token. C\'est simple et gratuit.';

  @override
  String get help_tbot_02 =>
      'Ouvrez un chat avec votre bot dans Telegram, démarrez une conversation ou envoyez un message. Ceci est nécessaire pour récupérer automatiquement l\'ID du chat.';

  @override
  String get help_tbot_03 =>
      'Créez une règle pour le bot Telegram dans l\'application et saisissez le jeton (token). Vous pouvez aussi ajouter l\'ID du chat. Testez puis enregistrez. Un message de bienvenue confirmera la réussite.';

  @override
  String get help_tbot_04 =>
      'Terminé ! Tout est prêt pour transférer les messages vers votre bot. Activez la règle et appuyez sur Démarrer pour commencer.';

  @override
  String get help_smtp => 'Connexion au serveur SMTP';

  @override
  String get help_smtp_01 =>
      'Pour le transfert de messages, il est préférable de créer une adresse e-mail dédiée (pas un alias) : elle servira aussi d\'identifiant. C\'est particulièrement important pour Gmail et les services similaires.';

  @override
  String get help_smtp_02 =>
      'Créez une règle et remplissez les paramètres. Un \'mot de passe d\'application\' est généralement requis (à générer dans la sécurité de votre boîte mail).';

  @override
  String get help_smtp_03 =>
      'Testez et enregistrez les paramètres, activez la règle et appuyez sur Démarrer.';

  @override
  String get help_filters => 'Filtres';

  @override
  String get help_filters_01 =>
      'Vous pouvez définir des filtres pour l\'expéditeur ou le texte du message. Un filtre se déclenche si le numéro/nom de l\'expéditeur ou le texte contient les caractères indiqués.';

  @override
  String get help_filters_02 =>
      'Il existe deux modes : liste blanche (le message est transféré si au moins un filtre correspond) et liste noire (le message n\'est pas transféré si un filtre correspond). En mode liste blanche, sans filtres définis, aucun message ne sera transféré.';

  @override
  String get help_filters_03 =>
      'Utilisez deux barres obliques pour regex. Par exemple, le filtre /^\\d*555\$/ correspond à tous les numéros se terminant par 555';

  @override
  String get help_filters_04 =>
      'Pour vérifier si un message précis sera transféré selon les filtres actuels, saisissez l\'expéditeur et/ou le texte dans les champs, puis appuyez sur le bouton de vérification.';

  @override
  String get help_filters_05 =>
      'Les filtres définis s\'appliquent à tous les types d\'événements, pas uniquement aux SMS entrants.';

  @override
  String get error_badRequest =>
      'La requête a été rejetée. Vérifiez les paramètres de connexion saisis.';

  @override
  String get error_invalidParams =>
      'Paramètres de connexion invalides. Corrigez-les et réessayez.';

  @override
  String get error_networkError =>
      'Vérifiez votre connexion internet et réessayez.';

  @override
  String get error_networkTimeout =>
      'Délai d\'attente dépassé. Vérifiez votre connexion internet et assurez-vous que les paramètres de connexion sont corrects.';

  @override
  String get error_rateLimited =>
      'Trop de requêtes. Veuillez patienter un instant et réessayer.';

  @override
  String get error_serverError =>
      'Le serveur est actuellement indisponible. Veuillez réessayer plus tard.';

  @override
  String get error_smtpAddressRejected =>
      'Le serveur a rejeté l\'e-mail de l\'expéditeur ou du destinataire. Vérifiez les adresses.';

  @override
  String get error_smtpError =>
      'Le serveur a renvoyé une erreur. Vérifiez les paramètres de connexion saisis.';

  @override
  String get error_smtp_forbidden =>
      'L\'action a été rejetée par le serveur. Vérifiez les droits d\'accès.';

  @override
  String get error_smtp_unauthorized =>
      'Erreur d\'autorisation. Vérifiez l\'identifiant et le mot de passe.';

  @override
  String get error_tbot_conflict =>
      'Impossible d\'obtenir l\'ID du chat. Supprimez le webhook actif ou saisissez l\'ID manuellement.';

  @override
  String get error_tbot_forbidden =>
      'Action refusée par Telegram. Vérifiez l\'accès du bot au chat.';

  @override
  String get error_tbot_unauthorized =>
      'Erreur d\'autorisation. Saisissez un jeton valide et réessayez.';

  @override
  String get error_tbot_uninitialized =>
      'Impossible d\'obtenir l\'ID du chat. Démarrez un dialogue avec votre bot dans Telegram et réessayez.';

  @override
  String get error_unexpectedError =>
      'Une erreur inattendue est survenue. Veuillez réessayer plus tard.';

  @override
  String get error_secretsError =>
      'Impossible d\'accéder au stockage sécurisé. Réessayez. Si l\'erreur persiste, redémarrez l\'application et vérifiez les mots de passe/tokens dans les règles de transfert.';

  @override
  String get warn_secretsRecovered =>
      'Le stockage sécurisé a été restauré après un plantage ; les mots de passe/tokens enregistrés ont peut-être été supprimés. Vérifiez les règles de transfert et ressaisissez les données.';

  @override
  String get warn_permissionsRequired =>
      'Pour démarrer la surveillance, veuillez accorder les autorisations requises.';
}
