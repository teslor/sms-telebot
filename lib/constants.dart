const appName = 'SMS Telebot';
const appLink = 'https://github.com/teslor/sms-telebot';
const appVersion = '0.8.0';
const mainChannel = 'sms_telebot/main';
const filterKeys = [
  'whitelistSenders',
  'whitelistBody',
  'blacklistSenders',
  'blacklistBody',
];

abstract final class ProviderId {
  static const telegram = 'telegram_bot';
  static const ntfy = 'ntfy_server';
  static const smtp = 'smtp_server';
  static const sms = 'sms_gateway';
}
const telegramUrl = 'https://api.telegram.org';
const ntfyUrl = 'https://ntfy.sh';
