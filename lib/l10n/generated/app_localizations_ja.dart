// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

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
  String get filters_test => 'テスト';

  @override
  String get filters_save => '保存';

  @override
  String get settings => '設定';

  @override
  String get settings_token => 'ボットトークン';

  @override
  String get settings_tokenInfo => '@BotFatherから取得したトークン';

  @override
  String get settings_chatId => 'チャットID';

  @override
  String get settings_chatIdInfo => 'ボットとのチャットのID（オプション）';

  @override
  String get settings_deviceLabel => 'デバイスラベル';

  @override
  String get settings_deviceLabelInfo => 'カスタムラベル（オプション）';

  @override
  String get settings_test => 'テストして保存';

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
      '一部のスマートフォンでは、省電力のためバックグラウンドでの動作が制限される場合があります。配信が大きく遅れると感じた場合は、このアプリのバッテリー最適化を無効にしてください。';

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
}
