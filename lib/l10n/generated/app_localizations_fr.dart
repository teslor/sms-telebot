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
  String get sms => 'SMS';

  @override
  String get sms_welcome =>
      'Appuyez sur Démarrer pour\ncommencer à transférer les SMS';

  @override
  String get sms_empty => 'Aucun SMS entrant\nau cours des dernières 24 heures';

  @override
  String get sms_hello => 'Bonjour de SMS Telebot ! =^•⩊•^=';

  @override
  String get sms_from => 'SMS de';

  @override
  String get sms_received => 'Reçu';

  @override
  String get sms_sent => 'Transféré';

  @override
  String get sms_start => 'Démarrer';

  @override
  String get sms_stop => 'Arrêter';

  @override
  String get rule => 'Règle';

  @override
  String get rule_add => 'Ajouter une règle de transfert';

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
  String get rules => 'RÈGLES';

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
  String get filters_textInfo => 'Ajoutez des filtres pour le texte du SMS';

  @override
  String get settings => 'PARAMÈTRES';

  @override
  String get settings_deviceLabel => 'Libellé de l\'appareil';

  @override
  String get settings_deviceLabelInfo => 'Libellé personnalisé (facultatif)';

  @override
  String get help_about => 'À propos';

  @override
  String get help_appInfo =>
      'App pour transférer automatiquement les SMS entrants vers un bot Telegram';

  @override
  String get help_info => 'Introduction';

  @override
  String get help_info_01 =>
      'L\'application transfère les SMS vers un bot Telegram ou une adresse e-mail. Vous aurez besoin de votre propre bot ou d\'un compte avec accès SMTP.';

  @override
  String get help_info_02 =>
      'Pour chaque connexion, une règle de transfert est créée : elle définit quels SMS envoyer et vers quelle destination. Les règles peuvent être dupliquées, activées ou désactivées selon les besoins.';

  @override
  String get help_info_03 =>
      'Lorsqu\'un SMS arrive, l\'application vérifie les règles actives et tente le transfert. En cas d\'échec technique (ex: pas d\'internet), l\'application réessaiera plus tard.';

  @override
  String get help_info_04 =>
      'En cas de transfert depuis plusieurs téléphones, vous pouvez définir une étiquette d\'appareil dans les paramètres : elle est envoyée avec le SMS pour identifier le téléphone d\'origine.';

  @override
  String get help_info_05 =>
      'Il est recommandé de désactiver l’optimisation de la batterie pour l’app, car le système peut limiter l’activité des applications en arrière-plan pour économiser l’énergie.';

  @override
  String get help_info_06 =>
      'Assurez-vous de garder la connexion internet activée pour que l\'app fonctionne.';

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
      'Terminé ! Tout est prêt pour transférer les SMS vers votre bot. Activez la règle et appuyez sur Démarrer pour commencer.';

  @override
  String get help_smtp => 'Connexion au serveur SMTP';

  @override
  String get help_smtp_01 =>
      'Pour le transfert de SMS, il est préférable de créer une adresse e-mail dédiée (pas d\'alias) : elle servira d\'identifiant. Particulièrement pertinent pour Gmail et services similaires.';

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
      'Vous pouvez définir des filtres pour l\'expéditeur ou le texte des SMS entrants. Un filtre se déclenche si le numéro/nom de l\'expéditeur ou le texte contient les caractères spécifiés.';

  @override
  String get help_filters_02 =>
      'Il y a deux modes : liste blanche (le SMS est transféré si au moins un filtre correspond) et liste noire (le SMS n\'est pas transféré si un filtre correspond). En mode liste blanche, si aucun filtre n\'est défini, aucun SMS ne sera transféré au bot.';

  @override
  String get help_filters_03 =>
      'Utilisez deux barres obliques pour regex. Par exemple, le filtre /^\\d*555\$/ correspond à tous les numéros se terminant par 555';

  @override
  String get help_filters_04 =>
      'Pour vérifier si un SMS spécifique sera transféré selon les filtres actuels, entrez l\'expéditeur et/ou le message requis dans les champs et cliquez sur le bouton pour vérifier.';

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
}
