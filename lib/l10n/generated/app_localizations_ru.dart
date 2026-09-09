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
  String get action_close => 'Закрыть';

  @override
  String get action_continue => 'Продолжить';

  @override
  String get action_delete => 'Удалить';

  @override
  String get action_duplicate => 'Дублировать';

  @override
  String get action_exit => 'Выйти';

  @override
  String get action_save => 'Сохранить';

  @override
  String get action_test => 'Проверить';

  @override
  String get service_title => 'SMS Telebot активен';

  @override
  String get service_text => 'Мониторинг событий';

  @override
  String get msg_list => 'Сообщения';

  @override
  String get msg_welcome => 'Нажмите Старт, чтобы\nвключить мониторинг';

  @override
  String get msg_empty => 'Нет сообщений\nза последние 24 часа';

  @override
  String get msg_hello => 'Привет! ^._.^';

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
  String get msg_battery => 'Батарея';

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
  String get rules_setup => 'Настройка правил';

  @override
  String get config => 'Параметры';

  @override
  String get connection => 'Подключение';

  @override
  String get tbot_token => 'Токен';

  @override
  String get tbot_chatId => 'ID чата';

  @override
  String get tbot_chatIdInfo => 'По умолчанию: получить автоматически';

  @override
  String get tbot_server => 'URL сервера';

  @override
  String tbot_serverInfo(Object url) {
    return 'По умолчанию: $url';
  }

  @override
  String get ntfy_topic => 'Тема';

  @override
  String get ntfy_priority => 'Приоритет';

  @override
  String get ntfy_priority_01 => 'Минимальный';

  @override
  String get ntfy_priority_02 => 'Низкий';

  @override
  String get ntfy_priority_03 => 'По умолчанию';

  @override
  String get ntfy_priority_04 => 'Высокий';

  @override
  String get ntfy_priority_05 => 'Максимальный';

  @override
  String get ntfy_token => 'Токен доступа';

  @override
  String get ntfy_tokenInfo => 'Bearer-токен; по умолчанию: без токена';

  @override
  String get ntfy_server => 'URL сервера';

  @override
  String ntfy_serverInfo(Object url) {
    return 'По умолчанию: $url';
  }

  @override
  String get smtp_host => 'SMTP-хост';

  @override
  String get smtp_protocol => 'Протокол';

  @override
  String get smtp_protocolEmpty => 'Нет';

  @override
  String get smtp_port => 'Порт';

  @override
  String get smtp_insecureTls => 'Упрощённая проверка сертификата';

  @override
  String get smtp_insecureTlsInfo =>
      'Используйте только при ошибках подключения (особенно на старых устройствах). Снижает безопасность соединения.';

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
  String get smtp_fromEmailInfo => 'По умолчанию: логин';

  @override
  String get smtp_toEmail => 'Email получателя';

  @override
  String get smtp_toEmailInfo => 'По умолчанию: логин';

  @override
  String get smtp_subject => 'Тема';

  @override
  String get smtp_subjectInfo => 'По умолчанию: автоматически';

  @override
  String get sms_receiver => 'Получатель';

  @override
  String get sms_number => 'Номер телефона';

  @override
  String get sms_numberInfo => 'Например, +12345678900';

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
  String get filters_textInfo => 'Добавьте фильтры для текста';

  @override
  String get options => 'Параметры';

  @override
  String get options_priority => 'Приоритет правила';

  @override
  String get options_priorityInfo =>
      'Правило игнорируется при срабатывании правила с более высоким приоритетом';

  @override
  String get options_priority_01 => 'Максимальный';

  @override
  String get options_priority_02 => 'Высокий';

  @override
  String get options_priority_03 => 'Средний';

  @override
  String get options_priority_04 => 'Низкий';

  @override
  String get options_priority_05 => 'Минимальный';

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
  String get settings_attachSimInfo => 'Передавать данные SIM';

  @override
  String get settings_format => 'Формат сообщений';

  @override
  String get settings_formatDefault => 'Стандартный';

  @override
  String get settings_formatPaste => 'Вставить из буфера';

  @override
  String get settings_formatPreview => 'Открыть предпросмотр';

  @override
  String get settings_formatReset => 'Сбросить';

  @override
  String get settings_formatError => 'Некорректный формат шаблона.';

  @override
  String get settings_deviceLabel => 'Метка устройства';

  @override
  String get settings_deviceLabelInfo => 'По умолчанию: без метки';

  @override
  String get help_about => 'О приложении';

  @override
  String get help_appInfo =>
      'Автоматическая пересылка СМС, уведомлений о входящих звонках и статусе батареи.';

  @override
  String get help_info => 'Введение';

  @override
  String get help_info_01 =>
      'Пересылайте сообщения в Telegram, ntfy, на email или в виде СМС. Можно комбинировать сразу несколько способов отправки!';

  @override
  String get help_info_02 =>
      'Используйте правила, чтобы настроить, что и куда пересылать. Их легко дублировать или отключать при необходимости.';

  @override
  String get help_info_03 =>
      'Сообщения пересылаются согласно активным правилам. При ошибке связи (например, нет интернета) повторные попытки отправки выполняются автоматически.';

  @override
  String get help_opts_01 =>
      'Для начала выберите нужные события для пересылки. В процессе работы приложения для каждого события формируется и отправляется сообщение с учётом заданных правил.';

  @override
  String get help_opts_02 =>
      'Режим постоянной работы в фоне повышает надёжность доставки сообщений (особенно системных уведомлений), но увеличивает расход батареи. В этом режиме отображается постоянное уведомление в шторке. Включайте только при необходимости.';

  @override
  String get help_opts_03 =>
      'Включите переключатель, чтобы при пересылке входящих СМС и звонков добавить данные SIM-карты (слот и оператор). На некоторых системах SIM-данные недоступны (особенно для звонков).';

  @override
  String get help_opts_04 =>
      'Если вы хотите изменить формат сообщений, скачайте файл-шаблон, внесите свои правки и вставьте текст шаблона в настройках.';

  @override
  String get help_opts_04h => 'Скачать шаблон';

  @override
  String get help_opts_05 =>
      'При использовании приложения на нескольких телефонах можно задать метку устройства — она отправляется вместе с сообщением для идентификации телефона-получателя.';

  @override
  String get help_opts_06 =>
      'Важно отключить для приложения оптимизацию батареи, поскольку система может ограничивать работу в фоне для экономии заряда.';

  @override
  String get help_rule_01 =>
      'Проверьте и сохраните настройки (при успешной проверке придёт приветственное сообщение). Затем включите правило в списке и нажмите Старт, чтобы начать пересылку!';

  @override
  String get help_tbot_01 =>
      'Если у вас пока нет своего бота, создайте его с помощью бота @BotFather и получите токен.';

  @override
  String get help_tbot_02 =>
      'Откройте чат с вашим ботом в приложении Telegram и отправьте любое сообщение. Это нужно для автоматического получения ID чата.';

  @override
  String get help_tbot_03 =>
      'Создайте правило для Telegram и введите токен в параметрах подключения. ID чата можно задать вручную, если он известен.';

  @override
  String get help_tbot_04 =>
      'Также можно задать адрес собственного API-сервера, чтобы использовать его вместо официального сервера Telegram.';

  @override
  String help_ntfy_01(Object url) {
    return 'В приложении ntfy или веб-версии ($url) подпишитесь на новую тему, выбрав имя, которое сложно угадать.';
  }

  @override
  String get help_ntfy_02 =>
      'Создайте правило, укажите имя темы и при необходимости задайте приоритет уведомления.';

  @override
  String get help_ntfy_03 =>
      'Темы без аутентификации доступны всем, кто знает их имя. Для дополнительной защиты данных используйте аутентификацию и токен доступа.';

  @override
  String get help_ntfy_04 =>
      'По умолчанию используется официальный сервер ntfy.sh, но можно задать свой.';

  @override
  String get help_smtp_01 =>
      'Рекомендуется создать отдельный email (не алиас) специально для пересылки сообщений и использовать его как логин. Особенно актуально для Gmail и подобных сервисов.';

  @override
  String get help_smtp_02 =>
      'Создайте правило и заполните параметры подключения. Пароль чаще всего нужен для внешних приложений (генерируется в настройках безопасности почты).';

  @override
  String get help_sms_01 =>
      'Приложение поддерживает пересылку сообщений в виде исходящих СМС.';

  @override
  String get help_sms_02 =>
      'Создайте правило и введите номер телефона получателя. Мобильный номер должен начинаться с символа + (международный формат).';

  @override
  String get help_sms_03 =>
      'СМС отправляются с SIM-карты, выбранной по умолчанию в настройках телефона.';

  @override
  String get help_filters => 'Фильтры';

  @override
  String get help_filters_01 =>
      'Для любого правила можно установить фильтры для отправителя и текста сообщения. Фильтр срабатывает, если номер/имя отправителя или текст содержат заданные символы.';

  @override
  String get help_filters_02 =>
      'Есть два режима: белый список (сообщение пересылается, если срабатывает хотя бы один фильтр) и чёрный список (соответственно, не пересылается). В режиме белого списка, если не задано ни одного фильтра, то никакие сообщения пересылаться не будут.';

  @override
  String get help_filters_03 =>
      'Используйте два символа / для регулярного выражения в качестве фильтра. Например, фильтр /^\\d*555\$/ соответствует номерам, которые оканчиваются на 555.';

  @override
  String get help_filters_04 =>
      'Чтобы проверить, будет ли переслано сообщение с учётом установленных фильтров, введите нужного отправителя и/или текст сообщения в поля ввода и нажмите кнопку для проверки.';

  @override
  String get help_filters_05 =>
      'Фильтры применяются для всех типов событий, не только для входящих СМС.';

  @override
  String get help_options_01 =>
      'Приоритет правила определяет очерёдность обработки. Если правило сработало (сообщение отправлено), то остальные с меньшим приоритетом не применяются. Правила с одинаковым приоритетом срабатывают одновременно.';

  @override
  String get consent_welcome =>
      'Добро пожаловать!\nПродолжая, вы подтверждаете, что ознакомились с этой информацией:';

  @override
  String get consent_item_01 =>
      'В зависимости от выбранных параметров приложение может получать данные входящих СМС и звонков, а также отправлять СМС на указанные вами номера.';

  @override
  String get consent_item_02 =>
      'Данные передаются только в те сервисы, которые вы настроили сами. Скрытых серверов и аналитики нет.';

  @override
  String get consent_item_03 =>
      'Важные разрешения запрашиваются только при включении соответствующих функций.';

  @override
  String get consent_details => 'Подробнее: ';

  @override
  String get consent_privacyPolicy => 'политика конфиденциальности';

  @override
  String get error_badRequest =>
      'Сервер отклонил запрос. Проверьте параметры подключения.';

  @override
  String get error_forbidden => 'Ошибка авторизации. Проверьте права доступа.';

  @override
  String get error_invalidParams => 'Некорректные параметры подключения.';

  @override
  String get error_networkError =>
      'Ошибка соединения. Проверьте интернет или настройки сети.';

  @override
  String get error_networkTimeout =>
      'Время ожидания истекло. Проверьте сеть или параметры подключения';

  @override
  String get error_rateLimited => 'Превышен лимит запросов. Попробуйте позже.';

  @override
  String get error_serverError =>
      'Ошибка на стороне сервера. Попробуйте позже.';

  @override
  String get error_smtpAddressRejected =>
      'Сервер отклонил email отправителя или получателя. Проверьте адреса.';

  @override
  String get error_smtpError =>
      'Сервер вернул ошибку. Проверьте параметры подключения.';

  @override
  String get error_smtp_unauthorized =>
      'Ошибка доступа. Проверьте логин и пароль.';

  @override
  String get error_tbot_conflict =>
      'Не удалось получить ID чата. Удалите активный webhook или введите ID вручную.';

  @override
  String get error_tbot_forbidden =>
      'Ошибка авторизации. Убедитесь, что у бота есть доступ к чату.';

  @override
  String get error_tbot_unauthorized => 'Ошибка доступа. Проверьте токен.';

  @override
  String get error_tbot_uninitialized =>
      'Не удалось получить ID чата. Начните диалог с ботом в Telegram и попробуйте снова.';

  @override
  String get error_unauthorized => 'Ошибка доступа. Проверьте учётные данные.';

  @override
  String get error_unexpectedError => 'Не удалось выполнить действие.';

  @override
  String get error_secretsError =>
      'Не удалось получить доступ к защищённому хранилищу. Попробуйте ещё раз. Если ошибка повторяется, перезапустите приложение и проверьте пароли/токены в правилах.';

  @override
  String get warn_secretsRecovered =>
      'Защищённое хранилище было восстановлено после сбоя, сохранённые пароли/токены могли быть удалены. Проверьте правила пересылки и введите данные заново.';

  @override
  String get warn_permissionsRequired =>
      'Чтобы начать мониторинг, предоставьте необходимые разрешения.';
}
