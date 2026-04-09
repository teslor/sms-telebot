// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get action_cancel => '取消';

  @override
  String get action_delete => '删除';

  @override
  String get action_duplicate => '复制';

  @override
  String get action_save => '保存';

  @override
  String get action_test => '测试';

  @override
  String get sms => '短信';

  @override
  String get sms_welcome => '点按“开始”即可\n开始转发短信';

  @override
  String get sms_empty => '过去24小时内\n没有收到短信';

  @override
  String get sms_hello => '来自 SMS Telebot 的问候！=^•⩊•^=';

  @override
  String get sms_from => '短信来自';

  @override
  String get sms_received => '已接收';

  @override
  String get sms_sent => '已转发';

  @override
  String get sms_start => '开始';

  @override
  String get sms_stop => '停止';

  @override
  String get rule => '规则';

  @override
  String get rule_add => '添加转发规则';

  @override
  String get rule_copySuffix => '副本';

  @override
  String get rule_deleteHeader => '删除规则？';

  @override
  String get rule_deleteText => '此操作无法撤销。';

  @override
  String get rule_noParams => '请先配置此规则，再启用它。';

  @override
  String get rules => '规则';

  @override
  String get rules_empty => '还没有规则。\n添加第一条！';

  @override
  String get connection => '连接';

  @override
  String get tbot => 'Telegram 机器人';

  @override
  String get tbot_token => '机器人令牌';

  @override
  String get tbot_tokenInfo => '从 @BotFather 获取的令牌';

  @override
  String get tbot_chatId => '聊天 ID';

  @override
  String get tbot_chatIdInfo => '与您的机器人的聊天 ID（可选）';

  @override
  String get smtp => 'SMTP 服务器';

  @override
  String get smtp_host => 'SMTP 主机';

  @override
  String get smtp_protocol => '协议';

  @override
  String get smtp_protocolEmpty => '无';

  @override
  String get smtp_port => '端口';

  @override
  String get smtp_login => '登录名';

  @override
  String get smtp_loginInfo => '通常为完整电子邮箱地址';

  @override
  String get smtp_password => '密码';

  @override
  String get smtp_passwordInfo => '通常为外部应用专用密码';

  @override
  String get smtp_fromEmail => '发件人邮箱';

  @override
  String get smtp_fromEmailInfo => '可选 - 留空时使用登录名';

  @override
  String get smtp_toEmail => '收件人邮箱';

  @override
  String get smtp_toEmailInfo => '收件人邮箱地址';

  @override
  String get smtp_subject => '主题';

  @override
  String get smtp_subjectInfo => '邮件主题（可选）';

  @override
  String get filters => '筛选器';

  @override
  String get filters_off => '关闭';

  @override
  String get filters_whitelist => '白名单';

  @override
  String get filters_blacklist => '黑名单';

  @override
  String get filters_sender => '发件人';

  @override
  String get filters_senderInfo => '添加号码或名称筛选器';

  @override
  String get filters_text => '消息';

  @override
  String get filters_textInfo => '添加短信文本筛选器';

  @override
  String get settings => '设置';

  @override
  String get settings_deviceLabel => '设备标签';

  @override
  String get settings_deviceLabelInfo => '自定义标签（可选';

  @override
  String get help_about => '关于';

  @override
  String get help_appInfo => '自动将接收的短信转发至 Telegram 机器人的应用';

  @override
  String get help_info => '简介';

  @override
  String get help_info_01 =>
      '此应用可将短信转发至 Telegram 机器人或电子邮件。您需要拥有自己的机器人或具有 SMTP 访问权限的邮箱。';

  @override
  String get help_info_02 =>
      '为每个连接创建转发规则——它决定转发哪些短信以及转发到哪里。规则可以根据需要进行复制、启用或禁用。';

  @override
  String get help_info_03 =>
      '收到短信时，应用会检查激活的规则并尝试转发。如果由于技术原因（例如没有网络）失败，应用会在稍后重试。';

  @override
  String get help_info_04 => '从多部手机转发短信时，您可以在设置中设置设备标签——它会随短信一起发送，以便识别发送短信的手机。';

  @override
  String get help_info_05 => '建议为本应用关闭电池优化，因为系统可能会为节省电量而限制应用在后台运行。';

  @override
  String get help_info_06 => '确保保持互联网连接以使应用正常工作。';

  @override
  String get help_tbot => '连接 Telegram 机器人';

  @override
  String get help_tbot_01 =>
      '如果您还没有 Telegram 机器人，请使用 @BotFather 创建一个并获取其令牌。这很简单且免费。';

  @override
  String get help_tbot_02 =>
      '在 Telegram 中打开与您的机器人的聊天，开始对话或发送任何消息。这是自动获取聊天 ID 所必需的。';

  @override
  String get help_tbot_03 =>
      '在应用中创建机器人规则并输入 Token（如果知道 Chat ID 也可以填入）。请务必测试设置后保存。测试成功后，您将收到一条欢迎消息。';

  @override
  String get help_tbot_04 => '完成！现在已准备好向您的机器人转发短信。开启规则并点击“开始”即可。';

  @override
  String get help_smtp => '连接 SMTP 服务器';

  @override
  String get help_smtp_01 =>
      '对于短信转发，最好创建一个独立的电子邮箱（不要使用别名）：它也将作为登录用户名。对于 Gmail 和类似服务尤其如此。';

  @override
  String get help_smtp_02 => '创建规则并填写连接参数。通常需要“应用专用密码”（在邮箱的安全设置中生成）。';

  @override
  String get help_smtp_03 => '测试并保存设置，开启规则并点击“开始”。';

  @override
  String get help_filters => '筛选器';

  @override
  String get help_filters_01 =>
      '您可以为接收短信的发件人或文本设置筛选器。如果发件人号码/名称或文本包含指定字符，则触发筛选器。';

  @override
  String get help_filters_02 =>
      '有两种模式：白名单（如果至少一个筛选器匹配则转发短信）和黑名单（如果任何筛选器匹配则不转发短信）。在白名单模式下，如果未设置筛选器，则不会向机器人转发任何短信。';

  @override
  String get help_filters_03 =>
      '使用两个斜杠表示正则表达式。例如，筛选器 /^\\d*555\$/ 匹配所有以 555 结尾的号码';

  @override
  String get help_filters_04 =>
      '要检查特定短信是否会根据当前筛选器转发，请在输入字段中输入所需的发件人和/或消息，然后点击按钮进行验证。';

  @override
  String get error_badRequest => '请求被拒绝。请检查输入的连接参数。';

  @override
  String get error_invalidParams => '连接参数无效。请修正后重试。';

  @override
  String get error_networkError => '请检查网络连接并重试。';

  @override
  String get error_networkTimeout => '请求超时。请检查网络，并确认输入的连接参数正确。';

  @override
  String get error_rateLimited => '请求过于频繁。请稍候再试。';

  @override
  String get error_serverError => '服务器当前不可用。请稍后再试。';

  @override
  String get error_smtpAddressRejected => '服务器拒绝了发件人或收件人的邮箱。请检查邮箱地址。';

  @override
  String get error_smtpError => '服务器返回了错误。请检查输入的连接参数。';

  @override
  String get error_smtp_forbidden => '该操作被服务器拒绝。请检查访问权限。';

  @override
  String get error_smtp_unauthorized => '授权错误。请检查登录名和密码。';

  @override
  String get error_tbot_conflict => '无法获取聊天 ID。请删除已激活的 Webhook，或手动输入 ID。';

  @override
  String get error_tbot_forbidden => 'Telegram 拒绝此操作。请确保机器人有权访问该聊天。';

  @override
  String get error_tbot_unauthorized => '授权错误。请输入有效令牌后重试。';

  @override
  String get error_tbot_uninitialized =>
      '无法获取聊天 ID。请先在 Telegram 中与机器人开始对话，然后重试。';

  @override
  String get error_unexpectedError => '发生了意外错误。请稍后再试。';

  @override
  String get error_secretsError =>
      '无法访问安全存储。请重试。如果问题仍然存在，请重启应用，并检查转发规则中的密码/令牌。';

  @override
  String get warn_secretsRecovered =>
      '崩溃后安全存储已恢复，已保存的密码/令牌可能已被删除。请检查转发规则并重新输入数据。';
}
