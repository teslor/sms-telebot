import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../extensions/build_context_x.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../styles.dart';
import '../../state.dart';
import '../../service.dart';
import '../../widgets/action_button.dart';

class SmsGatewayConnection extends StatefulWidget {
  const SmsGatewayConnection({super.key});

  @override
  State<SmsGatewayConnection> createState() => _SmsGatewayConnectionState();
}

class _SmsGatewayConnectionState extends State<SmsGatewayConnection> {
  late TextEditingController _numberController;

  bool _isTesting = false;
  bool _isInputChanged = false;
  bool? _testResult;
  bool? _saveResult;

  static final _phoneRegex = RegExp(r'^\+?[0-9]{2,20}$');

  @override
  void initState() {
    super.initState();
    final config = context.read<AppState>().config;
    _numberController = TextEditingController(text: config['number']?.toString() ?? '');
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  bool get _isValidPhone => _phoneRegex.hasMatch(_numberController.text.trim());

  Future<void> _testConnection(AppLocalizations l10n) async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    if (!_isValidPhone) {
      setState(() {
        _isTesting = false;
        _testResult = false;
      });
      context.showErrorSnack(getLocalizedError(l10n, 'invalid_params'));
      return;
    }

    final appState = context.read<AppState>();

    try {
      final result = await sendToProviderNative(
        provider: 'sms_gateway',
        config: {'number': _numberController.text.trim()},
        body: l10n.msg_hello,
        deviceLabel: appState.deviceLabel,
      );

      if (result.isSuccess) {
        if (mounted) {
          setState(() { _testResult = true; });
        }
      } else {
        if (mounted) {
          setState(() { _testResult = false; });
          context.showErrorSnack(getLocalizedError(l10n, result.code));
        }
      }
    } catch (_) {
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

    if (!_isValidPhone) {
      setState(() { _saveResult = false; });
      context.showErrorSnack(getLocalizedError(l10n, 'invalid_params'));
      return;
    }

    final appState = context.read<AppState>();
    final config = {'number': _numberController.text.trim()};

    try {
      final result = await appState.updateRuleConfig(config, null);
      if (!mounted) return;

      if (result.isSuccess) {
        setState(() {
          _saveResult = true;
          _isInputChanged = false;
        });
      } else {
        setState(() { _saveResult = false; });
        context.showErrorSnack(getLocalizedError(l10n, result.code));
      }
    } catch (_) {
      if (mounted) {
        setState(() { _saveResult = false; });
        context.showErrorSnack(getLocalizedError(l10n, 'unexpected_error'));
      }
    }
  }

  void _onChanged([String _ = '']) {
    setState(() {
      _testResult = null;
      _saveResult = null;
      _isInputChanged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        children: [
          TextField(
            controller: _numberController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                return RegExp(r'^\+?[0-9]*$').hasMatch(newValue.text) ? newValue : oldValue;
              }),
            ],
            decoration: CustomStyle.compactInput(
              labelText: l10n.sms_number,
              helperText: l10n.sms_numberInfo,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: _onChanged,
          ),
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: ActionButton(
              label: l10n.action_test,
              onPressed: _isTesting || !_isValidPhone ? null : () => _testConnection(l10n),
              isSuccess: _testResult,
              isInProgress: _isTesting,
              layout: 'half-1',
            ),
          ),
          Expanded(
            child: ActionButton(
              label: l10n.action_save,
              onPressed: !_isInputChanged || !_isValidPhone ? null : () => _saveConnection(l10n),
              isSuccess: _saveResult,
              layout: 'half-2',
            ),
          ),
        ],
      ),
    );
  }
}
