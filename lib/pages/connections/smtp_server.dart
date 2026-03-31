import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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

  bool _isSaving = false;
  bool _isInputChanged = false;
  bool? _saveResult;
  bool _isPasswordVisible = false;
  bool _isPortManuallyEdited = false;
  String _protocol = 'starttls';

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
      initialPort != null && initialPort != _defaultPortForProtocol(_protocol);
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
    if (rawValue == 'starttls' || rawValue == 'ssl' || rawValue == 'none') {
      return rawValue!;
    }
    return 'starttls';
  }

  int _defaultPortForProtocol(String protocol) {
    switch (protocol) {
      case 'starttls': return 587;
      case 'ssl': return 465;
      case 'none': return 25;
      default: return 587;
    }
  }

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(value);
  }

  int? _parsePort(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 1 || parsed > 65535) return null;
    return parsed;
  }

  bool get _isFormValid {
    final host = _hostController.text.trim();
    final port = _parsePort(_portController.text.trim());
    final login = _loginController.text.trim();
    final password = _passwordController.text;
    final toEmail = _toEmailController.text.trim();

    if (host.isEmpty || port == null || login.isEmpty || password.isEmpty) return false;
    if (toEmail.isEmpty || !_isValidEmail(toEmail)) return false;
    return true;
  }

  Future<void> _testAndSaveSettings(AppLocalizations l10n) async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isSaving = true;
      _saveResult = null;
    });

    final host = _hostController.text.trim();
    final port = _parsePort(_portController.text.trim());
    final login = _loginController.text.trim();
    final password = _passwordController.text;
    final fromEmail = _fromEmailController.text.trim();
    final toEmail = _toEmailController.text.trim();
    final subject = _subjectController.text.trim();

    if (host.isEmpty || port == null || login.isEmpty || password.isEmpty ||
        toEmail.isEmpty || !_isValidEmail(toEmail) ||
        (fromEmail.isNotEmpty && !_isValidEmail(fromEmail))) {
      if (mounted) {
        setState(() {
          _saveResult = false;
          _isSaving = false;
          _showErrorMessage(getLocalizedError(l10n, 'invalid_params'));
        });
      }
      return;
    }

    final appState = context.read<AppState>();
    final String helloMessage = AppLocalizations.of(context)?.sms_hello ?? '=^•⩊•^=';

    try {
      final config = {
        'host': host,
        'protocol': _protocol,
        'port': port,
        'login': login,
        'password': password,
        'fromEmail': fromEmail,
        'toEmail': toEmail,
        'subject': subject,
      };

      final result = await sendToProviderNative(
        provider: 'smtp_server',
        config: config,
        body: helloMessage,
        deviceLabel: appState.deviceLabel,
      );

      if (result.isSuccess) {
        await appState.updateConnectionData(config);

        if (mounted) {
          setState(() {
            _saveResult = true;
            _isInputChanged = false;
          });
        }
      } else {
        if (mounted) {
          setState(() { _saveResult = false; });
          _showErrorMessage(getLocalizedError(l10n, result.code, 'smtp_server'));
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() { _saveResult = false; });
        _showErrorMessage(getLocalizedError(l10n, 'unexpected_error'));
      }
    } finally {
      if (mounted) setState(() { _isSaving = false; });
    }
  }

  void _onChanged([String _ = '']) {
    setState(() {
      _saveResult = null;
      _isInputChanged = true;
    });
  }

  void _onPortChanged(String value) {
    final parsedPort = _parsePort(value.trim());
    setState(() {
      _saveResult = null;
      _isInputChanged = true;
      if (value.trim().isEmpty) {
        _isPortManuallyEdited = false;
      } else {
        _isPortManuallyEdited = parsedPort != _defaultPortForProtocol(_protocol);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dropdownTextStyle = Theme.of(context)
      .textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 5),
          TextField(
            controller: _hostController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.smtp_host,
            ),
            onChanged: _onChanged,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _protocol,
            style: dropdownTextStyle,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.smtp_protocol,
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
                child: Text(AppLocalizations.of(context)!.smtp_protocolEmpty, style: dropdownTextStyle),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _protocol = value;
                if (!_isPortManuallyEdited) {
                  _portController.text =
                      _defaultPortForProtocol(value).toString();
                }
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
              labelText: AppLocalizations.of(context)!.smtp_port,
            ),
            onChanged: _onPortChanged,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _loginController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.smtp_login,
              helperText: AppLocalizations.of(context)!.smtp_loginInfo,
            ),
            onChanged: _onChanged,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.smtp_password,
              helperText: AppLocalizations.of(context)!.smtp_passwordInfo,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
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
              labelText: AppLocalizations.of(context)!.smtp_fromEmail,
              helperText: AppLocalizations.of(context)!.smtp_fromEmailInfo,
            ),
            onChanged: _onChanged,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _toEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.smtp_toEmail,
              helperText: AppLocalizations.of(context)!.smtp_toEmailInfo,
            ),
            onChanged: _onChanged,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.smtp_subject,
              helperText: AppLocalizations.of(context)!.smtp_subjectInfo,
            ),
            onChanged: _onChanged,
          ),
        ],
      ),

      bottomNavigationBar: ActionButton(
        label: AppLocalizations.of(context)!.action_testAndSave,
        onPressed: _isSaving || !_isInputChanged || !_isFormValid
          ? null
          : () => _testAndSaveSettings(AppLocalizations.of(context)!),
        isSuccess: _saveResult,
        isInProgress: _isSaving,
      ),
    );
  }
}
