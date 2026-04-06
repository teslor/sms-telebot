import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../state.dart';
import '../widgets/action_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _deviceLabelController;
  bool _isInputChanged = false;
  bool? _saveResult;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _deviceLabelController = TextEditingController(text: appState.deviceLabel);
  }

  @override
  void dispose() {
    _deviceLabelController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final appState = context.read<AppState>();
    FocusManager.instance.primaryFocus?.unfocus();
    await appState.updateDeviceLabel(_deviceLabelController.text);
    if (mounted) {
      setState(() { _saveResult = true; _isInputChanged = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        children: [
          const SizedBox(height: 5),
          TextField(
            controller: _deviceLabelController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.settings_deviceLabel,
              helperText: l10n.settings_deviceLabelInfo,
              helperMaxLines: 2,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: (String value) {
              setState(() { _saveResult = null; _isInputChanged = true; });
            },
          ),
        ],
      ),

      bottomNavigationBar: ActionButton(
        label: l10n.action_save,
        onPressed: !_isInputChanged ? null : _saveSettings,
        isSuccess: _saveResult,
      ),
    );
  }
}
