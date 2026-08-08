import 'package:flutter/material.dart';
import 'telegram_bot.dart';
import 'ntfy_server.dart';
import 'smtp_server.dart';
import 'sms_gateway.dart';

final Map<String, Widget Function()> connectionProviders = {
  'telegram_bot': () => const TelegramBotConnection(),
  'ntfy_server': () => const NtfyServerConnection(),
  'smtp_server': () => const SmtpServerConnection(),
  'sms_gateway': () => const SmsGatewayConnection(),
};
