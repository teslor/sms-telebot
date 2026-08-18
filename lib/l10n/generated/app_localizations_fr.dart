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
  String get action_continue => 'Continuer';

  @override
  String get action_delete => 'Supprimer';

  @override
  String get action_duplicate => 'Dupliquer';

  @override
  String get action_exit => 'Quitter';

  @override
  String get action_save => 'Enregistrer';

  @override
  String get action_test => 'Tester';

  @override
  String get service_title => 'SMS Telebot est actif';

  @override
  String get service_text => 'Surveillance des événements';

  @override
  String get msg_list => 'Messages';

  @override
  String get msg_welcome =>
      'Appuyez sur Démarrer\npour activer la surveillance';

  @override
  String get msg_empty => 'Aucun message\nau cours des 24 dernières heures';

  @override
  String get msg_hello => 'Bonjour ! ^._.^';

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
  String get msg_battery => 'Batterie';

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
  String get rules_setup => 'Configuration de la règle';

  @override
  String get config => 'Configuration';

  @override
  String get connection => 'Connexion';

  @override
  String get tbot_token => 'Token du bot';

  @override
  String get tbot_chatId => 'ID du chat';

  @override
  String get tbot_chatIdInfo => 'Par défaut : détection automatique';

  @override
  String get tbot_server => 'URL du serveur';

  @override
  String tbot_serverInfo(Object url) {
    return 'Par défaut : $url';
  }

  @override
  String get ntfy_topic => 'Sujet';

  @override
  String get ntfy_priority => 'Priorité';

  @override
  String get ntfy_priority_01 => 'Minimale';

  @override
  String get ntfy_priority_02 => 'Basse';

  @override
  String get ntfy_priority_03 => 'Par défaut';

  @override
  String get ntfy_priority_04 => 'Haute';

  @override
  String get ntfy_priority_05 => 'Maximale';

  @override
  String get ntfy_token => 'Jeton d\'accès';

  @override
  String get ntfy_tokenInfo => 'Jeton Bearer ; par défaut : aucun jeton';

  @override
  String get ntfy_server => 'URL du serveur';

  @override
  String ntfy_serverInfo(Object url) {
    return 'Par défaut : $url';
  }

  @override
  String get smtp_host => 'Hôte SMTP';

  @override
  String get smtp_protocol => 'Protocole';

  @override
  String get smtp_protocolEmpty => 'Aucun';

  @override
  String get smtp_port => 'Port';

  @override
  String get smtp_insecureTls => 'Validation de certificat assouplie';

  @override
  String get smtp_insecureTlsInfo =>
      'À n\'activer qu\'en cas d\'erreurs de connexion (particulièrement sur les anciens appareils). Cela réduit la sécurité de la connexion.';

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
  String get smtp_fromEmailInfo => 'Par défaut : identifiant';

  @override
  String get smtp_toEmail => 'E-mail du destinataire';

  @override
  String get smtp_toEmailInfo => 'Par défaut : identifiant';

  @override
  String get smtp_subject => 'Objet';

  @override
  String get smtp_subjectInfo => 'Par défaut : auto';

  @override
  String get sms_receiver => 'Destinataire';

  @override
  String get sms_number => 'Numéro de téléphone';

  @override
  String get sms_numberInfo => 'Exemple : +12345678900';

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
  String get options => 'Options';

  @override
  String get options_priority => 'Priorité de la règle';

  @override
  String get options_priorityInfo =>
      'Règle ignorée si une règle de priorité supérieure est déclenchée';

  @override
  String get options_priority_01 => 'Maximale';

  @override
  String get options_priority_02 => 'Haute';

  @override
  String get options_priority_03 => 'Moyenne';

  @override
  String get options_priority_04 => 'Basse';

  @override
  String get options_priority_05 => 'Minimale';

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
  String get settings_attachSimInfo => 'Joindre données SIM';

  @override
  String get settings_deviceLabel => 'Libellé de l\'appareil';

  @override
  String get settings_deviceLabelInfo => 'Par défaut : pas de libellé';

  @override
  String get help_about => 'À propos';

  @override
  String get help_appInfo =>
      'Transfert intelligent des SMS, notifications d\'appels entrants et état de la batterie.';

  @override
  String get help_info => 'Introduction';

  @override
  String get help_info_01 =>
      'Transférez des messages vers Telegram, ntfy, par e-mail ou par SMS. Combinez facilement plusieurs destinations !';

  @override
  String get help_info_02 =>
      'Utilisez les règles pour définir quoi transférer et vers quelle destination. Vous pouvez les dupliquer ou les désactiver selon vos besoins.';

  @override
  String get help_info_03 =>
      'Les messages sont transférés selon les règles actives. En cas d\'erreur de connexion (par exemple sans internet), les nouvelles tentatives sont effectuées automatiquement.';

  @override
  String get help_opts_01 =>
      'Commencez par sélectionner les événements à transférer. Pendant l\'exécution de l\'application, un message est généré et envoyé pour chaque événement selon les règles définies.';

  @override
  String get help_opts_02 =>
      'Le mode permanent en arrière-plan améliore la fiabilité de l\'envoi (surtout pour les notifications système), mais augmente fortement la consommation de batterie. Dans ce mode, une notification persistante apparaît. Il n\'est pas recommandé de l\'activer sans nécessité.';

  @override
  String get help_opts_025 =>
      'Activez l\'option pour ajouter les données de la carte SIM (emplacement et opérateur) lors du transfert des SMS et appels entrants. Les données SIM ne sont pas disponibles sur certains systèmes, notamment pour les appels.';

  @override
  String get help_opts_03 =>
      'Si vous utilisez l\'application sur plusieurs téléphones, vous pouvez définir un libellé d\'appareil. Il est envoyé avec le message pour identifier le téléphone destinataire.';

  @override
  String get help_opts_04 =>
      'Il est recommandé de désactiver l\'optimisation de batterie pour cette application, car le système peut limiter l\'activité en arrière-plan pour économiser l\'énergie.';

  @override
  String get help_rule_01 =>
      'Testez et enregistrez les paramètres (un message de bienvenue est envoyé si le test réussit). Activez ensuite la règle dans la liste et appuyez sur Démarrer pour lancer le transfert !';

  @override
  String get help_tbot_01 =>
      'Pas encore de bot ? Utilisez @BotFather de Telegram pour en créer un et obtenir un token d\'API.';

  @override
  String get help_tbot_02 =>
      'Ouvrez un chat avec votre bot dans l\'application Telegram et envoyez n\'importe quel message. Cela permettra de détecter automatiquement l\'ID du chat.';

  @override
  String get help_tbot_03 =>
      'Ajoutez une règle Telegram et collez votre token. Vous pouvez aussi indiquer l\'ID du chat manuellement.';

  @override
  String get help_tbot_04 =>
      'Vous pouvez aussi indiquer l\'URL d\'un serveur API personnalisé pour l\'utiliser à la place du serveur Telegram officiel.';

  @override
  String help_ntfy_01(Object url) {
    return 'Dans l\'application ntfy ou la version web ($url), abonnez-vous à un nouveau sujet avec un nom difficile à deviner.';
  }

  @override
  String get help_ntfy_02 =>
      'Créez une règle, saisissez le nom du sujet et, éventuellement, définissez la priorité de la notification.';

  @override
  String get help_ntfy_03 =>
      'Les sujets publics sont accessibles à quiconque connaît leur nom. Pour plus de sécurité, utilisez l\'authentification et un jeton d\'accès.';

  @override
  String get help_ntfy_04 =>
      'Le serveur officiel ntfy.sh est utilisé par défaut, mais vous pouvez indiquer un serveur personnalisé.';

  @override
  String get help_smtp_01 =>
      'Il est recommandé de créer une adresse e-mail séparée (pas un alias) spécialement pour le transfert de messages et de l\'utiliser comme identifiant. C\'est particulièrement important pour Gmail et les services similaires.';

  @override
  String get help_smtp_02 =>
      'Créez une règle et remplissez les paramètres. Un \'mot de passe d\'application\' est généralement requis (à générer dans la sécurité de votre boîte mail).';

  @override
  String get help_sms_01 =>
      'L\'application prend en charge le transfert des messages sous forme de SMS sortants.';

  @override
  String get help_sms_02 =>
      'Créez une règle et saisissez le numéro de téléphone du destinataire. Le numéro mobile doit commencer par le symbole + (format international).';

  @override
  String get help_sms_03 =>
      'Les SMS sont envoyés via la carte SIM sélectionnée par défaut dans les paramètres du téléphone.';

  @override
  String get help_filters => 'Filtres';

  @override
  String get help_filters_01 =>
      'Pour chaque règle, vous pouvez définir des filtres pour l\'expéditeur et le texte du message. Un filtre correspond si le numéro/nom de l\'expéditeur ou le texte contient les caractères indiqués.';

  @override
  String get help_filters_02 =>
      'Il existe deux modes : liste blanche (le message est transféré si au moins un filtre correspond) et liste noire (le message n\'est pas transféré si un filtre correspond). En mode liste blanche, sans filtres définis, aucun message ne sera transféré.';

  @override
  String get help_filters_03 =>
      'Utilisez deux caractères / pour définir une expression régulière comme filtre. Par exemple, le filtre /^\\d*555\$/ correspond aux numéros se terminant par 555.';

  @override
  String get help_filters_04 =>
      'Pour vérifier si un message précis sera transféré selon les filtres actuels, saisissez l\'expéditeur et/ou le texte dans les champs, puis appuyez sur le bouton de vérification.';

  @override
  String get help_filters_05 =>
      'Les filtres définis s\'appliquent à tous les types d\'événements, pas uniquement aux SMS entrants.';

  @override
  String get help_options_01 =>
      'La priorité de la règle détermine l\'ordre de traitement. Si une règle se déclenche (message envoyé), les règles de priorité inférieure sont ignorées. Les règles de même priorité se déclenchent simultanément.';

  @override
  String get consent_welcome =>
      'Bienvenue !\nEn continuant, vous confirmez avoir pris connaissance de ces informations :';

  @override
  String get consent_item_01 =>
      'Selon les fonctions activées, l\'application peut recevoir des données sur les SMS et appels entrants, et envoyer des SMS aux numéros que vous indiquez.';

  @override
  String get consent_item_02 =>
      'Les données sont transmises uniquement aux services que vous avez vous-même configurés. Il n\'y a ni serveurs cachés ni analyse.';

  @override
  String get consent_item_03 =>
      'Les autorisations sensibles ne sont demandées que lorsque vous activez les fonctions correspondantes.';

  @override
  String get consent_details => 'En savoir plus : ';

  @override
  String get consent_privacyPolicy => 'politique de confidentialité';

  @override
  String get error_badRequest =>
      'Le serveur a rejeté la requête. Vérifiez les paramètres de connexion.';

  @override
  String get error_forbidden =>
      'Erreur d\'autorisation. Vérifiez les droits d\'accès.';

  @override
  String get error_invalidParams => 'Paramètres de connexion non valides.';

  @override
  String get error_networkError =>
      'Erreur de connexion. Vérifiez votre connexion internet ou les paramètres réseau.';

  @override
  String get error_networkTimeout =>
      'Délai d\'attente dépassé. Vérifiez le réseau ou les paramètres de connexion.';

  @override
  String get error_rateLimited =>
      'Limite de requêtes dépassée. Réessayez plus tard.';

  @override
  String get error_serverError => 'Erreur du serveur. Réessayez plus tard.';

  @override
  String get error_smtpAddressRejected =>
      'Le serveur a rejeté l\'e-mail de l\'expéditeur ou du destinataire. Vérifiez les adresses.';

  @override
  String get error_smtpError =>
      'Le serveur a renvoyé une erreur. Vérifiez les paramètres de connexion.';

  @override
  String get error_smtp_unauthorized =>
      'Erreur d\'accès. Vérifiez l\'identifiant et le mot de passe.';

  @override
  String get error_tbot_conflict =>
      'Impossible d\'obtenir l\'ID du chat. Supprimez le webhook actif ou saisissez l\'ID manuellement.';

  @override
  String get error_tbot_forbidden =>
      'Erreur d\'autorisation. Assurez-vous que le bot a accès au chat.';

  @override
  String get error_tbot_unauthorized => 'Erreur d\'accès. Vérifiez le jeton.';

  @override
  String get error_tbot_uninitialized =>
      'Impossible d\'obtenir l\'ID du chat. Démarrez un dialogue avec votre bot dans Telegram et réessayez.';

  @override
  String get error_unauthorized =>
      'Erreur d\'accès. Vérifiez les identifiants.';

  @override
  String get error_unexpectedError => 'Impossible d\'exécuter l\'action.';

  @override
  String get error_secretsError =>
      'Impossible d\'accéder au stockage sécurisé. Réessayez. Si l\'erreur persiste, redémarrez l\'application et vérifiez les mots de passe/tokens dans les règles de transfert.';

  @override
  String get warn_secretsRecovered =>
      'Le stockage sécurisé a été restauré après un plantage ; les mots de passe/tokens enregistrés ont peut-être été supprimés. Vérifiez les règles de transfert et ressaisissez les données.';

  @override
  String get warn_permissionsRequired =>
      'Pour démarrer la surveillance, accordez les autorisations requises.';
}
