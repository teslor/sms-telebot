import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../extensions/build_context_x.dart';
import '../l10n/generated/app_localizations.dart';
import '../styles.dart';
import '../state.dart';
import '../service.dart';
import '../widgets/action_button.dart';

enum _FormatMenuAction { paste, preview, reset }

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const EdgeInsets _switchTilePadding = EdgeInsets.fromLTRB(13, 0, 10, 1);
  static const TextStyle _switchStyle = TextStyle(height: 1.2);

  late TextEditingController _deviceLabelController;

  bool _forwardSms = false;
  bool _forwardCalls = false;
  bool _notifyLowBattery = false;
  bool _notifyChargerState = false;
  bool _enableForeground = false;
  bool _attachSimInfo = false;
  String _customFormatJson = '';
  String _currentFormatName = '';

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
    _attachSimInfo = appState.attachSimInfo;
    _customFormatJson = appState.customFormatJson;
    _currentFormatName = _getFormatName();
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
      attachSimInfo: _attachSimInfo,
      customFormatJson: _customFormatJson,
      deviceLabel: _deviceLabelController.text,
    );

    if (mounted) {
      setState(() {
        _saveResult = true;
        _isInputChanged = false;
      });
    }
  }

  String _getFormatName() {
    if (_customFormatJson.isEmpty) return '';
    try {
      final parsed = jsonDecode(_customFormatJson);
      if (parsed is Map<String, dynamic>) {
        final name = parsed['name']?.toString().trim() ?? '';
        if (name.isNotEmpty) return name;
      }
    } catch (_) {}
    return '';
  }

  Future<void> _pasteFormat(BuildContext context) async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text ?? '';
    if (text.trim().isEmpty) return;

    try {
      final cleanJson = text.replaceAll(RegExp(r'//.*$', multiLine: true), '');
      final parsed = jsonDecode(cleanJson);
      if (parsed is! Map<String, dynamic>) throw const FormatException();

      final name = parsed['name']?.toString().trim() ?? '';
      final templates = parsed['templates'];
      if (name.isEmpty || templates is! Map<String, dynamic> || templates.isEmpty) {
        throw const FormatException();
      }

      setState(() {
        _customFormatJson = jsonEncode(parsed);
        _currentFormatName = name;
        _saveResult = null;
        _isInputChanged = true;
      });
    } catch (_) {
      if (!context.mounted) return;
      context.showErrorSnack(AppLocalizations.of(context)!.settings_formatError);
    }
  }

  Future<void> _showFormatPreview(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final sets = {
        'customFormatJson': _customFormatJson,
        'deviceLabel': _deviceLabelController.text,
        'l10nSms': l10n.msg_sms,
        'l10nCall': l10n.msg_call,
        'l10nBattery': l10n.msg_battery,
        'l10nLowBattery': l10n.msg_lowBattery,
        'l10nHello': l10n.msg_hello.replaceFirst(RegExp(r'\s*\^.*$'), ''),
      };
      final previews = await previewFormatNative(sets);
      final groupedPreviews = <String, List<Map<String, String>>>{};
      for (final preview in previews) {
        groupedPreviews.putIfAbsent(preview['destination']!, () => []).add(preview);
      }
      if (!context.mounted) return;
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in groupedPreviews.entries) ...[
                  Text(
                    switch (entry.key) {
                      'telegram' => 'Telegram', 'smtp' => 'SMTP', 'sms' => 'SMS',
                      _ => entry.key,
                    },
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: CustomColor.destination(entry.key),
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final preview in entry.value) ...[
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    if (preview['title']!.isNotEmpty) Text(preview['title']!),
                    if (preview['message']!.isNotEmpty) Text(preview['message']!),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 4),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.action_close),
            ),
          ],
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      context.showErrorSnack(l10n.settings_formatError);
    }
  }

  PopupMenuItem<_FormatMenuAction> buildMenuItem(_FormatMenuAction value, IconData icon, String text, {bool enabled = true}) {
    return PopupMenuItem(
      value: value,
      enabled: enabled,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 15), Icon(icon, size: 19, applyTextScaling: true),
          const SizedBox(width: 10), Text(text)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                  title: Text(l10n.settings_forwardSms, style: _switchStyle),
                  contentPadding: _switchTilePadding,
                  value: _forwardSms,
                  onChanged: (bool value) async {
                    if (value && !await getSmsReceivePermission(openSettings: true)) return;
                    _forwardSms = value;
                    _onSettingChanged();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l10n.settings_forwardCalls, style: _switchStyle),
                  contentPadding: _switchTilePadding,
                  value: _forwardCalls,
                  onChanged: (bool value) async {
                    if (value && !await getPhonePermission(openSettings: true)) return;
                    _forwardCalls = value;
                    _onSettingChanged();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l10n.settings_notifyLowBattery, style: _switchStyle),
                  contentPadding: _switchTilePadding,
                  value: _notifyLowBattery,
                  onChanged: (bool value) {
                    _notifyLowBattery = value;
                    _onSettingChanged();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l10n.settings_notifyChargerState, style: _switchStyle),
                  contentPadding: _switchTilePadding,
                  value: _notifyChargerState,
                  onChanged: (bool value) {
                    _notifyChargerState = value;
                    _onSettingChanged();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

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
                  title: Text(l10n.settings_enableForeground, style: _switchStyle),
                  contentPadding: _switchTilePadding,
                  value: _enableForeground,
                  onChanged: (bool value) async {
                    if (value && !await getNotificationPermission(openSettings: true)) return;
                    _enableForeground = value;
                    _onSettingChanged();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l10n.settings_attachSimInfo, style: _switchStyle),
                  contentPadding: _switchTilePadding,
                  value: _attachSimInfo,
                  onChanged: (bool value) async {
                    if (value && !await getSimInfoPermission(openSettings: true)) return;
                    _attachSimInfo = value;
                    _onSettingChanged();
                  },
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 16, 10),
                  child: SizedBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${l10n.settings_format}:',
                                style: theme.textTheme.bodyLarge?.copyWith(height: _switchStyle.height),
                              ),
                              Text(
                                _currentFormatName.isEmpty ? l10n.settings_formatDefault : _currentFormatName,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  height: 1.25,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<_FormatMenuAction>(
                          position: PopupMenuPosition.under,
                          padding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(16),
                          onSelected: (action) {
                            switch (action) {
                              case _FormatMenuAction.paste: _pasteFormat(context);
                              case _FormatMenuAction.preview: _showFormatPreview(context);
                              case _FormatMenuAction.reset:
                                _customFormatJson = '';
                                _currentFormatName = '';
                                _onSettingChanged();
                            }
                          },
                          itemBuilder: (context) => [
                            buildMenuItem(_FormatMenuAction.paste, Icons.content_paste_outlined, l10n.settings_formatPaste),
                            buildMenuItem(_FormatMenuAction.preview, Icons.preview_outlined, l10n.settings_formatPreview),
                            buildMenuItem(_FormatMenuAction.reset, Icons.delete_outlined, l10n.settings_formatReset, enabled: _customFormatJson.isNotEmpty),
                          ],
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHigh,
                              shape: BoxShape.circle,
                            ),
                            child: const SizedBox(
                              width: 32, height: 32,
                              child: Icon(Icons.more_vert, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: _deviceLabelController,
            decoration: CustomStyle.compactInput(
              labelText: l10n.settings_deviceLabel,
              helperText: l10n.settings_deviceLabelInfo,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: (String value) => _onSettingChanged(),
          ),
        ],
      ),

      bottomNavigationBar: ActionButton(
        label: l10n.action_save,
        onPressed: _isInputChanged ? _saveSettings : null,
        isSuccess: _saveResult,
      ),
    );
  }
}
