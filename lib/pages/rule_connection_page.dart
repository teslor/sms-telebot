import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../state.dart';
import '../service.dart';
import '../widgets/action_button.dart';

class RuleConnectionPage extends StatefulWidget {
  const RuleConnectionPage({super.key});

  @override
  State<RuleConnectionPage> createState() => _RuleConnectionPageState();
}

class _RuleConnectionPageState extends State<RuleConnectionPage> {
  late TextEditingController _botTokenController;
  late TextEditingController _chatIdController;

  bool _isTesting = false;
  bool _isInputChanged = false;
  bool _isBotTokenCorrect = false;
  bool? _testResult;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _botTokenController = TextEditingController(text: appState.botToken);
    _chatIdController = TextEditingController(text: appState.chatId);
    _isBotTokenCorrect = validateBotToken(_botTokenController.text);
  }

  @override
  void dispose() {
    _botTokenController.dispose();
    _chatIdController.dispose();
    super.dispose();
  }

  bool validateBotToken(String value) {
    final regex = RegExp(r'^[0-9]{8,10}:[a-zA-Z0-9_-]{35}$');
    return regex.hasMatch(value);
  }

  Future<void> _testAndSaveSettings() async {
    setState(() { _isTesting = true; _testResult = null; });
    FocusManager.instance.primaryFocus?.unfocus();

    final appState = context.read<AppState>();
    String testBotToken = _botTokenController.text;
    String testChatId = _chatIdController.text;
    String testDeviceLabel = appState.deviceLabel ?? '';

    // Important: Obtain the localization string BEFORE any asynchronous calls
    final l10n = AppLocalizations.of(context);
    final String defaultHello = l10n?.sms_hello ?? '=^•⩊•^=';

    try {
      if (testChatId.isEmpty) testChatId = await getUpdates(testBotToken);

      if (testChatId.isNotEmpty) {
        String helloMessage = defaultHello;
        if (testDeviceLabel.isNotEmpty) helloMessage = '$helloMessage <i>($testDeviceLabel)</i>';

        final result = await sendMessage(testBotToken, testChatId, helloMessage);

        if (result) {
          await appState.updateConnectionData(testBotToken, testChatId);
          if (mounted) {
            setState(() { 
              _testResult = true; 
              _chatIdController.text = testChatId; 
              _isInputChanged = false; 
            });
          }
          return;
        }
      }

      // If we get here, either chatId is empty or sendMessage returned false
      if (mounted) {
        setState(() { _testResult = false; });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _testResult = false; });
      }
    } finally {
      // Ensure that the loader will be turned off in any case (even if there is an exception)
      if (mounted) {
        setState(() { _isTesting = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children:[
                const SizedBox(height: 5),

                TextField(
                  controller: _botTokenController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.telebot_token,
                    helperText: AppLocalizations.of(context)!.telebot_tokenInfo,
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
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.telebot_chatId,
                    helperText: AppLocalizations.of(context)!.telebot_chatIdInfo,
                    helperMaxLines: 2,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                  inputFormatters:[FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*$'))],
                  onChanged: (String value) {
                    setState(() { _testResult = null; _isInputChanged = true; });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ActionButton(
            label: AppLocalizations.of(context)!.action_testAndSave,
            onPressed: _isTesting || !_isInputChanged || !_isBotTokenCorrect ? null : _testAndSaveSettings,
            isSuccess: _testResult,
            isInProgress: _isTesting,
          ),
        ],
      ),
    );
  }
}