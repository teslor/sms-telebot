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
  String get msg_list => 'Сообщения';

  @override
  String get msg_welcome => 'Нажмите Старт, чтобы\nвключить мониторинг';

  @override
  String get msg_empty => 'Нет сообщений\nза последние 24 часа';

  @override
  String get msg_hello => 'Привет! =^•⩊•^=';

  @override
  String get msg_received => 'Получено';

  @override
  String get msg_sent => 'Переслано';

  @override
  String get msg_start => 'Старт';

  @override
  String get msg_stop => 'Стоп';

  @override
  String get msg_sms => 'СМС';

  @override
  String get msg_call => 'Звонок';

  @override
  String get msg_lowBattery => 'Низкий уровень заряда';

  @override
  String get msg_chargerConnected => 'Зарядка подключена';

  @override
  String get msg_chargerDisconnected => 'Зарядка отключена';

  @override
  String get rule => 'Правило';

  @override
  String get rule_add => 'Добавить правило';

  @override
  String get rule_copySuffix => 'копия';

  @override
  String get rule_deleteHeader => 'Удалить правило?';

  @override
  String get rule_deleteText => 'Это действие нельзя отменить.';

  @override
  String get rule_noParams =>
      'Чтобы активировать правило, нужно сначала задать параметры подключения.';

  @override
  String get rules => 'Правила';

  @override
  String get rules_empty => 'Правил пока нет.\nДобавьте первое!';

  @override
  String get connection => 'Подключение';

  @override
  String get tbot => 'Telegram-бот';

  @override
  String get tbot_token => 'Токен';

  @override
  String get tbot_tokenInfo => 'Токен бота, полученный от @BotFather';

  @override
  String get tbot_chatId => 'ID чата';

  @override
  String get tbot_chatIdInfo => 'ID чата с ботом (опционально)';

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
  String get filters_textInfo => 'Добавьте текстовые фильтры';

  @override
  String get settings => 'Настройки';

  @override
  String get settings_forwardEvents => 'События для пересылки';

  @override
  String get settings_forwardSms => 'Входящие СМС';

  @override
  String get settings_forwardCalls => 'Входящие звонки';

  @override
  String get settings_notifyLowBattery => 'Низкий заряд батареи';

  @override
  String get settings_notifyChargerState => 'Подключение зарядки';

  @override
  String get settings_enableForeground => 'Постоянная работа в фоне';

  @override
  String get settings_deviceLabel => 'Метка устройства';

  @override
  String get settings_deviceLabelInfo => 'Пользовательская метка (опционально)';

  @override
  String get help_about => 'О приложении';

  @override
  String get help_appInfo =>
      'Приложение для автоматической пересылки входящих СМС.\nДополнительно: уведомления о входящих звонках и статусе батареи.';

  @override
  String get help_info => 'Введение';

  @override
  String get help_info_01 =>
      'С помощью приложения можно пересылать сообщения Telegram-боту или на email-ящик с SMTP-доступом. Можно добавить несколько ботов или email-адресов!';

  @override
  String get help_info_02 =>
      'Для каждого подключения создаётся правило пересылки — оно определяет, какие сообщения и куда отправлять. Правила можно дублировать, включать и выключать по мере необходимости.';

  @override
  String get help_info_03 =>
      'Приложение проверяет активные правила и пробует переслать новое сообщение. Если не получилось по технической причине (например, нет интернета) — планируются повторые попытки.';

  @override
  String get help_info_04 =>
      'Устройство с работающим приложением должно оставаться подключенным к интернету.';

  @override
  String get help_opts_01 =>
      'Для начала выберите нужные события для пересылки. В процессе работы приложения для каждого события формируется и отправляется сообщение с учётом заданных правил.';

  @override
  String get help_opts_02 =>
      'Режим постоянной работы в фоне повышает надёжность доставки сообщений (особенно системных уведомлений), но значительно увеличивает расход батареи. При этом режиме отображается постоянное уведомление в шторке. Не рекомендуется включать без необходимости.';

  @override
  String get help_opts_03 =>
      'При использовании приложения на нескольких телефонах можно задать метку устройства — она отправляется вместе с сообщением для идентификации телефона-получателя.';

  @override
  String get help_opts_04 =>
      'Важно отключить для приложения оптимизацию батареи, поскольку система может ограничивать работу в фоне для экономии заряда.';

  @override
  String get help_tbot => 'Подключение Telegram-бота';

  @override
  String get help_tbot_01 =>
      'Если у вас пока нет своего бота, создайте его с помощью бота @BotFather и получите токен. Это просто и бесплатно.';

  @override
  String get help_tbot_02 =>
      'Откройте чат с вашим ботом в Telegram, нажмите /start или отправьте любое сообщение. Это нужно для автоматического получения ID чата на следующем шаге.';

  @override
  String get help_tbot_03 =>
      'Перейдите в приложение, создайте правило для Telegram-бота и введите токен в параметрах подключения (также можно задать ID чата, если знаете его). Обязательно проверьте настройки, затем сохраните. В случае успешной проверки придёт приветственное сообщение.';

  @override
  String get help_tbot_04 =>
      'Готово! Теперь всё настроено, чтобы пересылать сообщения вашему боту. Включите правило и нажмите Старт, чтобы начать пересылку.';

  @override
  String get help_smtp => 'Подключение SMTP-сервера';

  @override
  String get help_smtp_01 =>
      'Для пересылки сообщений лучше завести отдельный email (не алиас): он же будет логином. Особенно актуально для Gmail и подобных сервисов.';

  @override
  String get help_smtp_02 =>
      'Создайте правило и заполните параметры подключения. Пароль чаще всего нужен для внешних приложений (генерируется в настройках безопасности почты).';

  @override
  String get help_smtp_03 =>
      'Проверьте и сохраните настройки, включите правило и нажмите Старт.';

  @override
  String get help_filters => 'Фильтры';

  @override
  String get help_filters_01 =>
      'Для каждого правила можно дополнительно установить фильтры для отправителя или текста сообщения. Фильтр срабатывает, если номер/имя отправителя или текст содержат заданные символы.';

  @override
  String get help_filters_02 =>
      'Есть два режима: белый список (сообщение пересылается, если срабатывает хотя бы один фильтр) и чёрный список (соответственно, не пересылается). В режиме белого списка, если не задано ни одного фильтра, то никакие сообщения пересылаться не будут.';

  @override
  String get help_filters_03 =>
      'Используйте два символа /, чтобы задать регулярное выражение в качестве фильтра. Например, фильтр /^\\d*555\$/ соответствует номерам, которые оканчиваются на 555.';

  @override
  String get help_filters_04 =>
      'Чтобы проверить, будет ли переслано сообщение с учётом установленных фильтров, введите нужного отправителя и/или текст сообщения в поля ввода и нажмите кнопку для проверки.';

  @override
  String get help_filters_05 =>
      'Заданные фильтры применяются для всех типов событий, не только для входящих СМС.';

  @override
  String get error_badRequest =>
      'Запрос отклонён. Проверьте введённые параметры подключения.';

  @override
  String get error_invalidParams =>
      'Некорректные параметры подключения. Исправьте и попробуйте снова.';

  @override
  String get error_networkError =>
      'Проверьте подключение к интернету и попробуйте снова.';

  @override
  String get error_networkTimeout =>
      'Превышено время ожидания. Проверьте интернет и убедитесь, что введены корректные параметры подключения.';

  @override
  String get error_rateLimited =>
      'Слишком много запросов. Пожалуйста, подождите немного и повторите попытку.';

  @override
  String get error_serverError =>
      'Сервер временно недоступен. Пожалуйста, попробуйте позже.';

  @override
  String get error_smtpAddressRejected =>
      'Сервер отклонил email отправителя или получателя. Проверьте адреса.';

  @override
  String get error_smtpError =>
      'Сервер вернул ошибку. Проверьте введённые параметры подключения.';

  @override
  String get error_smtp_forbidden =>
      'Действие отклонено сервером. Проверьте права доступа.';

  @override
  String get error_smtp_unauthorized =>
      'Ошибка авторизации. Проверьте логин и пароль.';

  @override
  String get error_tbot_conflict =>
      'Не удалось получить ID чата. Удалите активный webhook или введите ID вручную.';

  @override
  String get error_tbot_forbidden =>
      'Telegram отклонил действие. Убедитесь, что у бота есть доступ к чату.';

  @override
  String get error_tbot_unauthorized =>
      'Ошибка авторизации. Введите корректный токен и попробуйте снова.';

  @override
  String get error_tbot_uninitialized =>
      'Не удалось получить ID чата. Начните диалог с ботом в Telegram и попробуйте снова.';

  @override
  String get error_unexpectedError =>
      'Произошла непредвиденная ошибка. Пожалуйста, попробуйте позже.';

  @override
  String get error_secretsError =>
      'Не удалось получить доступ к защищённому хранилищу. Попробуйте ещё раз. Если ошибка повторяется, перезапустите приложение и проверьте пароли/токены в правилах.';

  @override
  String get warn_secretsRecovered =>
      'Защищённое хранилище было восстановлено после сбоя, сохранённые пароли/токены могли быть удалены. Проверьте правила пересылки и введите данные заново.';

  @override
  String get warn_permissionsRequired =>
      'Чтобы начать мониторинг, пожалуйста, предоставьте необходимые разрешения.';
}
