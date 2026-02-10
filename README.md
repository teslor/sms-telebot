# :outbox_tray: SMS Telebot

SMS Telebot is an Android app to automatically forward incoming SMS messages to a Telegram bot.

# :star: Features

* **Automatic SMS Forwarding**: Forward incoming SMS messages to your Telegram bot.

* **Custom Filters**: Set up filters based on sender or message text to control which SMS messages are forwarded. Support for regular expressions is included.

# :hammer_and_wrench: Getting Started

* **Create Your Telegram Bot**: If you haven't set up a Telegram bot yet, you can easily do so by using the [@BotFather](https://t.me/BotFather) bot. This process is straightforward and free of charge.

* **Initiate a Chat**: Open a conversation with your bot in Telegram and send any message. This step is necessary to retrieve the chat ID automatically.

* **Set Up the App**: In the app, navigate to the bot settings, input your bot token, and test the configuration. You can also specify the chat ID if you have it. A successful test will save your settings and send a greeting message to your Telegram chat.

* **Start Forwarding SMS**: Once configured, your incoming SMS messages will be forwarded to your bot.

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

<br>

---
Released under the MIT license.