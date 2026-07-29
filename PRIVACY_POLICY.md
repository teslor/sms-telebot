# Privacy Policy

This Privacy Policy explains how the **SMS Telebot** application collects, processes, and protects your data, as well as the developer stance on permissions and user transparency.

## 1. Data Processing and Storage

**SMS Telebot** is an automation tool designed strictly for personal use.

* **No Cloud / No Developer Access:** The developer does not operate any background servers, analytics engines, or telemetry systems. Your passwords, SMS messages, call logs, device events, and configuration data remain entirely private and not transmitted to any unauthorized remote servers.
* **Storage and Encryption:** All configuration settings are stored locally on the device. Sensitive data, including Telegram bot tokens and SMTP passwords, is stored in encrypted form.
* **User-Directed Routing:** Data is only transmitted to the destinations explicitly configured by you (e.g., your personal Telegram Bot, your designated SMTP server, or another phone number via outgoing SMS). The app does nothing until you manually create and enable a forwarding rule and tap Start.

## 2. Transparency and Application Behavior

**SMS Telebot** is fully transparent:

* **No Stealth Mode:** The application cannot be hidden from the device. Its icon is always visible in the system launcher.
* **Background Operation:** By default, the app uses standard Android background receivers to wake up momentarily upon receiving an SMS or event to execute your forwarding rules. It does not actively track user behavior.
* **Optional Foreground Service:** For devices with aggressive battery optimization, users can optionally enable an "Always-on" mode. When active, Android enforces a persistent, visible notification in the status bar, clearly indicating that the service is running.

## 3. Required Permissions and Justification

The application requests sensitive permissions purely on-demand, only when a specific feature is activated by the user:

* **RECEIVE_SMS:** Required only if you enable the SMS forwarding feature in the application settings. This allows the app to detect incoming text messages to trigger the forwarding rules.
* **READ_PHONE_STATE / READ_CALL_LOG:** Required only if you enable incoming call notifications in the settings. These permissions are used strictly to detect incoming phone numbers to route call alerts.
* **SEND_SMS:** Required if you configure a rule to forward events as standard outgoing SMS messages to another phone number. The application will never send SMS messages implicitly or to unknown numbers. (Please note: standard network carrier charges may apply for outgoing SMS).
* **FOREGROUND_SERVICE / POST_NOTIFICATIONS:** Required if you enable the optional "Always-on" mode. This allows the app to maintain a persistent connection without being killed by Android's battery optimizer. When active, it shows a status-bar notification to guarantee you are aware the app is running.
* **INTERNET:** Required to forward the triggered events to your Telegram bot or SMTP server.
* **RECEIVE_BOOT_COMPLETED:** Required to automatically re-initialize your active background forwarding rules after the device restarts.

## 4. Note on Security Alerts (Antivirus Warnings)

Because **SMS Telebot** interacts with your SMS messages and network connections to automate forwarding, some security applications or antivirus scanners might mistakenly flag it as a risk (a "false positive").
Please be assured that this is a normal reaction to automation tools. The application does not contain malicious code, does not have hidden functions, and strictly follows the rules you configure.

## 5. Changes to This Policy

This Privacy Policy may be updated from time to time. Please check this page periodically for updates.
