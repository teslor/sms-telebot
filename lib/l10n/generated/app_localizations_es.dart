// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get action_cancel => 'Cancelar';

  @override
  String get action_delete => 'Eliminar';

  @override
  String get action_duplicate => 'Duplicar';

  @override
  String get action_save => 'Guardar';

  @override
  String get action_test => 'Probar';

  @override
  String get sms => 'SMS';

  @override
  String get sms_welcome => 'Toca Iniciar para\nempezar a reenviar SMS';

  @override
  String get sms_empty => 'No hay SMS entrantes\nen las últimas 24 horas';

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
  String get rule => 'Regla';

  @override
  String get rule_add => 'Añadir regla de reenvío';

  @override
  String get rule_copySuffix => 'copia';

  @override
  String get rule_deleteHeader => '¿Eliminar regla?';

  @override
  String get rule_deleteText => 'Esta acción no se puede deshacer.';

  @override
  String get rule_noParams => 'Configura esta regla antes de activarla.';

  @override
  String get rules => 'REGLAS';

  @override
  String get rules_empty => 'Aún no hay reglas.\n¡Añade la primera!';

  @override
  String get connection => 'Conexión';

  @override
  String get tbot => 'Bot de Telegram';

  @override
  String get tbot_token => 'Token del bot';

  @override
  String get tbot_tokenInfo => 'Token obtenido de @BotFather';

  @override
  String get tbot_chatId => 'ID del chat';

  @override
  String get tbot_chatIdInfo => 'ID del chat con tu bot (opcional)';

  @override
  String get smtp => 'Servidor SMTP';

  @override
  String get smtp_host => 'Host SMTP';

  @override
  String get smtp_protocol => 'Protocolo';

  @override
  String get smtp_protocolEmpty => 'Ninguno';

  @override
  String get smtp_port => 'Puerto';

  @override
  String get smtp_login => 'Usuario';

  @override
  String get smtp_loginInfo => 'Normalmente la dirección de correo completa';

  @override
  String get smtp_password => 'Contraseña';

  @override
  String get smtp_passwordInfo =>
      'Normalmente la contraseña para apps externas';

  @override
  String get smtp_fromEmail => 'Correo del remitente';

  @override
  String get smtp_fromEmailInfo => 'Opcional: usuario si está vacío';

  @override
  String get smtp_toEmail => 'Correo del destinatario';

  @override
  String get smtp_toEmailInfo => 'Dirección de correo del destinatario';

  @override
  String get smtp_subject => 'Asunto';

  @override
  String get smtp_subjectInfo => 'Asunto del correo (opcional)';

  @override
  String get filters => 'Filtros';

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
  String get settings => 'CONFIGURACIÓN';

  @override
  String get settings_deviceLabel => 'Etiqueta del dispositivo';

  @override
  String get settings_deviceLabelInfo => 'Etiqueta personalizada (opcional)';

  @override
  String get help_about => 'Acerca de';

  @override
  String get help_appInfo =>
      'App para reenviar automáticamente mensajes SMS entrantes a un bot de Telegram';

  @override
  String get help_info => 'Introducción';

  @override
  String get help_info_01 =>
      'La aplicación reenvía SMS a un bot de Telegram o a un correo electrónico. Necesitará su propio bot o una cuenta con acceso SMTP.';

  @override
  String get help_info_02 =>
      'Para cada conexión se crea una regla de reenvío, que define qué SMS enviar y a dónde. Las reglas se pueden duplicar, activar y desactivar según sea necesario.';

  @override
  String get help_info_03 =>
      'Cuando llega un SMS, la aplicación revisa las reglas activas e intenta reenviarlo. Si falla por motivos técnicos (por ejemplo, falta de internet), la aplicación lo reintentará más tarde.';

  @override
  String get help_info_04 =>
      'Al reenviar SMS desde varios teléfonos, puede configurar una etiqueta de dispositivo en los ajustes; esta se envía junto con el SMS para identificar el teléfono emisor.';

  @override
  String get help_info_05 =>
      'Se recomienda desactivar la optimización de batería para la app, ya que el sistema puede limitar la actividad de las aplicaciones en segundo plano para ahorrar energía.';

  @override
  String get help_info_06 =>
      'Asegúrate de mantener la conexión a internet habilitada para que la app funcione.';

  @override
  String get help_tbot => 'Conexión de Bot de Telegram';

  @override
  String get help_tbot_01 =>
      'Si aún no tienes un bot de Telegram, usa @BotFather para crear uno y obtener su token. Es simple y gratuito.';

  @override
  String get help_tbot_02 =>
      'Abre un chat con tu bot en Telegram, inicia una conversación o envía cualquier mensaje. Esto es necesario para obtener automáticamente el ID del chat.';

  @override
  String get help_tbot_03 =>
      'Vaya a la app, cree una regla para el bot de Telegram e introduzca el token (también puede indicar el ID del chat si lo conoce). Pruebe la configuración y guarde. Si es correcta, recibirá un mensaje de bienvenida.';

  @override
  String get help_tbot_04 =>
      '¡Listo! Todo está configurado para reenviar SMS a su bot. Active la regla y pulse Iniciar para comenzar.';

  @override
  String get help_smtp => 'Conexión de servidor SMTP';

  @override
  String get help_smtp_01 =>
      'Para el reenvío de SMS, es mejor crear un correo electrónico independiente (no un alias): este servirá como nombre de usuario. Especialmente importante para Gmail y servicios similares.';

  @override
  String get help_smtp_02 =>
      'Cree una regla y complete los parámetros de conexión. Generalmente se requiere una \'contraseña de aplicación\' (generada en los ajustes de seguridad del correo).';

  @override
  String get help_smtp_03 =>
      'Pruebe y guarde la configuración, active la regla y pulse Iniciar.';

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

  @override
  String get error_badRequest =>
      'La solicitud fue rechazada. Verifique los parámetros de conexión ingresados.';

  @override
  String get error_invalidParams =>
      'Parámetros de conexión inválidos. Corríjalos e inténtelo de nuevo.';

  @override
  String get error_networkError =>
      'Verifique su conexión a internet e inténtelo de nuevo.';

  @override
  String get error_networkTimeout =>
      'Se superó el tiempo de espera. Verifique su conexión a internet y confirme que los parámetros de conexión sean correctos.';

  @override
  String get error_rateLimited =>
      'Demasiadas solicitudes. Espere un momento e inténtelo de nuevo.';

  @override
  String get error_serverError =>
      'El servidor no está disponible. Inténtelo más tarde.';

  @override
  String get error_smtpAddressRejected =>
      'El servidor rechazó el correo del remitente o del destinatario. Verifique las direcciones.';

  @override
  String get error_smtpError =>
      'El servidor devolvió un error. Verifique los parámetros de conexión ingresados.';

  @override
  String get error_smtp_forbidden =>
      'La acción fue rechazada por el servidor. Verifique los permisos de acceso.';

  @override
  String get error_smtp_unauthorized =>
      'Error de autorización. Verifique el usuario y la contraseña.';

  @override
  String get error_tbot_conflict =>
      'No se pudo obtener el ID del chat. Elimine el webhook activo o ingrese el ID manualmente.';

  @override
  String get error_tbot_forbidden =>
      'Telegram denegó la acción. Asegúrese de que el bot tiene acceso al chat.';

  @override
  String get error_tbot_unauthorized =>
      'Error de autorización. Ingrese un token válido e inténtelo de nuevo.';

  @override
  String get error_tbot_uninitialized =>
      'No se pudo obtener el ID del chat. Inicie un diálogo con su bot en Telegram e inténtelo de nuevo.';

  @override
  String get error_unexpectedError =>
      'Ocurrió un error inesperado. Inténtelo más tarde.';

  @override
  String get error_secretsError =>
      'No se pudo acceder al almacenamiento seguro. Inténtelo de nuevo. Si el error persiste, reinicie la aplicación y verifique las contraseñas/tokens en las reglas de reenvío.';

  @override
  String get warn_secretsRecovered =>
      'El almacenamiento seguro se recuperó tras un fallo; es posible que se hayan eliminado las contraseñas/tokens guardados. Revise las reglas de reenvío y vuelva a introducir los datos.';
}
