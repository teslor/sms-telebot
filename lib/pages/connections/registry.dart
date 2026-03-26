import 'package:flutter/material.dart';
import 'telegram_bot.dart';
import 'smtp_server.dart';

final Map<String, Widget Function()> connectionProviders = {
  'telegram_bot': () => const TelegramBotConnection(),
  'smtp_server': () => const SmtpServerConnection(),
};
