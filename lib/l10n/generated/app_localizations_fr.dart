// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get sms => 'SMS';

  @override
  String get sms_welcome =>
      'Appuyez sur Démarrer pour\ncommencer à transférer les SMS';

  @override
  String get sms_empty => 'Aucun SMS entrant\ndans la session actuelle';

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
  String get filters => 'FILTRES';

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
  String get filters_test => 'Tester';

  @override
  String get filters_save => 'Enregistrer';

  @override
  String get settings => 'PARAMÈTRES';

  @override
  String get settings_token => 'Token du bot';

  @override
  String get settings_tokenInfo => 'Token obtenu de @BotFather';

  @override
  String get settings_chatId => 'ID du chat';

  @override
  String get settings_chatIdInfo => 'ID du chat avec votre bot (facultatif)';

  @override
  String get settings_deviceLabel => 'Libellé de l\'appareil';

  @override
  String get settings_deviceLabelInfo => 'Libellé personnalisé (facultatif)';

  @override
  String get settings_test => 'Tester et enregistrer';

  @override
  String get help_about => 'À propos';

  @override
  String get help_appInfo =>
      'App pour transférer automatiquement les SMS entrants vers un bot Telegram';

  @override
  String get help_howToUse => 'Comment utiliser';

  @override
  String get help_howToUse_01 =>
      'Si vous n\'avez pas encore de bot Telegram, utilisez @BotFather pour en créer un et obtenir son token. C\'est simple et gratuit.';

  @override
  String get help_howToUse_02 =>
      'Ouvrez un chat avec votre bot dans Telegram, démarrez une conversation ou envoyez un message. Ceci est nécessaire pour récupérer automatiquement l\'ID du chat.';

  @override
  String get help_howToUse_03 =>
      'Ouvrez l\'app, dans les paramètres du bot, entrez le token et testez les paramètres (vous pouvez aussi définir l\'ID du chat si vous le connaissez). Si le test réussit, les paramètres sont enregistrés et un message de bienvenue est envoyé au chat Telegram.';

  @override
  String get help_howToUse_04 =>
      'C\'est fait ! L’app est maintenant prête à transférer les SMS entrants vers votre bot. Appuyez sur Démarrer pour activer le transfert des SMS ou sur Arrêter pour le désactiver.';

  @override
  String get help_howToUse_04l =>
      'Lors du transfert de SMS depuis plusieurs appareils, vous pouvez définir un libellé d\'appareil dans les paramètres pour identifier le téléphone récepteur.';

  @override
  String get help_howToUse_05 =>
      'Il est recommandé de désactiver l’optimisation de la batterie pour l’app, car le système peut limiter l’activité des applications en arrière-plan pour économiser l’énergie.';

  @override
  String get help_howToUse_06 =>
      'Assurez-vous de garder la connexion internet activée pour que l\'app fonctionne.';

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
}
