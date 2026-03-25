import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'constants.dart';

const MethodChannel _mainChannel = MethodChannel(AppConst.mainChannel);

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

Future<String> getUpdates(String? token) async {
  if (token == null) return '';
  final url = 'https://api.telegram.org/bot$token/getUpdates';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return '';

    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    final firstResult = jsonResponse['result']?[0];
    if (firstResult?['message']?['chat']?['id'] != null) {
      return firstResult['message']['chat']['id'].toString();
    }
  } catch (e) { return ''; }

  return '';
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

Future<bool> sendToTelegramBotNative({
  required Map<String, dynamic> config,
  required String body,
  String sender = '',
  String deviceLabel = '',
  String l10nSmsFrom = 'SMS from',
}) async {
  try {
    final result = await _mainChannel.invokeMethod<bool>('sendToTelegramBot', {
      'configJson': jsonEncode(config),
      'sender': sender,
      'body': body,
      'deviceLabel': deviceLabel,
      'l10nSmsFrom': l10nSmsFrom,
    });
    return result ?? false;
  } catch (_) {
    return false;
  }
}
