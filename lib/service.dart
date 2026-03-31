import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import '../../l10n/generated/app_localizations.dart';
import 'constants.dart';

const MethodChannel _mainChannel = MethodChannel(AppConst.mainChannel);
typedef ProviderSendResult = ({bool isSuccess, String code});

Future<bool> getSmsPermission() async {
  if (await Permission.sms.status == PermissionStatus.granted) {
    return true;
  } else {
    if (await Permission.sms.request() == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

Future<void> getNotificationPermission() async {
  // Required on Android 13+ to show foreground notifications
  if (await Permission.notification.status != PermissionStatus.granted) {
    await Permission.notification.request();
  }
}

Future<({String code, String? chatId})> getUpdates(String? token) async {
  if (token == null) return (code: 'unexpected_error', chatId: null);
  final url = 'https://api.telegram.org/bot$token/getUpdates';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return switch (response.statusCode) {
        400 => (code: 'bad_request', chatId: null),
        401 => (code: 'unauthorized', chatId: null),
        403 => (code: 'forbidden', chatId: null),
        409 => (code: 'conflict', chatId: null),
        >= 500 && < 600 => (code: 'server_error', chatId: null),
        _ => (code: 'unexpected_error', chatId: null),
      };
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    final firstResult = jsonResponse['result']?[0]; // empty if chat is not initiated
    if (firstResult?['message']?['chat']?['id'] != null) {
      return (code: 'ok', chatId: firstResult['message']['chat']['id'].toString());
    }
    return (code: 'uninitialized', chatId: null);
  } catch (e) {
    return (code: 'network_error', chatId: null);
  }
}

void launchURL(String url) async {
  final uri = Uri.parse(url);
  try {
    await launchUrl(uri);
  } catch (e) { return; }
}

Map<String, dynamic>? safeDecode(dynamic source) {
  if (source == null || source is! String || source.isEmpty) return null;
  try {
    final decoded = jsonDecode(source);
    if (decoded is Map<String, dynamic>) return decoded;
    return null;
  } catch (_) {
    return null;
  }
}

bool isRegex(String text) {
  return text.isNotEmpty && text[0] == '/' && text[text.length - 1] == '/';
}

String getLocalizedError(AppLocalizations l10n, String code, [String? provider]) {
  return switch (code) {
    'bad_request' => l10n.error_badRequest,
    'conflict' => l10n.error_tbot_conflict,
    'forbidden' => switch (provider) {
      'smtp_server' => l10n.error_smtp_forbidden,
      'telegram_bot' => l10n.error_tbot_forbidden,
      _ => l10n.error_unexpectedError,
    },
    'invalid_params' => l10n.error_invalidParams,
    'network_error' => l10n.error_networkError,
    'network_timeout' => l10n.error_networkTimeout,
    'rate_limited' => l10n.error_rateLimited,
    'server_error' => l10n.error_serverError,
    'smtp_error' => l10n.error_smtpError,
    'smtp_recipients_rejected' => l10n.error_smtpRecipientsRejected,
    'unauthorized' => switch (provider) {
      'smtp_server' => l10n.error_smtp_unauthorized,
      'telegram_bot' => l10n.error_tbot_unauthorized,
      _ => l10n.error_unexpectedError,
    },
    'unexpected_error' => l10n.error_unexpectedError,
    'uninitialized' => l10n.error_tbot_uninitialized,
    _ => l10n.error_unexpectedError,
  };
}

// ================================================================================
// Native methods calls
// ================================================================================

Future<bool> isValidRegexNative(String text) async {
  try {
    final result = await _mainChannel.invokeMethod<bool>('isValidRegex', {
      'text': text,
    });
    return result ?? false;
  } catch (_) {
    return false;
  }
}

Future<ProviderSendResult> sendToProviderNative({
  required String provider,
  required Map<String, dynamic> config,
  required String body,
  String sender = '',
  String deviceLabel = '',
}) async {
  try {
    final result = await _mainChannel.invokeMethod<Map<dynamic, dynamic>>('sendToProvider', {
      'provider': provider,
      'configJson': jsonEncode(config),
      'sender': sender,
      'body': body,
      'deviceLabel': deviceLabel,
    });

    return (
      isSuccess: result!['isSuccess'] == true,
      code: (result['code'] ?? 'unexpected_error').toString(),
    );
  } on PlatformException catch (_) {
    return (isSuccess: false, code: 'unexpected_error');
  } catch (_) {
    return (isSuccess: false, code: 'unexpected_error');
  }
}
