import 'package:flutter/material.dart';
import '../../constants.dart';
import 'telegram_bot.dart';
import 'ntfy_server.dart';
import 'smtp_server.dart';
import 'sms_gateway.dart';

final Map<String, Widget Function()> connectionProviders = {
  ProviderId.telegram: () => const TelegramBotConnection(),
  ProviderId.ntfy: () => const NtfyServerConnection(),
  ProviderId.smtp: () => const SmtpServerConnection(),
  ProviderId.sms: () => const SmsGatewayConnection(),
};
