# :outbox_tray: SMS Telebot

[![Android](https://img.shields.io/badge/Android-34A853?style=flat&logo=android&logoColor=white)](https://developer.android.com/)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue)](https://www.gnu.org/licenses/agpl-3.0)
[![Privacy Policy](https://img.shields.io/badge/Privacy%20Policy-green)](./PRIVACY_POLICY.md)

SMS Telebot is an Android app that automatically forwards incoming SMS to Telegram bots, email addresses via SMTP, or phone numbers via outgoing SMS.
It can also notify you about incoming calls, low battery, and charger connection status changes.

## :star: Features

* **Flexible Forwarding Rules**: Create as many forwarding rules as you need and route events to a Telegram bot, an SMTP server, or a phone number (via SMS). You can add multiple destinations!

* **Event Selection**: Choose exactly what to forward: incoming SMS, incoming calls, low battery alerts, or charger connection updates.

* **Custom Filters**: Set up filters based on sender or message text inside each rule to control which events are forwarded. Support for regular expressions is included.

* **Always-on Background Mode**: Keep monitoring active with a persistent notification for maximum delivery reliability on stricter Android builds.

* **Auto Retry**: If forwarding fails because of temporary issues (like no internet), the app automatically retries in the background.

* **Secure Storage**: Passwords and tokens are stored in encrypted form for better security.

## :hammer_and_wrench: Getting Started

* **Set Up Telegram Bot**: If you do not have a bot yet, create one with [@BotFather](https://t.me/BotFather) (quick and free), then open a chat with your bot and send any message so the app can fetch chat ID automatically.

* **Set Up SMTP Server**: Use any SMTP-enabled email account (for example Gmail). A dedicated mailbox is recommended, and in most cases you will need an app password from your email account security settings.

* **Create Forwarding Rules**: In the app, add one or more forwarding rules and choose the destination type (Telegram bot, SMTP server, SMS). Test each configuration and save it.

* **Start Forwarding**: Once configured, your incoming messages and events will be forwarded using your active rules.

## :mag: Using Filters

You can establish filters to control which messages are forwarded based on the sender or the message text. Filters can be set to trigger when the sender's number or name, or the message content, contains specific characters.

* **Whitelist Mode**: Messages will be forwarded if they match at least one filter.

* **Blacklist Mode**: Messages will not be forwarded if they match any filter.

To verify if a specific message will be forwarded, simply enter the sender and/or message in the provided fields and check the results.

## :warning: Important Notes

* **OS Variations**: Android vendors may apply background limits and security policies differently, so behavior can vary between devices and OS versions.

* **Battery Optimization**: The app runs in the background, which may cause the system to restrict its functionality to conserve battery. To avoid this, consider disabling battery optimization for the app in your device settings.

* **Chinese Firmwares**: On firmwares with aggressive background management (often found on some Chinese-brand devices), enabling always-on background mode is recommended for reliable delivery. It keeps the app running as a foreground service with a persistent notification, making it much less likely that the system silently pauses monitoring.

* **System Events**: If you rely on low battery or charger connection alerts, always-on background mode is also highly recommended because these notifications depend on system events.

* **Permissions**: The app does not request all permissions at startup. They are requested on-demand, strictly when you enable a specific feature that requires them (e.g., enabling SMS forwarding will prompt for SMS access).

* **Verification Codes**: On Huawei EMUI or Xiaomi MIUI, you may need to turn off Verification Code Protection to forward SMS with verification codes, but be aware that doing so can pose a security risk.

* **Antivirus / Play Protect**: Because the app monitors SMS/call events and forwards them over the network, heuristic scanners (Play Protect, Windows Defender, VirusTotal engines, etc.) may flag the APK as riskware or malware. These are typically false positives for this class of automation tools. The app does not send data to developer-controlled or hidden servers; traffic goes only to destinations you configure (Telegram / SMTP / SMS). Prefer installs from official [GitHub Releases](https://github.com/teslor/sms-telebot/releases), and see the [Privacy Policy](PRIVACY_POLICY.md) / [Security](SECURITY.md). If Play Protect blocks install, use *More details* → *Install anyway* (wording varies by Android version).

## License

Copyright (c) 2025-2026 Pavel D. (teslor)

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.  
See the [LICENSE](LICENSE) file for the full text.

### Commercial Use & Customization

If you represent a company and wish to use **SMS Telebot** in a closed-source commercial environment without AGPL restrictions, or if you need a **White-Label build**, please contact me for a **Commercial License**.
