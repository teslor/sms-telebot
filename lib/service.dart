import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

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

Future<bool> sendMessage(String? token, String? chatId, String msg) async {
  if (token == null || chatId == null) return false;
  final url = 'https://api.telegram.org/bot$token/sendMessage?chat_id=$chatId&text=${Uri.encodeComponent(msg)}&parse_mode=HTML';

  try {
    final response = await http.get(Uri.parse(url));
    return response.statusCode == 200;
  } catch (e) { return false; }
}

void launchURL(String url) async {
  final uri = Uri.parse(url);
  try {
    await launchUrl(uri);
  } catch (e) { return; }
}

bool isRegex(String text) {
  return text.isNotEmpty && text[0] == '/' && text[text.length - 1] == '/';
}

bool isValidRegex(String text) {
  try {
    RegExp(text.substring(1, text.length - 1));
    return true;
  } catch (e) {
    return false;
  }  
}

bool hasFilterMatches(String text, List<String>? filters) {
  if (text.isEmpty || filters == null) return false;
  for (String filter in filters) {
    if (isRegex(filter)) {
      try {
        RegExp regex = RegExp(filter.substring(1, filter.length - 1));
        if (regex.hasMatch(text)) return true;
      } catch (e) { /**/ }
    } else {
      if (text.contains(filter)) return true;
    }
  }
  return false;
}