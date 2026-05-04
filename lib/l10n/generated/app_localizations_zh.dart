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
  String get service_title => 'SMS Telebot 已激活';

  @override
  String get service_text => '正在监控事件';

  @override
  String get msg_list => '消息';

  @override
  String get msg_welcome => '点按“开始”\n即可启用监控';

  @override
  String get msg_empty => '过去24小时内\n没有消息';

  @override
  String get msg_hello => '你好！=^•⩊•^=';

  @override
  String get msg_received => '已接收';

  @override
  String get msg_sent => '已转发';

  @override
  String get msg_start => '开始';

  @override
  String get msg_stop => '停止';

  @override
  String get msg_sms => '短信';

  @override
  String get msg_call => '通话';

  @override
  String get msg_lowBattery => '电量低';

  @override
  String get msg_chargerConnected => '充电器已连接';

  @override
  String get msg_chargerDisconnected => '充电器已断开';

  @override
  String get rule => '规则';

  @override
  String get rule_add => '添加规则';

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
  String get filters_textInfo => '添加文本筛选器';

  @override
  String get settings => '设置';

  @override
  String get settings_forwardEvents => '要转发的事件';

  @override
  String get settings_forwardSms => '接收短信';

  @override
  String get settings_forwardCalls => '来电';

  @override
  String get settings_notifyLowBattery => '电量低';

  @override
  String get settings_notifyChargerState => '充电器连接状态';

  @override
  String get settings_enableForeground => '始终在后台运行';

  @override
  String get settings_deviceLabel => '设备标签';

  @override
  String get settings_deviceLabelInfo => '自定义标签（可选';

  @override
  String get help_about => '关于';

  @override
  String get help_appInfo => '用于自动转发接收短信的应用。\n附加功能：来电通知与电池状态通知。';

  @override
  String get help_info => '简介';

  @override
  String get help_info_01 =>
      '使用本应用，您可以将消息转发到 Telegram 机器人，或转发到支持 SMTP 的邮箱地址。您还可以添加多个机器人或邮箱地址。';

  @override
  String get help_info_02 => '每个连接都会创建一条转发规则，用于定义发送哪些消息、发送到哪里。规则可按需复制、启用或禁用。';

  @override
  String get help_info_03 => '应用会检查已启用规则并尝试转发新消息。若因技术原因（例如网络不可用）失败，应用会稍后重试。';

  @override
  String get help_info_04 => '请确保应用运行期间网络连接保持可用。';

  @override
  String get help_opts_01 => '首先选择需要转发的事件。应用运行时，会按已设置规则为每个事件生成并发送消息。';

  @override
  String get help_opts_02 =>
      '常驻后台模式可提高消息送达稳定性（尤其是系统通知），但会明显增加耗电。启用后，通知栏会显示常驻通知。除非确有需要，不建议开启。';

  @override
  String get help_opts_03 => '当您从多台手机转发消息时，可设置设备标签。该标签会随消息一起发送，用于识别消息来自哪台设备。';

  @override
  String get help_opts_04 => '建议为本应用关闭电池优化，因为系统可能会为省电而限制后台活动。';

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
  String get help_tbot_04 => '完成！现在已可将消息转发到您的机器人。启用规则后点击“开始”即可。';

  @override
  String get help_smtp => '连接 SMTP 服务器';

  @override
  String get help_smtp_01 =>
      '建议为消息转发创建一个专用邮箱（不要用别名）：它也会作为登录名。对于 Gmail 等类似服务尤其重要。';

  @override
  String get help_smtp_02 => '创建规则并填写连接参数。通常需要“应用专用密码”（在邮箱的安全设置中生成）。';

  @override
  String get help_smtp_03 => '测试并保存设置，开启规则并点击“开始”。';

  @override
  String get help_filters => '筛选器';

  @override
  String get help_filters_01 => '您可以按发件人或消息文本设置筛选器。当发件人号码/名称或文本包含指定字符时，筛选器会生效。';

  @override
  String get help_filters_02 =>
      '有两种模式：白名单（至少一个筛选器匹配时转发消息）和黑名单（任一筛选器匹配时不转发消息）。白名单模式下若未设置筛选器，则不会转发任何消息。';

  @override
  String get help_filters_03 =>
      '使用两个斜杠表示正则表达式。例如，筛选器 /^\\d*555\$/ 匹配所有以 555 结尾的号码';

  @override
  String get help_filters_04 =>
      '要检查某条消息在当前筛选条件下是否会被转发，请在输入框中填写发件人和/或消息文本，然后点击验证按钮。';

  @override
  String get help_filters_05 => '已设置的筛选器会应用于所有事件类型，不仅仅是接收短信。';

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

  @override
  String get warn_permissionsRequired => '要开始监控，请授予所需权限。';
}
