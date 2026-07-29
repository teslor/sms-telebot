# Security Policy & Information

**SMS Telebot** is an open-source, user-configured automation tool. Its core functionality involves listening for device events (SMS, Calls, Battery) and forwarding them to a destination (Telegram API, SMTP server, or another phone number via outgoing SMS) defined exclusively by the user.  
Due to this behavioral pattern, automated heuristic scanners may flag the application with generic labels such as *Android/Spy.SmsSpy*, *TR/Android.Evo* etc.

Please note the following regarding **SMS Telebot** architecture:

1. **No C&C Servers:** The app does not communicate with any developer-owned or hidden remote servers.
2. **Explicit Consent:** First-launch UI requires explicit user agreement to process any data.
3. **No Stealth Mechanics:** The app has a standard launcher icon, does not disguise itself as a system application, and does not hide from the installed apps list.
4. **On-Demand Permissions:** Permissions are requested contextually and strictly when a user activates a specific feature.
5. **Encrypted Storage:** All sensitive data, including Telegram bot tokens and SMTP passwords, is encrypted locally with keys managed by the Android Keystore.
6. **No SMS Fraud / Premium SMS:** The SEND_SMS permission is strictly utilized to dispatch standard text messages to user-defined phone numbers based on local routing rules. The application contains no mechanisms to autonomously send messages to premium-rate numbers.

## To Antivirus Labs and Security Researchers

If your engine detects **com.teslor.sms_telebot**, please consider this a **False Positive**. The developer kindly requests you review the source code, observe the required manual user configuration, and whitelist the package.
