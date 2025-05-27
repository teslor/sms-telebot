import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
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

  bool _isTesting = false;
  bool _isTestingDisabled = true;
  bool? _testResult; // null = not tested yet

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _botTokenController = TextEditingController(text: appState.botToken);
    _chatIdController = TextEditingController(text: appState.chatId);
    _isTestingDisabled = _botTokenController.text.isEmpty;
  }

  @override
  void dispose() {
    _botTokenController.dispose();
    _chatIdController.dispose();
    super.dispose();
  }

  Future<void> _testAndSaveSettings() async {
    setState(() { _isTesting = true; _testResult = null; });

    final appState = context.read<AppState>();
    String testBotToken = _botTokenController.text;
    String testChatId = _chatIdController.text;

    if (testChatId.isEmpty) testChatId = await getUpdates(testBotToken);
    if (testChatId.isNotEmpty) {
      final result = await sendMessage(testBotToken, testChatId, mounted ? AppLocalizations.of(context)!.sms_hello : '=^•⩊•^=');
      if (result) {
        await appState.updateBotSettings(testBotToken, testChatId);
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
            onSubmitted: (String value) { 
              setState(() { _testResult = null; });
            },
            onChanged: (String value) {
              setState(() { _isTestingDisabled = value.isEmpty; });
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
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSubmitted: (String value) { 
              setState(() { _testResult = null; });
            }
          ),

          Spacer(),

          ActionButton(
            label: AppLocalizations.of(context)!.settings_test,
            onPressed: _isTesting || _isTestingDisabled ? null : _testAndSaveSettings,
            isSuccess: _testResult,
            isInProgress: _isTesting,
          ),
        ],
      ),
    );
  }
}