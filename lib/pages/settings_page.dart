import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../state.dart';
import '../service.dart';
import '../widgets/action_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _botTokenController;
  late TextEditingController _chatIdController;
  late TextEditingController _deviceLabelController;

  bool _isTesting = false;
  bool _isInputChanged = false;
  bool _isBotTokenCorrect = false;
  bool? _testResult; // null = not tested yet

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _botTokenController = TextEditingController(text: appState.botToken);
    _chatIdController = TextEditingController(text: appState.chatId);
    _deviceLabelController = TextEditingController(text: appState.deviceLabel);
    _isBotTokenCorrect = validateBotToken(_botTokenController.text);
  }

  @override
  void dispose() {
    _botTokenController.dispose();
    _chatIdController.dispose();
    _deviceLabelController.dispose();
    super.dispose();
  }

  bool validateBotToken(String value) {
    final regex = RegExp(r'^[0-9]{8,10}:[a-zA-Z0-9_-]{35}$');
    return regex.hasMatch(value);
  }

  Future<void> _testAndSaveSettings() async {
    setState(() { _isTesting = true; _testResult = null; });

    final appState = context.read<AppState>();
    String testBotToken = _botTokenController.text;
    String testChatId = _chatIdController.text;
    String testDeviceLabel = _deviceLabelController.text;

    if (testChatId.isEmpty) testChatId = await getUpdates(testBotToken);
    if (testChatId.isNotEmpty) {
      String helloMessage = mounted ? AppLocalizations.of(context)!.sms_hello : '=^•⩊•^=';
      if (testDeviceLabel.isNotEmpty) helloMessage = '$helloMessage <i>($testDeviceLabel)</i>';
      final result = await sendMessage(testBotToken, testChatId, helloMessage);
      if (result) {
        await appState.updateBotSettings(testBotToken, testChatId, testDeviceLabel);
        setState(() { _isTesting = false; _testResult = true; _chatIdController.text = testChatId; });
        return;
      }
    }
    setState(() { _isTesting = false; _testResult = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),

          TextField(
            controller: _botTokenController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.settings_token,
              helperText: AppLocalizations.of(context)!.settings_tokenInfo,
              helperMaxLines: 2,
            ),
            onChanged: (String value) {
              setState(() { _testResult = null; _isInputChanged = true; _isBotTokenCorrect = validateBotToken(value); });
            },
          ),

          const SizedBox(height: 20),

          TextField(
            controller: _chatIdController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.settings_chatId,
              helperText: AppLocalizations.of(context)!.settings_chatIdInfo,
              helperMaxLines: 2,
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: false, signed: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*$'))],
            onChanged: (String value) {
              setState(() { _testResult = null; _isInputChanged = true; });
            },
          ),

          const SizedBox(height: 20),

          const Divider(),

          const SizedBox(height: 20),

          TextField(
            controller: _deviceLabelController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.settings_deviceLabel,
              helperText: AppLocalizations.of(context)!.settings_deviceLabelInfo,
              helperMaxLines: 2,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: (String value) {
              setState(() { _testResult = null; _isInputChanged = true; });
            },
          ),

          Spacer(),

          ActionButton(
            label: AppLocalizations.of(context)!.settings_test,
            onPressed: _isTesting || !_isInputChanged || !_isBotTokenCorrect ? null : _testAndSaveSettings,
            isSuccess: _testResult,
            isInProgress: _isTesting,
          ),
        ],
      ),
    );
  }
}