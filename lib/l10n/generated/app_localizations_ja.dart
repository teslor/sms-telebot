// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get action_cancel => 'キャンセル';

  @override
  String get action_delete => '削除';

  @override
  String get action_duplicate => '複製';

  @override
  String get action_save => '保存';

  @override
  String get action_test => 'テスト';

  @override
  String get action_testAndSave => 'テストして保存';

  @override
  String get sms => 'SMS';

  @override
  String get sms_welcome => '「開始」をタップして\nSMSの転送を開始します';

  @override
  String get sms_empty => '現在のセッションに\n受信SMSはありません';

  @override
  String get sms_hello => 'SMS Telebotからこんにちは！=^•⩊•^=';

  @override
  String get sms_from => '送信元';

  @override
  String get sms_received => '受信';

  @override
  String get sms_sent => '転送済み';

  @override
  String get sms_start => '開始';

  @override
  String get sms_stop => '停止';

  @override
  String get rule => 'ルール';

  @override
  String get rule_add => '転送ルールを追加';

  @override
  String get rule_copySuffix => 'コピー';

  @override
  String get rule_deleteHeader => 'ルールを削除しますか？';

  @override
  String get rule_deleteText => 'この操作は元に戻せません。';

  @override
  String get rule_noParams => 'このルールを有効にする前に設定してください。';

  @override
  String get rules => 'ルール';

  @override
  String get rules_empty => 'まだルールがありません\n最初のルールを作成しましょう！';

  @override
  String get connection => '接続';

  @override
  String get telebot => 'Telegramボット';

  @override
  String get telebot_token => 'ボットトークン';

  @override
  String get telebot_tokenInfo => '@BotFatherから取得したトークン';

  @override
  String get telebot_chatId => 'チャットID';

  @override
  String get telebot_chatIdInfo => 'ボットとのチャットのID（オプション）';

  @override
  String get smtp => 'SMTPサーバー';

  @override
  String get smtp_host => 'SMTPホスト';

  @override
  String get smtp_protocol => 'プロトコル';

  @override
  String get smtp_protocolEmpty => 'なし';

  @override
  String get smtp_port => 'ポート';

  @override
  String get smtp_login => 'ログイン';

  @override
  String get smtp_loginInfo => '通常はメールアドレス全体';

  @override
  String get smtp_password => 'パスワード';

  @override
  String get smtp_passwordInfo => '通常は外部アプリ用パスワード';

  @override
  String get smtp_fromEmail => '送信元メール';

  @override
  String get smtp_fromEmailInfo => '任意 - 空の場合はログインを使用';

  @override
  String get smtp_toEmail => '送信先メール';

  @override
  String get smtp_toEmailInfo => '受信者のメールアドレス';

  @override
  String get smtp_subject => '件名';

  @override
  String get smtp_subjectInfo => 'メール件名（オプション）';

  @override
  String get filters => 'フィルター';

  @override
  String get filters_off => 'オフ';

  @override
  String get filters_whitelist => 'ホワイトリスト';

  @override
  String get filters_blacklist => 'ブラックリスト';

  @override
  String get filters_sender => '送信元';

  @override
  String get filters_senderInfo => '番号または名前のフィルターを追加';

  @override
  String get filters_text => 'メッセージ';

  @override
  String get filters_textInfo => 'SMSテキストのフィルターを追加';

  @override
  String get settings => '設定';

  @override
  String get settings_deviceLabel => 'デバイスラベル';

  @override
  String get settings_deviceLabelInfo => 'カスタムラベル（オプション）';

  @override
  String get help_about => 'このアプリについて';

  @override
  String get help_appInfo => '受信したSMSメッセージを自動的にTelegramボットに転送するアプリ';

  @override
  String get help_howToUse => '使い方';

  @override
  String get help_howToUse_01 =>
      'Telegramボットをまだお持ちでない場合は、@BotFatherを使用して作成し、トークンを取得してください。簡単で無料です。';

  @override
  String get help_howToUse_02 =>
      'Telegramでボットとのチャットを開き、会話を開始するか、メッセージを送信してください。これは次のステップでチャットIDを自動的に取得するために必要です。';

  @override
  String get help_howToUse_03 =>
      'アプリを開き、ボット設定でトークンを入力して設定をテストします（チャットIDがわかっている場合は設定することもできます）。テストが成功すると、設定が保存され、Telegramチャットにウェルカムメッセージが送信されます。';

  @override
  String get help_howToUse_04 =>
      'これで完了です！アプリは受信したSMSをボットへ転送する準備ができました。「開始」をタップするとSMS転送が有効になり、「停止」をタップすると無効になります。';

  @override
  String get help_howToUse_04l =>
      '複数のデバイスからSMSを転送する場合、設定でデバイスラベルを設定して受信電話を識別できます。';

  @override
  String get help_howToUse_05 =>
      'バッテリー節約のためにシステムがバックグラウンドでのアプリ動作を制限する場合があるため、このアプリのバッテリー最適化を無効にすることを推奨します。';

  @override
  String get help_howToUse_06 => 'アプリが動作するように、インターネット接続を有効にしておいてください。';

  @override
  String get help_filters => 'フィルター';

  @override
  String get help_filters_01 =>
      '受信したSMSメッセージの送信元またはテキストにフィルターを設定できます。送信元の番号/名前またはテキストに指定された文字が含まれている場合、フィルターがトリガーされます。';

  @override
  String get help_filters_02 =>
      '2つのモードがあります：ホワイトリスト（少なくとも1つのフィルターが一致した場合にSMSを転送）とブラックリスト（いずれかのフィルターが一致した場合にSMSを転送しない）。ホワイトリストモードでフィルターが設定されていない場合、ボットにSMSは転送されません。';

  @override
  String get help_filters_03 =>
      '正規表現には2つのスラッシュを使用してください。例えば、フィルター /^\\d*555\$/ は555で終わるすべての番号に一致します';

  @override
  String get help_filters_04 =>
      '現在のフィルターに基づいて特定のSMSが転送されるかどうかを確認するには、入力フィールドに必要な送信元やメッセージを入力し、ボタンをクリックして検証してください。';

  @override
  String get error_badRequest => 'リクエストは拒否されました。入力した接続パラメータを確認してください。';

  @override
  String get error_invalidParams => '接続パラメータが無効です。修正して再試行してください。';

  @override
  String get error_networkError => 'インターネット接続を確認して、もう一度お試しください。';

  @override
  String get error_networkTimeout =>
      'タイムアウトしました。インターネット接続を確認し、入力した接続パラメータが正しいことを確認してください。';

  @override
  String get error_rateLimited => 'リクエストの送信が速すぎます。しばらく待ってから再試行してください。';

  @override
  String get error_serverError => 'サーバーは現在利用できません。後でもう一度お試しください。';

  @override
  String get error_smtpAddressRejected =>
      'サーバーが送信者または受信者のメールアドレスを拒否しました。アドレスを確認してください。';

  @override
  String get error_smtpError => 'サーバーがエラーを返しました。入力した接続パラメータを確認してください。';

  @override
  String get error_smtp_forbidden => 'アクションはサーバーに拒否されました。アクセス権を確認してください。';

  @override
  String get error_smtp_unauthorized => '認証エラーです。ログインIDとパスワードを確認してください。';

  @override
  String get error_tbot_conflict =>
      'チャットIDを取得できませんでした。アクティブなWebhookを削除するか、IDを手動で入力してください。';

  @override
  String get error_tbot_forbidden =>
      'Telegramがアクションを拒否しました。ボットのチャットアクセス権限を確認してください。';

  @override
  String get error_tbot_unauthorized => '認証エラーです。有効なトークンを入力して再試行してください。';

  @override
  String get error_tbot_uninitialized =>
      'チャットIDを取得できませんでした。Telegramでボットとの会話を開始してから再試行してください。';

  @override
  String get error_unexpectedError => '予期しないエラーが発生しました。後でもう一度お試しください。';

  @override
  String get error_secretsError =>
      '安全なストレージにアクセスできません。再試行してください。問題が続く場合はアプリを再起動し、転送ルールのパスワード/トークンを確認してください。';

  @override
  String get warn_secretsRecovered =>
      'クラッシュ後に安全なストレージが復旧されました。保存済みのパスワード/トークンが削除された可能性があります。転送ルールを確認し、データを再入力してください。';
}
