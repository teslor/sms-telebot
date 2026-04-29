import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../state.dart';
import '../service.dart';
import '../widgets/action_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _deviceLabelController;

  bool _forwardSms = false;
  bool _forwardCalls = false;
  bool _notifyLowBattery = false;
  bool _notifyChargerState = false;
  bool _enableForeground = false;

  bool _isInputChanged = false;
  bool? _saveResult;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    
    _deviceLabelController = TextEditingController(text: appState.deviceLabel);
    _forwardSms = appState.forwardSms;
    _forwardCalls = appState.forwardCalls;
    _notifyLowBattery = appState.notifyLowBattery;
    _notifyChargerState = appState.notifyChargerState;
    _enableForeground = appState.enableForeground;
  }

  @override
  void dispose() {
    _deviceLabelController.dispose();
    super.dispose();
  }

  void _onSettingChanged() {
    setState(() {
      _saveResult = null;
      _isInputChanged = true;
    });
  }

  Future<void> _saveSettings() async {
    final appState = context.read<AppState>();
    FocusManager.instance.primaryFocus?.unfocus();

    await appState.updateSettings(
      forwardSms: _forwardSms,
      forwardCalls: _forwardCalls,
      notifyLowBattery: _notifyLowBattery,
      notifyChargerState: _notifyChargerState,
      enableForeground: _enableForeground,
      deviceLabel: _deviceLabelController.text,
    );

    if (mounted) {
      setState(() { 
        _saveResult = true; 
        _isInputChanged = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 8),
            child: Text(
              l10n.settings_forwardEvents,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.settings_forwardSms),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  value: _forwardSms,
                  onChanged: (bool value) async {
                    if (value && !await getSmsPermission(openSettings: true)) return;
                    _forwardSms = value;
                    _onSettingChanged();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l10n.settings_forwardCalls),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  value: _forwardCalls,
                  onChanged: (bool value) async {
                    if (value && !await getPhonePermission(openSettings: true)) return;
                    _forwardCalls = value;
                    _onSettingChanged();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l10n.settings_notifyLowBattery),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  value: _notifyLowBattery,
                  onChanged: (bool value) {
                    _notifyLowBattery = value;
                    _onSettingChanged();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l10n.settings_notifyChargerState),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  value: _notifyChargerState,
                  onChanged: (bool value) {
                    _notifyChargerState = value;
                    _onSettingChanged();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: SwitchListTile(
              title: Text(l10n.settings_enableForeground),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              value: _enableForeground,
              onChanged: (bool value) async {
                if (value && !await getNotificationPermission(openSettings: true)) return;
                _enableForeground = value;
                _onSettingChanged();
              },
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: _deviceLabelController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.settings_deviceLabel,
              helperText: l10n.settings_deviceLabelInfo,
              helperMaxLines: 2,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: (String value) => _onSettingChanged(),
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
