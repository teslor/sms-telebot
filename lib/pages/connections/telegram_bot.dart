import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../state.dart';
import '../../service.dart';
import '../../widgets/action_button.dart';

class TelegramBotConnection extends StatefulWidget {
  const TelegramBotConnection({super.key});

  @override
  State<TelegramBotConnection> createState() => _TelegramBotConnectionState();
}

class _TelegramBotConnectionState extends State<TelegramBotConnection> {
  late TextEditingController _botTokenController;
  late TextEditingController _chatIdController;

  bool _isSaving = false;
  bool _isInputChanged = false;
  bool _isBotTokenCorrect = false;
  bool? _saveResult;

  void _showErrorMessage(String message) {
    if (message.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    final config = context.read<AppState>().config;
    _botTokenController = TextEditingController(text: config['botToken'] ?? '');
    _chatIdController = TextEditingController(text: config['chatId']?.toString() ?? '');
    _isBotTokenCorrect = _validateBotToken(_botTokenController.text);
  }

  @override
  void dispose() {
    _botTokenController.dispose();
    _chatIdController.dispose();
    super.dispose();
  }

  bool _validateBotToken(String value) {
    final regex = RegExp(r'^[0-9]{8,10}:[a-zA-Z0-9_-]{35}$');
    return regex.hasMatch(value);
  }

  Future<void> _testAndSaveSettings(AppLocalizations l10n) async {
    setState(() { _isSaving = true; _saveResult = null; });
    FocusManager.instance.primaryFocus?.unfocus();

    final appState = context.read<AppState>();
    String testBotToken = _botTokenController.text;
    String testChatId = _chatIdController.text;

    final String helloMessage = AppLocalizations.of(context)?.sms_hello ?? '=^•⩊•^=';

    try {
      if (testChatId.isEmpty) {
        final result = await getUpdates(testBotToken);
        if (result.chatId != null) {
          testChatId = result.chatId!;
        } else {
          _showErrorMessage(getLocalizedError(l10n, result.code, 'telegram_bot'));
          return;
        }
      }

      final result = await sendToProviderNative(
        provider: 'telegram_bot',
        config: { 'botToken': testBotToken,'chatId': testChatId },
        body: helloMessage,
        deviceLabel: appState.deviceLabel,
      );

      if (result.isSuccess) {
        await appState.updateConnectionData({ 'botToken': testBotToken, 'chatId': testChatId });
        if (mounted) {
          setState(() { 
            _saveResult = true; 
            _chatIdController.text = testChatId; 
            _isInputChanged = false; 
          });
        }
        return;
      }

      if (mounted) {
        setState(() { _saveResult = false; });
        _showErrorMessage(getLocalizedError(l10n, result.code, 'telegram_bot'));
      }
    } catch (e) {
      if (mounted) {
        setState(() { _saveResult = false; });
        _showErrorMessage(getLocalizedError(l10n, 'unexpected_error'));
      }
    } finally {
      if (mounted) setState(() { _isSaving = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
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
              setState(() { _saveResult = null; _isInputChanged = true; _isBotTokenCorrect = _validateBotToken(value); });
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
              setState(() { _saveResult = null; _isInputChanged = true; });
            },
          ),
        ],
      ),

      bottomNavigationBar: ActionButton(
        label: AppLocalizations.of(context)!.action_testAndSave,
        onPressed: _isSaving || !_isInputChanged || !_isBotTokenCorrect
          ? null
          : () => _testAndSaveSettings(AppLocalizations.of(context)!),
        isSuccess: _saveResult,
        isInProgress: _isSaving,
      ),
    );
  }
}
