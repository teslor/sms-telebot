# :outbox_tray: SMS Telebot
[![Android](https://img.shields.io/badge/Android-34A853?style=flat&logo=android&logoColor=white)](https://developer.android.com/)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

SMS Telebot is an Android app to automatically forward incoming SMS messages to Telegram bots or email via SMTP.

# :star: Features

* **Flexible Forwarding Rules**: Create as many forwarding rules as you need and route SMS either to Telegram bots or to an SMTP email server.

* **Custom Filters**: Set up filters based on sender or message text inside each rule to control which SMS messages are forwarded. Support for regular expressions is included.

* **Auto Retry**: If forwarding fails because of temporary issues (like no internet), the app automatically retries in the background.

* **Secure Storage**: Passwords and tokens are stored in encrypted form for better security.

# :hammer_and_wrench: Getting Started

* **Set Up Telegram Bot**: If you do not have a bot yet, create one with [@BotFather](https://t.me/BotFather) (quick and free), then open a chat with your bot and send any message so the app can fetch chat ID automatically.

* **Set Up SMTP Server**: Use any SMTP-enabled email account (for example Gmail). A dedicated mailbox is recommended, and in most cases you will need an app password from your email account security settings.

* **Create Forwarding Rules**: In the app, add one or more forwarding rules and choose the destination type (Telegram bot or SMTP server). Test each connection and save it.

* **Start Forwarding SMS**: Once configured, your incoming SMS messages will be forwarded using your active rules.

# :mag: Using Filters

You can establish filters to control which SMS messages are forwarded based on the sender or the message text. Filters can be set to trigger when the sender's number or name, or the message content, contains specific characters.

* **Whitelist Mode**: Messages will be forwarded if they match at least one filter.

* **Blacklist Mode**: Messages will not be forwarded if they match any filter.

To verify if a specific SMS will be forwarded, simply enter the sender and/or message in the provided fields and check the results.

# :memo: Notes

* The app is not guaranteed to work properly on all devices, particularly on some customized Android systems due to possible OS security restrictions.

* The app runs in the background, which may cause the system to restrict its functionality to conserve battery. To avoid this, consider disabling battery optimization for the app in your device settings.

* Make sure to grant the necessary permissions for SMS access.

* On Huawei EMUI or Xiaomi MIUI, you may need to turn off Verification Code Protection to forward SMS with verification codes, but be aware that doing so can pose a security risk.

## License
Copyright (c) 2025-2026 Pavel D. (teslor)

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**. 
See the [LICENSE](LICENSE) file for the full text.

### Commercial Use & Customization
If you represent a company and wish to use **SMS Telebot** in a closed-source commercial environment without AGPL restrictions, or if you need a **White-Label build**, please contact me for a **Commercial License**.