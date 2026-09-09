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
  String get action_close => 'Cerrar';

  @override
  String get action_continue => 'Continuar';

  @override
  String get action_delete => 'Eliminar';

  @override
  String get action_duplicate => 'Duplicar';

  @override
  String get action_exit => 'Salir';

  @override
  String get action_save => 'Guardar';

  @override
  String get action_test => 'Probar';

  @override
  String get service_title => 'SMS Telebot está activo';

  @override
  String get service_text => 'Monitoreando eventos';

  @override
  String get msg_list => 'Mensajes';

  @override
  String get msg_welcome => 'Toca Iniciar\npara habilitar el monitoreo';

  @override
  String get msg_empty => 'No hay mensajes\nen las últimas 24 horas';

  @override
  String get msg_hello => '¡Hola! ^._.^';

  @override
  String get msg_received => 'Recibido';

  @override
  String get msg_sent => 'Reenviado';

  @override
  String get msg_start => 'Iniciar';

  @override
  String get msg_stop => 'Detener';

  @override
  String get msg_sms => 'SMS';

  @override
  String get msg_call => 'Llamada';

  @override
  String get msg_battery => 'Batería';

  @override
  String get msg_lowBattery => 'Batería baja';

  @override
  String get msg_chargerConnected => 'Cargador conectado';

  @override
  String get msg_chargerDisconnected => 'Cargador desconectado';

  @override
  String get rule => 'Regla';

  @override
  String get rule_add => 'Añadir regla';

  @override
  String get rule_copySuffix => 'copia';

  @override
  String get rule_deleteHeader => '¿Eliminar regla?';

  @override
  String get rule_deleteText => 'Esta acción no se puede deshacer.';

  @override
  String get rule_noParams => 'Configura esta regla antes de activarla.';

  @override
  String get rules => 'Reglas';

  @override
  String get rules_empty => 'Aún no hay reglas.\n¡Añade la primera!';

  @override
  String get rules_setup => 'Configuración de la regla';

  @override
  String get config => 'Parámetros';

  @override
  String get connection => 'Conexión';

  @override
  String get tbot_token => 'Token del bot';

  @override
  String get tbot_chatId => 'ID del chat';

  @override
  String get tbot_chatIdInfo => 'Predeterminado: detección automática';

  @override
  String get tbot_server => 'URL del servidor';

  @override
  String tbot_serverInfo(Object url) {
    return 'Predeterminado: $url';
  }

  @override
  String get ntfy_topic => 'Tema';

  @override
  String get ntfy_priority => 'Prioridad';

  @override
  String get ntfy_priority_01 => 'Mínimo';

  @override
  String get ntfy_priority_02 => 'Bajo';

  @override
  String get ntfy_priority_03 => 'Predeterminado';

  @override
  String get ntfy_priority_04 => 'Alto';

  @override
  String get ntfy_priority_05 => 'Máximo';

  @override
  String get ntfy_token => 'Token de acceso';

  @override
  String get ntfy_tokenInfo => 'Token Bearer; predeterminado: sin token';

  @override
  String get ntfy_server => 'URL del servidor';

  @override
  String ntfy_serverInfo(Object url) {
    return 'Predeterminado: $url';
  }

  @override
  String get smtp_host => 'Host SMTP';

  @override
  String get smtp_protocol => 'Protocolo';

  @override
  String get smtp_protocolEmpty => 'Ninguno';

  @override
  String get smtp_port => 'Puerto';

  @override
  String get smtp_insecureTls => 'Validación de certificado relajada';

  @override
  String get smtp_insecureTlsInfo =>
      'Actívelo solo si tiene errores de conexión (especialmente en dispositivos antiguos). Esto reduce la seguridad de la conexión.';

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
  String get smtp_fromEmailInfo => 'Predeterminado: usuario';

  @override
  String get smtp_toEmail => 'Correo del destinatario';

  @override
  String get smtp_toEmailInfo => 'Predeterminado: usuario';

  @override
  String get smtp_subject => 'Asunto';

  @override
  String get smtp_subjectInfo => 'Predeterminado: auto';

  @override
  String get sms_receiver => 'Destinatario';

  @override
  String get sms_number => 'Número de teléfono';

  @override
  String get sms_numberInfo => 'Ejemplo: +12345678900';

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
  String get filters_textInfo => 'Añade filtros de texto';

  @override
  String get options => 'Opciones';

  @override
  String get options_priority => 'Prioridad de la regla';

  @override
  String get options_priorityInfo =>
      'Regla se ignora si se activa una regla con mayor prioridad';

  @override
  String get options_priority_01 => 'Máxima';

  @override
  String get options_priority_02 => 'Alta';

  @override
  String get options_priority_03 => 'Media';

  @override
  String get options_priority_04 => 'Baja';

  @override
  String get options_priority_05 => 'Mínima';

  @override
  String get settings => 'Configuración';

  @override
  String get settings_forwardEvents => 'Eventos a reenviar';

  @override
  String get settings_forwardSms => 'SMS entrantes';

  @override
  String get settings_forwardCalls => 'Llamadas entrantes';

  @override
  String get settings_notifyLowBattery => 'Batería baja';

  @override
  String get settings_notifyChargerState => 'Estado del cargador';

  @override
  String get settings_enableForeground => 'Ejecutar siempre en segundo plano';

  @override
  String get settings_attachSimInfo => 'Adjuntar datos SIM';

  @override
  String get settings_format => 'Formato del mensaje';

  @override
  String get settings_formatDefault => 'Predeterminado';

  @override
  String get settings_formatPaste => 'Pegar';

  @override
  String get settings_formatPreview => 'Previsualizar';

  @override
  String get settings_formatReset => 'Restablecer';

  @override
  String get settings_formatError => 'Formato de plantilla no válido.';

  @override
  String get settings_deviceLabel => 'Etiqueta del dispositivo';

  @override
  String get settings_deviceLabelInfo => 'Predeterminado: sin etiqueta';

  @override
  String get help_about => 'Acerca de';

  @override
  String get help_appInfo =>
      'Reenvío inteligente de SMS y notificaciones sobre llamadas entrantes y estado de batería.';

  @override
  String get help_info => 'Introducción';

  @override
  String get help_info_01 =>
      'Reenvía mensajes a Telegram, ntfy, correo o por SMS. ¡Configura varios destinos fácilmente!';

  @override
  String get help_info_02 =>
      'Usa reglas para definir qué reenviar y a dónde. Puedes duplicarlas o desactivarlas cuando lo necesites.';

  @override
  String get help_info_03 =>
      'Los mensajes se reenvían según las reglas activas. Si ocurre un error de conexión (por ejemplo, sin internet), los reintentos se realizan automáticamente.';

  @override
  String get help_opts_01 =>
      'Primero, selecciona los eventos que quieres reenviar. Mientras la app está activa, se genera y envía un mensaje por cada evento según las reglas configuradas.';

  @override
  String get help_opts_02 =>
      'El modo permanente en segundo plano mejora la fiabilidad del envío (especialmente para notificaciones del sistema), pero aumenta bastante el consumo de batería. En este modo aparece una notificación persistente. No se recomienda activarlo salvo que sea necesario.';

  @override
  String get help_opts_03 =>
      'Activa el interruptor para añadir los datos de la SIM (ranura y operador) al reenviar SMS y llamadas entrantes. Los datos de la SIM no están disponibles en algunos sistemas, especialmente para las llamadas.';

  @override
  String get help_opts_04 =>
      'Si desea cambiar el formato de los mensajes, descargue el archivo de plantilla, realice sus cambios y pegue el texto de la plantilla en los ajustes.';

  @override
  String get help_opts_04h => 'Descargar plantilla';

  @override
  String get help_opts_05 =>
      'Si usas la app en varios teléfonos, puedes establecer una etiqueta de dispositivo. Se enviará junto con el mensaje para identificar el teléfono receptor.';

  @override
  String get help_opts_06 =>
      'Se recomienda desactivar la optimización de batería para esta app, ya que el sistema puede limitar la actividad en segundo plano para ahorrar energía.';

  @override
  String get help_rule_01 =>
      'Prueba y guarda la configuración (si la prueba es correcta, se enviará un mensaje de bienvenida). Luego activa la regla en la lista y pulsa Iniciar para empezar a reenviar.';

  @override
  String get help_tbot_01 =>
      '¿No tienes un bot? Usa @BotFather de Telegram para crear uno y obtener un token de API.';

  @override
  String get help_tbot_02 =>
      'Abre un chat con tu bot en la app de Telegram y envía cualquier mensaje. Así se podrá detectar automáticamente el ID del chat.';

  @override
  String get help_tbot_03 =>
      'Añade una regla de Telegram y pega tu token. Si quieres, también puedes indicar el ID del chat manualmente.';

  @override
  String get help_tbot_04 =>
      'También puedes indicar la URL de un servidor API personalizado para usarlo en lugar del servidor oficial de Telegram.';

  @override
  String help_ntfy_01(Object url) {
    return 'En la app ntfy o en la versión web ($url), suscríbete a un tema nuevo con un nombre difícil de adivinar.';
  }

  @override
  String get help_ntfy_02 =>
      'Crea una regla, introduce el nombre del tema y, si quieres, elige la prioridad de la notificación.';

  @override
  String get help_ntfy_03 =>
      'Los temas públicos son accesibles para cualquiera que conozca su nombre. Para más seguridad, usa autenticación y un token de acceso.';

  @override
  String get help_ntfy_04 =>
      'Por defecto se usa el servidor oficial ntfy.sh, pero puedes indicar un servidor personalizado.';

  @override
  String get help_smtp_01 =>
      'Se recomienda crear una cuenta de correo separada (no un alias) específicamente para el reenvío de mensajes y usarla como usuario. Es especialmente importante para Gmail y servicios similares.';

  @override
  String get help_smtp_02 =>
      'Cree una regla y complete los parámetros de conexión. Generalmente se requiere una \'contraseña de aplicación\' (generada en los ajustes de seguridad del correo).';

  @override
  String get help_sms_01 =>
      'La app permite reenviar mensajes como SMS salientes.';

  @override
  String get help_sms_02 =>
      'Crea una regla e introduce el número de teléfono del destinatario. El número móvil debe comenzar con el símbolo + (formato internacional).';

  @override
  String get help_sms_03 =>
      'Los SMS se envían con la tarjeta SIM seleccionada por defecto en la configuración del teléfono.';

  @override
  String get help_filters => 'Filtros';

  @override
  String get help_filters_01 =>
      'Para cualquier regla, puedes configurar filtros por remitente y por texto del mensaje. Un filtro coincide si el número/nombre del remitente o el texto contiene los caracteres indicados.';

  @override
  String get help_filters_02 =>
      'Hay dos modos: lista blanca (el mensaje se reenvía si coincide al menos un filtro) y lista negra (el mensaje no se reenvía si coincide cualquier filtro). En lista blanca, si no hay filtros, no se reenviará ningún mensaje.';

  @override
  String get help_filters_03 =>
      'Usa dos caracteres / para definir una expresión regular como filtro. Por ejemplo, el filtro /^\\d*555\$/ coincide con los números que terminan en 555.';

  @override
  String get help_filters_04 =>
      'Para comprobar si un mensaje concreto se reenviará con los filtros actuales, introduce el remitente y/o el texto en los campos y pulsa el botón de verificación.';

  @override
  String get help_filters_05 =>
      'Los filtros configurados se aplican a todos los tipos de eventos, no solo a los SMS entrantes.';

  @override
  String get help_options_01 =>
      'La prioridad de la regla determina el orden de procesamiento. Si una regla se activa (mensaje enviado), las reglas de menor prioridad se omiten. Las reglas con la misma prioridad se activan simultáneamente.';

  @override
  String get consent_welcome =>
      '¡Bienvenido!\nAl continuar, confirmas que has leído esta información:';

  @override
  String get consent_item_01 =>
      'Según las funciones que actives, la aplicación puede recibir datos sobre SMS y llamadas entrantes, y enviar SMS a los números que indiques.';

  @override
  String get consent_item_02 =>
      'Los datos solo se envían a los servicios que tú mismo configures. No hay servidores ocultos ni analítica.';

  @override
  String get consent_item_03 =>
      'Los permisos sensibles solo se solicitan al activar las funciones correspondientes.';

  @override
  String get consent_details => 'Más información: ';

  @override
  String get consent_privacyPolicy => 'política de privacidad';

  @override
  String get error_badRequest =>
      'El servidor rechazó la solicitud. Verifique los parámetros de conexión.';

  @override
  String get error_forbidden =>
      'Error de autorización. Verifique los permisos de acceso.';

  @override
  String get error_invalidParams => 'Parámetros de conexión no válidos.';

  @override
  String get error_networkError =>
      'Error de conexión. Verifique su conexión a internet o la configuración de red.';

  @override
  String get error_networkTimeout =>
      'Se agotó el tiempo de espera. Verifique la red o los parámetros de conexión.';

  @override
  String get error_rateLimited =>
      'Se superó el límite de solicitudes. Inténtelo más tarde.';

  @override
  String get error_serverError => 'Error del servidor. Inténtelo más tarde.';

  @override
  String get error_smtpAddressRejected =>
      'El servidor rechazó el correo del remitente o del destinatario. Verifique las direcciones.';

  @override
  String get error_smtpError =>
      'El servidor devolvió un error. Verifique los parámetros de conexión.';

  @override
  String get error_smtp_unauthorized =>
      'Error de acceso. Verifique el usuario y la contraseña.';

  @override
  String get error_tbot_conflict =>
      'No se pudo obtener el ID del chat. Elimine el webhook activo o ingrese el ID manualmente.';

  @override
  String get error_tbot_forbidden =>
      'Error de autorización. Asegúrese de que el bot tiene acceso al chat.';

  @override
  String get error_tbot_unauthorized => 'Error de acceso. Verifique el token.';

  @override
  String get error_tbot_uninitialized =>
      'No se pudo obtener el ID del chat. Inicie un diálogo con su bot en Telegram e inténtelo de nuevo.';

  @override
  String get error_unauthorized =>
      'Error de acceso. Verifique las credenciales.';

  @override
  String get error_unexpectedError => 'No se pudo realizar la acción.';

  @override
  String get error_secretsError =>
      'No se pudo acceder al almacenamiento seguro. Inténtelo de nuevo. Si el error persiste, reinicie la aplicación y verifique las contraseñas/tokens en las reglas de reenvío.';

  @override
  String get warn_secretsRecovered =>
      'El almacenamiento seguro se recuperó tras un fallo; es posible que se hayan eliminado las contraseñas/tokens guardados. Revise las reglas de reenvío y vuelva a introducir los datos.';

  @override
  String get warn_permissionsRequired =>
      'Para iniciar la supervisión, conceda los permisos necesarios.';
}
