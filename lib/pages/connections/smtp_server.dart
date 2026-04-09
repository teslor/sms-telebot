import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../extensions/build_context_x.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../state.dart';
import '../../service.dart';
import '../../widgets/action_button.dart';

class SmtpServerConnection extends StatefulWidget {
  const SmtpServerConnection({super.key});

  @override
  State<SmtpServerConnection> createState() => _SmtpServerConnectionState();
}

class _SmtpServerConnectionState extends State<SmtpServerConnection> {
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _loginController;
  late TextEditingController _passwordController;
  late TextEditingController _fromEmailController;
  late TextEditingController _toEmailController;
  late TextEditingController _subjectController;

  bool _isTesting = false;
  bool _isInputChanged = false;
  bool? _testResult;
  bool? _saveResult;
  bool _isPasswordVisible = false;
  bool _isPortManuallyEdited = false;
  String _protocol = 'starttls';

  @override
  void initState() {
    super.initState();
    final config = context.read<AppState>().config;
    _hostController = TextEditingController(text: config['host']?.toString() ?? '');
    _portController = TextEditingController(text: (config['port'] ?? 587).toString());
    _loginController = TextEditingController(text: config['login']?.toString() ?? '');
    _passwordController = TextEditingController(text: config['password']?.toString() ?? '');
    _fromEmailController = TextEditingController(text: config['fromEmail']?.toString() ?? '');
    _toEmailController = TextEditingController(text: config['toEmail']?.toString() ?? '');
    _subjectController = TextEditingController(text: config['subject']?.toString() ?? '');

    _protocol = _normalizeProtocol(config['protocol']);
    final initialPort = _parsePort(_portController.text.trim());
    _isPortManuallyEdited =
      initialPort != null && initialPort != _defaultPort(_protocol);
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    _fromEmailController.dispose();
    _toEmailController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  String _normalizeProtocol(String? rawValue) {
    return (['starttls', 'ssl', 'none'].contains(rawValue)) ? rawValue! : 'starttls';
  }

  int _defaultPort(String protocol) {
    return switch (protocol) {
      'starttls' => 587, 'ssl' => 465, 'none' => 25, _ => 587
    };
  }

  int? _parsePort(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 1 || parsed > 65535) return null;
    return parsed;
  }

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(value);
  }

  List<String> _parseRecipientEmails(String value) {
    return value
      .split(RegExp(r'[;,]'))
      .map((email) => email.trim())
      .where((email) => email.isNotEmpty)
      .toList();
  }

  bool _isValidRecipientEmails(String value) {
    final recipients = _parseRecipientEmails(value);
    if (recipients.isEmpty) return false;
    return recipients.every(_isValidEmail);
  }

  bool get _isValidInputs {
    final host = _hostController.text.trim();
    final port = _parsePort(_portController.text.trim());
    final login = _loginController.text.trim();
    final password = _passwordController.text;
    final fromEmail = _fromEmailController.text.trim();
    final toEmail = _toEmailController.text;

    if (host.isEmpty || port == null || login.isEmpty || password.isEmpty) return false;
    if (fromEmail.isNotEmpty && !_isValidEmail(fromEmail)) return false;
    if (!_isValidRecipientEmails(toEmail)) return false;
    return true;
  }

  Map<String, dynamic> _buildConfig() {
    return {
      'host': _hostController.text.trim(),
      'protocol': _protocol,
      'port': _parsePort(_portController.text.trim()),
      'login': _loginController.text.trim(),
      'fromEmail': _fromEmailController.text.trim(),
      'toEmail': _parseRecipientEmails(_toEmailController.text).join(', '),
      'subject': _subjectController.text.trim(),
    };
  }

  Future<void> _testConnection(AppLocalizations l10n) async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _isTesting = true;
      _testResult = null;
    });
    if (!_isValidInputs) {
      setState(() {
        _isTesting = false;
        _testResult = false;
        context.showErrorSnack(getLocalizedError(l10n, 'invalid_params'));
      });
      return;
    }

    final appState = context.read<AppState>();
    final config = _buildConfig();

    try {
      final result = await sendToProviderNative(
        provider: 'smtp_server',
        config: config,
        secret: _passwordController.text,
        body: l10n.sms_hello,
        deviceLabel: appState.deviceLabel,
      );

      if (result.isSuccess) {
        if (mounted) {
          setState(() { _testResult = true; });
        }
      } else {
        if (mounted) {
          setState(() { _testResult = false; });
          context.showErrorSnack(getLocalizedError(l10n, result.code, 'smtp_server'));
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

    if (!_isValidInputs) {
      setState(() {
        _saveResult = false;
        context.showErrorSnack(getLocalizedError(l10n, 'invalid_params'));
      });
      return;
    }

    final appState = context.read<AppState>();
    final config = _buildConfig();
    final secret = _passwordController.text;
    try {
      final result = await appState.updateRuleConfig(config, secret);
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

  void _onChanged([String _ = '']) {
    setState(() {
      _testResult = null;
      _saveResult = null;
      _isInputChanged = true;
    });
  }

  void _onPortChanged(String value) {
    final parsedPort = _parsePort(value.trim());
    setState(() {
      _testResult = null;
      _saveResult = null;
      _isInputChanged = true;
      if (value.trim().isEmpty) {
        _isPortManuallyEdited = false;
      } else {
        _isPortManuallyEdited = parsedPort != _defaultPort(_protocol);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dropdownTextStyle = Theme.of(context)
      .textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        children: [
          const SizedBox(height: 5),
          TextField(
            controller: _hostController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.smtp_host,
            ),
            onChanged: _onChanged,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _protocol,
            style: dropdownTextStyle,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.smtp_protocol,
            ),
            items: [
              DropdownMenuItem(
                value: 'starttls',
                child: Text('STARTTLS', style: dropdownTextStyle),
              ),
              DropdownMenuItem(
                value: 'ssl',
                child: Text('SSL/TLS', style: dropdownTextStyle),
              ),
              DropdownMenuItem(
                value: 'none',
                child: Text(l10n.smtp_protocolEmpty, style: dropdownTextStyle),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _protocol = value;
                if (!_isPortManuallyEdited) {
                  _portController.text = _defaultPort(value).toString();
                }
                _testResult = null;
                _saveResult = null;
                _isInputChanged = true;
              });
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _portController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.smtp_port,
            ),
            onChanged: _onPortChanged,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _loginController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.smtp_login,
              helperText: l10n.smtp_loginInfo,
            ),
            onChanged: _onChanged,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.smtp_password,
              helperText: l10n.smtp_passwordInfo,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() { _isPasswordVisible = !_isPasswordVisible; });
                },
              ),
            ),
            onChanged: _onChanged,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _fromEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.smtp_fromEmail,
              helperText: l10n.smtp_fromEmailInfo,
            ),
            onChanged: _onChanged,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _toEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.smtp_toEmail,
              helperText: l10n.smtp_toEmailInfo,
            ),
            onChanged: _onChanged,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.smtp_subject,
              helperText: l10n.smtp_subjectInfo,
            ),
            onChanged: _onChanged,
          ),
        ],
      ),

      bottomNavigationBar: Row(
        children:[
          Expanded(
            child: ActionButton(
              label: l10n.action_test,
              onPressed: _isTesting || !_isValidInputs ? null : () => _testConnection(l10n),
              isSuccess: _testResult,
              isInProgress: _isTesting,
              layout: 'half-1',
            ),
          ),
          Expanded(
            child: ActionButton(
              label: l10n.action_save,
              onPressed: !_isInputChanged || !_isValidInputs ? null : () => _saveConnection(l10n),
              isSuccess: _saveResult,
              layout: 'half-2',
            ),
          )
        ],
      ),
    );
  }
}
