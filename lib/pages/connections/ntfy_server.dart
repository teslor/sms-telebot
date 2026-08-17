import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../extensions/build_context_x.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../constants.dart';
import '../../styles.dart';
import '../../state.dart';
import '../../service.dart';
import '../../widgets/action_button.dart';

class NtfyServerConnection extends StatefulWidget {
  const NtfyServerConnection({super.key});

  @override
  State<NtfyServerConnection> createState() => _NtfyServerConnectionState();
}

class _NtfyServerConnectionState extends State<NtfyServerConnection> {
  late TextEditingController _topicController;
  late TextEditingController _tokenController;
  late TextEditingController _serverUrlController;

  bool _isTesting = false;
  bool _isInputChanged = false;
  bool? _testResult;
  bool? _saveResult;
  int _priority = 3;

  static final _topicRegex = RegExp(r'^[-_A-Za-z0-9]{1,64}$');

  @override
  void initState() {
    super.initState();
    final config = context.read<AppState>().config;
    _topicController = TextEditingController(text: config['topic']?.toString() ?? '');
    _tokenController = TextEditingController(text: config['token']?.toString() ?? '');
    _serverUrlController = TextEditingController(text: config['serverUrl']?.toString() ?? '');
    _priority = config['priority'] ?? 3;
  }

  @override
  void dispose() {
    _topicController.dispose();
    _tokenController.dispose();
    _serverUrlController.dispose();
    super.dispose();
  }

  bool get _isValidTopic => _topicRegex.hasMatch(_topicController.text.trim());

  bool get _isValidUrl {
    final serverUrl = _serverUrlController.text.trim();
    return serverUrl.isEmpty ||
      (Uri.tryParse(serverUrl) != null &&
      (serverUrl.startsWith('http://') || serverUrl.startsWith('https://')));
  }

  Map<String, dynamic> _buildConfig() {
    String serverUrl = _serverUrlController.text.trim();
    if (serverUrl.endsWith('/')) serverUrl = serverUrl.substring(0, serverUrl.length - 1);

    return {
      if (_priority != 3) 'priority': _priority,
      if (serverUrl.isNotEmpty) 'serverUrl': serverUrl,
    };
  }

  String _buildSecret() {
    final token = _tokenController.text.trim();
    return jsonEncode({
      'topic': _topicController.text.trim(),
      if (token.isNotEmpty) 'token': token,
    });
  }

  Future<void> _testConnection(AppLocalizations l10n) async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    if (!_isValidTopic || !_isValidUrl) {
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
        provider: ProviderId.ntfy,
        config: _buildConfig(),
        secret: _buildSecret(),
        body: l10n.msg_hello,
        deviceLabel: appState.deviceLabel,
      );

      if (!mounted) return;
      if (result.isSuccess) {
        setState(() => _testResult = true);
      } else {
        setState(() => _testResult = false);
        context.showErrorSnack(getLocalizedError(l10n, result.code));
      }
    } catch (_) {
      if (mounted) {
        setState(() => _testResult = false);
        context.showErrorSnack(getLocalizedError(l10n, 'unexpected_error'));
      }
    } finally {
      if (mounted) setState(() => _isTesting = false);
    }
  }

  Future<void> _saveConnection(AppLocalizations l10n) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_isValidTopic || !_isValidUrl) {
      setState(() => _saveResult = false);
      context.showErrorSnack(getLocalizedError(l10n, 'invalid_params'));
      return;
    }

    final appState = context.read<AppState>();

    try {
      final result = await appState.updateRuleConfig(_buildConfig(), _buildSecret());
      if (!mounted) return;

      if (result.isSuccess) {
        setState(() {
          _saveResult = true;
          _isInputChanged = false;
        });
      } else {
        setState(() => _saveResult = false);
        context.showErrorSnack(getLocalizedError(l10n, result.code));
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saveResult = false);
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
    final priorityOptions = <(int, String)>[
      (5, l10n.ntfy_priority_05),
      (4, l10n.ntfy_priority_04),
      (3, l10n.ntfy_priority_03),
      (2, l10n.ntfy_priority_02),
      (1, l10n.ntfy_priority_01),
    ];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        children: [
          TextField(
            controller: _topicController,
            decoration: CustomStyle.compactInput(labelText: l10n.ntfy_topic),
            onChanged: _onChanged,
          ),
          const SizedBox(height: 16),
          DropdownMenu<int>(
            initialSelection: _priority,
            expandedInsets: EdgeInsets.zero,
            label: Text(l10n.ntfy_priority),
            inputDecorationTheme: CustomStyle.compactDropdown,
            dropdownMenuEntries: priorityOptions
              .map((option) => DropdownMenuEntry<int>(
                value: option.$1,
                label: option.$2,
                style: CustomStyle.compactDropdownItem,
              ))
              .toList(growable: false),
            onSelected: (value) {
              if (value == null || value == _priority) return;
              setState(() => _priority = value);
              _onChanged();
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tokenController,
            decoration: CustomStyle.compactInput(
              labelText: l10n.ntfy_token,
              helperText: l10n.ntfy_tokenInfo,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: _onChanged,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _serverUrlController,
            keyboardType: TextInputType.url,
            decoration: CustomStyle.compactInput(
              labelText: l10n.ntfy_server,
              helperText: l10n.ntfy_serverInfo(ntfyUrl),
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
              onPressed: _isTesting || _topicController.text.trim().isEmpty
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
              onPressed: !_isInputChanged || _topicController.text.trim().isEmpty
                ? null
                : () => _saveConnection(l10n),
              isSuccess: _saveResult,
              layout: 'half-2',
            ),
          ),
        ],
      ),
    );
  }
}
