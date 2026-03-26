import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../state.dart';
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

  @override
  void initState() {
    super.initState();
    final config = context.read<AppState>().config;
    _hostController = TextEditingController(
      text: config['host']?.toString() ?? '',
    );
    _portController = TextEditingController(
      text: (config['port'] ?? 587).toString(),
    );
    _loginController = TextEditingController(
      text: config['login']?.toString() ?? '',
    );
    _passwordController = TextEditingController(
      text: config['password']?.toString() ?? '',
    );
    _fromEmailController = TextEditingController(
      text: config['fromEmail']?.toString() ?? '',
    );
    _toEmailController = TextEditingController(
      text: config['toEmail']?.toString() ?? '',
    );
    _subjectController = TextEditingController(
      text: config['subject']?.toString() ?? '',
    );
    _protocol = _normalizeProtocol(config['protocol']?.toString());
    final initialPort = _parsePort(_portController.text.trim());
    _isPortManuallyEdited =
        initialPort != null &&
        initialPort != _defaultPortForProtocol(_protocol);
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
    if (rawValue == 'none' || rawValue == 'ssl' || rawValue == 'starttls') {
      return rawValue!;
    }
    return 'starttls';
  }

  int _defaultPortForProtocol(String protocol) {
    switch (protocol) {
      case 'ssl':
        return 465;
      case 'none':
        return 25;
      case 'starttls':
      default:
        return 587;
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

  Future<void> _testAndSaveSettings() async {
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

    if (host.isEmpty ||
        login.isEmpty ||
        password.isEmpty ||
        port == null ||
        subject.isEmpty ||
        toEmail.isEmpty ||
        !_isValidEmail(toEmail) ||
        (fromEmail.isNotEmpty && !_isValidEmail(fromEmail))) {
      if (mounted) {
        setState(() {
          _saveResult = false;
          _isSaving = false;
        });
      }
      return;
    }

    try {
      await context.read<AppState>().updateConnectionData({
        'host': host,
        'protocol': _protocol,
        'port': port,
        'login': login,
        'password': password,
        'fromEmail': fromEmail,
        'toEmail': toEmail,
        'subject': subject,
      });

      if (mounted) {
        setState(() {
          _saveResult = true;
          _isInputChanged = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saveResult = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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
        _isPortManuallyEdited =
            parsedPort != _defaultPortForProtocol(_protocol);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dropdownTextStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 5),
                TextField(
                  controller: _hostController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'SMTP host',
                  ),
                  onChanged: _onChanged,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _protocol,
                  style: dropdownTextStyle,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Protocol',
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
                      child: Text('None', style: dropdownTextStyle),
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Port',
                    helperText:
                        'Auto: 587 (STARTTLS), 465 (SSL/TLS), 25 (None)',
                  ),
                  onChanged: _onPortChanged,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _loginController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Login',
                    helperText: 'Usually full email address',
                  ),
                  onChanged: _onChanged,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    helperText: 'Usually password for external apps',
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'From email',
                    helperText: 'Leave empty to use login as sender',
                  ),
                  onChanged: _onChanged,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _toEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'To email',
                    helperText: 'Recipient email address',
                  ),
                  onChanged: _onChanged,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Subject',
                    helperText: 'Email subject (optional)',
                  ),
                  onChanged: _onChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ActionButton(
            label: 'Test and Save',
            onPressed:
                _isSaving || !_isInputChanged || !_isFormValid
                    ? null
                    : _testAndSaveSettings,
            isSuccess: _saveResult,
            isInProgress: _isSaving,
          ),
        ],
      ),
    );
  }
}
