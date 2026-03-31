// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get action_cancel => 'Отмена';

  @override
  String get action_delete => 'Удалить';

  @override
  String get action_duplicate => 'Дублировать';

  @override
  String get action_save => 'Сохранить';

  @override
  String get action_test => 'Проверить';

  @override
  String get action_testAndSave => 'Проверить и сохранить';

  @override
  String get sms => 'СМС';

  @override
  String get sms_welcome => 'Нажмите Старт, чтобы\nначать пересылку СМС';

  @override
  String get sms_empty => 'Нет входящих СМС\nв текущей сессии';

  @override
  String get sms_hello => 'Привет от SMS Telebot! =^•⩊•^=';

  @override
  String get sms_from => 'СМС от';

  @override
  String get sms_received => 'Получено';

  @override
  String get sms_sent => 'Переслано';

  @override
  String get sms_start => 'Старт';

  @override
  String get sms_stop => 'Стоп';

  @override
  String get rule => 'Правило';

  @override
  String get rule_add => 'Добавить правило пересылки';

  @override
  String get rule_copySuffix => 'копия';

  @override
  String get rule_deleteHeader => 'Удалить правило?';

  @override
  String get rule_deleteText => 'Это действие нельзя отменить.';

  @override
  String get rules => 'ПРАВИЛА';

  @override
  String get rules_empty => 'Пока нет правил\nСоздайте первое!';

  @override
  String get connection => 'Подключение';

  @override
  String get telebot => 'Telegram-бот';

  @override
  String get telebot_token => 'Токен';

  @override
  String get telebot_tokenInfo => 'Токен бота, полученный от @BotFather';

  @override
  String get telebot_chatId => 'ID чата';

  @override
  String get telebot_chatIdInfo => 'ID чата с ботом (опционально)';

  @override
  String get smtp => 'SMTP-сервер';

  @override
  String get smtp_host => 'SMTP-хост';

  @override
  String get smtp_protocol => 'Протокол';

  @override
  String get smtp_protocolEmpty => 'Нет';

  @override
  String get smtp_port => 'Порт';

  @override
  String get smtp_login => 'Логин';

  @override
  String get smtp_loginInfo => 'Обычно полный email-адрес';

  @override
  String get smtp_password => 'Пароль';

  @override
  String get smtp_passwordInfo => 'Обычно пароль для внешних приложений';

  @override
  String get smtp_fromEmail => 'Email отправителя';

  @override
  String get smtp_fromEmailInfo => 'Опционально: логин, если пусто';

  @override
  String get smtp_toEmail => 'Email получателя';

  @override
  String get smtp_toEmailInfo => 'Email-адрес получателя';

  @override
  String get smtp_subject => 'Тема';

  @override
  String get smtp_subjectInfo => 'Тема письма (опционально)';

  @override
  String get filters => 'Фильтры';

  @override
  String get filters_off => 'Без\nфильтров';

  @override
  String get filters_whitelist => 'Белый\nсписок';

  @override
  String get filters_blacklist => 'Чёрный\nсписок';

  @override
  String get filters_sender => 'Отправитель';

  @override
  String get filters_senderInfo => 'Добавьте фильтры для номеров/имён';

  @override
  String get filters_text => 'Сообщение';

  @override
  String get filters_textInfo => 'Добавьте фильтры для текста СМС';

  @override
  String get settings => 'НАСТРОЙКИ';

  @override
  String get settings_deviceLabel => 'Метка устройства';

  @override
  String get settings_deviceLabelInfo => 'Пользовательская метка (опционально)';

  @override
  String get help_about => 'О приложении';

  @override
  String get help_appInfo =>
      'Приложение для автоматической пересылки входящих СМС-сообщений Telegram-боту';

  @override
  String get help_howToUse => 'Как использовать';

  @override
  String get help_howToUse_01 =>
      'Если у вас пока нет Telegram-бота, создайте его с помощью бота @BotFather и получите токен. Это просто и бесплатно.';

  @override
  String get help_howToUse_02 =>
      'Откройте чат с вашим ботом в Telegram, нажмите /start или отправьте любое сообщение. Это нужно для автоматического получения ID чата на следующем шаге.';

  @override
  String get help_howToUse_03 =>
      'Перейдите в приложение, в настройках бота введите токен и проверьте настройки, нажав кнопку (также можно задать ID чата, если знаете его). В случае успешной проверки, настройки сохраняются, и в Telegram-чат придёт приветственное сообщение.';

  @override
  String get help_howToUse_04 =>
      'Готово! Теперь всё настроено, чтобы пересылать входящие СМС вашему боту. Нажмите Старт, чтобы включить пересылку СМС, или Стоп, чтобы отключить.';

  @override
  String get help_howToUse_04l =>
      'При пересылке СМС с нескольких телефонов можно задать метку устройства в настройках — она отправляется боту вместе с СМС для идентификации телефона-получателя.';

  @override
  String get help_howToUse_05 =>
      'Рекомендуется отключить для приложения оптимизацию батареи, поскольку система может ограничивать работу приложений в фоне для экономии заряда.';

  @override
  String get help_howToUse_06 =>
      'Устройство с работающим приложением должно оставаться подключенным к интернету.';

  @override
  String get help_filters => 'Фильтры';

  @override
  String get help_filters_01 =>
      'Можно дополнительно установить фильтры для отправителя или текста входящих СМС. Фильтр срабатывает, если номер/имя отправителя или текст содержат заданные символы.';

  @override
  String get help_filters_02 =>
      'Есть два режима: белый список (СМС пересылается, если срабатывает хотя бы один фильтр) и чёрный список (соответственно, не пересылается). В режиме белого списка, если не задано ни одного фильтра, то боту никакие СМС отправляться не будут.';

  @override
  String get help_filters_03 =>
      'Используйте два символа /, чтобы задать регулярное выражение в качестве фильтра. Например, фильтр /^\\d*555\$/ соответствует номерам, которые оканчиваются на 555.';

  @override
  String get help_filters_04 =>
      'Чтобы проверить, будет ли переслано определённое СМС с учётом установленных фильтров, введите нужного отправителя и/или сообщение в поля ввода и нажмите кнопку для проверки.';

  @override
  String get error_badRequest =>
      'Ошибка при обработке запроса. Проверьте параметры подключения.';

  @override
  String get error_invalidParams =>
      'Проверьте параметры подключения. Данные отсутствуют или некорректны.';

  @override
  String get error_networkError =>
      'Проверьте подключение к интернету и попробуйте снова.';

  @override
  String get error_networkTimeout =>
      'Превышено время ожидания. Проверьте интернет и попробуйте снова.';

  @override
  String get error_rateLimited =>
      'Слишком много запросов. Пожалуйста, подождите немного и повторите попытку.';

  @override
  String get error_serverError =>
      'Сервер временно недоступен. Пожалуйста, попробуйте позже.';

  @override
  String get error_smtpError =>
      'Почтовый сервер вернул ошибку. Проверьте параметры подключения.';

  @override
  String get error_smtpRecipientsRejected =>
      'Почтовый сервер отклонил получателя. Проверьте адрес почты.';

  @override
  String get error_smtp_forbidden =>
      'Действие запрещено почтовым сервером. Проверьте права доступа.';

  @override
  String get error_smtp_unauthorized =>
      'Ошибка авторизации SMTP. Проверьте логин и пароль.';

  @override
  String get error_tbot_conflict =>
      'Не удалось получить ID чата при активном webhook. Удалите его или введите ID вручную.';

  @override
  String get error_tbot_forbidden =>
      'Telegram отклонил действие. Убедитесь, что у бота есть доступ к чату.';

  @override
  String get error_tbot_unauthorized =>
      'Неверный токен бота. Проверьте его и попробуйте снова.';

  @override
  String get error_tbot_uninitialized =>
      'Не удалось получить ID чата. Начните диалог с ботом и попробуйте снова.';

  @override
  String get error_unexpectedError =>
      'Произошла непредвиденная ошибка. Пожалуйста, попробуйте позже.';
}
