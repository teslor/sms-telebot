import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:convert';
import '../../l10n/generated/app_localizations.dart';
import 'constants.dart';

const MethodChannel _mainChannel = MethodChannel(AppConst.mainChannel);

// Universal call result type
typedef CallResult = ({bool isSuccess, String code, String? data});
CallResult okResult([String? data]) => (isSuccess: true, code: 'ok', data: data);
CallResult errorResult([String code = 'unexpected_error', String? data]) => (isSuccess: false, code: code, data: data);

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

Future<CallResult> getUpdates(String? token) async {
  if (token == null) return errorResult();
  final url = 'https://api.telegram.org/bot$token/getUpdates';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return switch (response.statusCode) {
        400 => errorResult('bad_request'),
        401 => errorResult('unauthorized'),
        403 => errorResult('forbidden'),
        409 => errorResult('conflict'),
        >= 500 && < 600 => errorResult('server_error'),
        _ => errorResult(),
      };
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final result = jsonResponse['result'];
    final firstResult = (result is List && result.isNotEmpty) ? result.first : null; // empty if chat is not initiated
    if (firstResult?['message']?['chat']?['id'] != null) {
      return okResult(firstResult['message']['chat']['id'].toString());
    }
    return errorResult('uninitialized');
  } catch (e) {
    return errorResult('network_error');
  }
}

void launchURL(String url) {
  final uri = Uri.parse(url);
  launchUrl(uri);
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
    // General/Network
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
    'smtp_address_rejected' => l10n.error_smtpAddressRejected,
    'smtp_error' => l10n.error_smtpError,
    'unauthorized' => switch (provider) {
      'smtp_server' => l10n.error_smtp_unauthorized,
      'telegram_bot' => l10n.error_tbot_unauthorized,
      _ => l10n.error_unexpectedError,
    },
    'unexpected_error' => l10n.error_unexpectedError,
    'uninitialized' => l10n.error_tbot_uninitialized,
 
    // Secure storage
    'secrets_error' => l10n.error_secretsError,
    'secrets_recovered' => l10n.warn_secretsRecovered,
 
    _ => l10n.error_unexpectedError,
  };
}

// ================================================================================
// Native methods calls
// ================================================================================

// Convert native call result to CallResult
CallResult _toCallResult(Map<dynamic, dynamic>? source) {
  if (source == null) {
    return (isSuccess: false, code: 'unexpected_error', data: null);
  }
  final rawData = source['data'];
  return (
    isSuccess: source['isSuccess'] == true,
    code: (source['code'] ?? 'unexpected_error').toString(),
    data: rawData is String ? rawData : null,
  );
}

Future<CallResult> sendToProviderNative({
  required String provider,
  required Map<String, dynamic> config,
  required String secret,
  required String body,
  String sender = '',
  String deviceLabel = '',
}) async {
  try {
    final result = await _mainChannel.invokeMethod<Map<dynamic, dynamic>>('sendToProvider', {
      'provider': provider,
      'configJson': jsonEncode(config),
      'secret': secret,
      'sender': sender,
      'body': body,
      'deviceLabel': deviceLabel,
    });
    return _toCallResult(result);
  } catch (_) {
    return errorResult();
  }
}

Future<bool> checkFiltersNative(String sender, String sms, int mode, Map<String, List<String>> filterLists) async {
  try {
    final result = await _mainChannel.invokeMethod<bool>('checkFilters', {
      'sender': sender,
      'sms': sms,
      'mode': mode,
      'whitelistSenders': filterLists[AppConst.filterKeys[0]] ?? <String>[],
      'whitelistBody': filterLists[AppConst.filterKeys[1]] ?? <String>[],
      'blacklistSenders': filterLists[AppConst.filterKeys[2]] ?? <String>[],
      'blacklistBody': filterLists[AppConst.filterKeys[3]] ?? <String>[],
    });
    return result ?? false;
  } catch (_) {
    return false;
  }
}

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

Future<CallResult> saveSecretNative(String id, String secret) async {
  try {
    final result = await _mainChannel.invokeMethod<Map<dynamic, dynamic>>('saveSecret', {
      'id': id,
      'secret': secret,
    });
    return _toCallResult(result);
  } catch (_) {
    return errorResult();
  }
}

Future<CallResult> readSecretNative(String id) async {
  try {
    final result = await _mainChannel.invokeMethod<Map<dynamic, dynamic>>('readSecret', {'id': id});
    return _toCallResult(result);
  } catch (_) {
    return errorResult();
  }
}

Future<CallResult> deleteSecretNative(String id) async {
  try {
    final result = await _mainChannel.invokeMethod<Map<dynamic, dynamic>>('deleteSecret', {'id': id});
    return _toCallResult(result);
  } catch (_) {
    return errorResult();
  }
}

void stopWorkersNative() {
  unawaited(
    _mainChannel.invokeMethod<void>('stopWorkers').catchError((_, _) {}),
  );
}
