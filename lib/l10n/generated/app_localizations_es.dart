// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get sms => 'SMS';

  @override
  String get sms_welcome => 'Toca Iniciar para\nempezar a reenviar SMS';

  @override
  String get sms_empty => 'No hay SMS entrantes\nen la sesión actual';

  @override
  String get sms_hello => '¡Hola desde SMS Telebot! =^•⩊•^=';

  @override
  String get sms_from => 'SMS de';

  @override
  String get sms_received => 'Recibido';

  @override
  String get sms_sent => 'Reenviado';

  @override
  String get sms_start => 'Iniciar';

  @override
  String get sms_stop => 'Detener';

  @override
  String get filters => 'FILTROS';

  @override
  String get filters_off => 'Desactivado';

  @override
  String get filters_whitelist => 'Lista blanca';

  @override
  String get filters_blacklist => 'Lista negra';

  @override
  String get filters_sender => 'Remitente';

  @override
  String get filters_senderInfo => 'Añade filtros para números o nombres';

  @override
  String get filters_text => 'Mensaje';

  @override
  String get filters_textInfo => 'Añade filtros para el texto del SMS';

  @override
  String get filters_test => 'Probar';

  @override
  String get filters_save => 'Guardar';

  @override
  String get settings => 'CONFIGURACIÓN';

  @override
  String get settings_token => 'Token del bot';

  @override
  String get settings_tokenInfo => 'Token obtenido de @BotFather';

  @override
  String get settings_chatId => 'ID del chat';

  @override
  String get settings_chatIdInfo => 'ID del chat con tu bot (opcional)';

  @override
  String get settings_deviceLabel => 'Etiqueta del dispositivo';

  @override
  String get settings_deviceLabelInfo => 'Etiqueta personalizada (opcional)';

  @override
  String get settings_test => 'Probar y guardar';

  @override
  String get help_about => 'Acerca de';

  @override
  String get help_appInfo =>
      'App para reenviar automáticamente mensajes SMS entrantes a un bot de Telegram';

  @override
  String get help_howToUse => 'Cómo usar';

  @override
  String get help_howToUse_01 =>
      'Si aún no tienes un bot de Telegram, usa @BotFather para crear uno y obtener su token. Es simple y gratuito.';

  @override
  String get help_howToUse_02 =>
      'Abre un chat con tu bot en Telegram, inicia una conversación o envía cualquier mensaje. Esto es necesario para obtener automáticamente el ID del chat.';

  @override
  String get help_howToUse_03 =>
      'Abre la app, en configuración del bot, introduce el token y prueba los ajustes (también puedes establecer el ID del chat si lo conoces). Si la prueba es exitosa, la configuración se guarda y se envía un mensaje de bienvenida al chat de Telegram.';

  @override
  String get help_howToUse_04 =>
      '¡Listo! La app ya está lista para reenviar los SMS entrantes a tu bot. Toca Iniciar para activar el reenvío de SMS o Detener para desactivarlo.';

  @override
  String get help_howToUse_04l =>
      'Al reenviar SMS desde varios dispositivos, puedes configurar una etiqueta de dispositivo en ajustes para identificar el teléfono receptor.';

  @override
  String get help_howToUse_05 =>
      'Se recomienda desactivar la optimización de batería para la app, ya que el sistema puede limitar la actividad de las aplicaciones en segundo plano para ahorrar energía.';

  @override
  String get help_howToUse_06 =>
      'Asegúrate de mantener la conexión a internet habilitada para que la app funcione.';

  @override
  String get help_filters => 'Filtros';

  @override
  String get help_filters_01 =>
      'Puedes establecer filtros para el remitente o texto de los mensajes SMS entrantes. Un filtro se activa si el número/nombre del remitente o el texto contiene los caracteres especificados.';

  @override
  String get help_filters_02 =>
      'Hay dos modos: lista blanca (el SMS se reenvía si al menos un filtro coincide) y lista negra (el SMS no se reenvía si algún filtro coincide). En modo lista blanca, si no hay filtros configurados, ningún SMS se reenviará al bot.';

  @override
  String get help_filters_03 =>
      'Usa dos barras para regex. Por ejemplo, el filtro /^\\d*555\$/ coincide con todos los números que terminan en 555';

  @override
  String get help_filters_04 =>
      'Para verificar si un SMS específico se reenviará según los filtros actuales, introduce el remitente y/o mensaje requerido en los campos y haz clic en el botón para verificar.';
}
