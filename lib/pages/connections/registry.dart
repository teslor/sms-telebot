import 'package:flutter/material.dart';
import 'telegram_bot.dart';

final Map<String, Widget Function()> connectionProviders = {
  'telegram_bot': () => const TelegramBotConnection(),
};
