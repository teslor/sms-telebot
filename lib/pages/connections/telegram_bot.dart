import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../extensions/build_context_x.dart';
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
  late TextEditingController _tokenController;
  late TextEditingController _chatIdController;

  bool _isTesting = false;
  bool _isInputChanged = false;
  bool? _testResult;
  bool? _saveResult;

  @override
  void initState() {
    super.initState();
    final config = context.read<AppState>().config;
    _tokenController = TextEditingController(text: config['token'] ?? '');
    _chatIdController = TextEditingController(text: config['chatId']?.toString() ?? '');
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _chatIdController.dispose();
    super.dispose();
  }

  static final _tokenRegex = RegExp(r'^[0-9]{8,10}:[a-zA-Z0-9_-]{35}$');
  bool get _isValidToken => _tokenRegex.hasMatch(_tokenController.text);
  bool get _isValidChatId => int.tryParse(_chatIdController.text.trim()) != null;

  Future<void> _testConnection(AppLocalizations l10n) async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _isTesting = true;
      _testResult = null;
    });
    if (!_isValidToken) {
      setState(() {
        _isTesting = false;
        _testResult = false;
        context.showErrorSnack(getLocalizedError(l10n, 'invalid_params'));
      });
      return;
    }

    final appState = context.read<AppState>();
    final token = _tokenController.text;
    String chatId = _chatIdController.text;
    final String helloMessage = l10n.sms_hello;

    try {
      if (chatId.isEmpty) {
        final result = await getUpdates(token);
        if (result.isSuccess) {
          chatId = result.data!;
          _chatIdController.text = chatId;
        } else {
          if (mounted) {
            setState(() { _testResult = false; });
            context.showErrorSnack(getLocalizedError(l10n, result.code, 'telegram_bot'));
            return;
          }
        }
      }

      final result = await sendToProviderNative(
        provider: 'telegram_bot',
        config: { 'chatId': chatId },
        secret: token,
        body: helloMessage,
        deviceLabel: appState.deviceLabel,
      );

      if (result.isSuccess) {
        if (mounted) {
          setState(() { _testResult = true; });
        }
      } else {
        if (mounted) {
          setState(() { _testResult = false; });
          context.showErrorSnack(getLocalizedError(l10n, result.code, 'telegram_bot'));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() { _testResult = false; });
        context.showErrorSnack(getLocalizedError(l10n, 'unexpected_error'));
      }
    } finally {
      if (mounted) setState(() { _isTesting = false; });
    }
  }

  Future<void> _saveConnection(AppLocalizations l10n) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(_isValidToken && _isValidChatId)) {
      setState(() {
        _saveResult = false;
        context.showErrorSnack(getLocalizedError(l10n, 'invalid_params'));
      });
      return;
    }

    final appState = context.read<AppState>();
    final secret = _tokenController.text;
    try {
      final result = await appState.updateRuleConfig({'chatId': _chatIdController.text.trim()}, secret);
      if (!mounted) return;
      if (!result.isSuccess) {
        setState(() { _saveResult = false; });
        context.showErrorSnack(getLocalizedError(l10n, result.code));
        return;
      }
      setState(() {
        _saveResult = true;
        _isInputChanged = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() { _saveResult = false; });
        context.showErrorSnack(getLocalizedError(l10n, 'unexpected_error'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        children:[
          const SizedBox(height: 5),
          TextField(
            controller: _tokenController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.tbot_token,
              helperText: l10n.tbot_tokenInfo,
              helperMaxLines: 2,
            ),
            onChanged: (String value) {
              setState(() { _saveResult = null; _isInputChanged = true; });
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _chatIdController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.tbot_chatId,
              helperText: l10n.tbot_chatIdInfo,
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

      bottomNavigationBar: Row(
        children:[
          Expanded(
            child: ActionButton(
              label: l10n.action_test,
              onPressed: _isTesting || !_isValidToken
                  ? null
                  : () => _testConnection(l10n),
              isSuccess: _testResult,
              isInProgress: _isTesting,
              layout: 'half-1',
            ),
          ),
          Expanded(
            child: ActionButton(
              label: l10n.action_save,
              onPressed: !_isInputChanged || !(_isValidToken && _isValidChatId)
                  ? null
                  : () => _saveConnection(l10n),
              isSuccess: _saveResult,
              layout: 'half-2',
            ),
          )
        ],
      ),
    );
  }
}
