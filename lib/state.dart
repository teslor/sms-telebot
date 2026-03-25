import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'l10n/generated/app_localizations.dart';
import 'dart:convert';
import 'dart:async';
import 'constants.dart';
import 'db.dart';
import 'service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppState extends ChangeNotifier with WidgetsBindingObserver {
  Timer? _smsStatsTimer;
  static const MethodChannel _mainChannel = MethodChannel(AppConst.mainChannel);

  // App settings
  bool isRunning = false;
  String deviceLabel = '';

  // Rule list
  List<Map<String, dynamic>> rules =[];
  Map<String, dynamic>? selectedRule;

  // Selected rule data
  int filterMode = 0;
  Map<String, dynamic> config = {};
  Map<String, List<String>> filterLists = { for (var key in AppConst.filterKeys) key:[] };

  // SMS stats
  int smsReceivedCount = 0;
  int smsSentCount = 0;
  Map? lastSms;
  String? lastSmsId;

  AppState() {
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _init() async {
    await _loadSettings();
    await _loadRules();
    await getSmsPermission();
    await getNotificationPermission();

    // Save l10n required for background process after first frame when context is available
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final localizations = AppLocalizations.of(navigatorKey.currentContext!)!;
      final current = await LocalDb.instance.getSetting('l10nSmsFrom');
      if (current != localizations.sms_from) {
        await LocalDb.instance.saveSetting('l10nSmsFrom', localizations.sms_from);
      }
    });

    _loadSmsStats();
    if (isRunning) _startSmsStatsPolling();
  }

  void _startSmsStatsPolling() {
    _smsStatsTimer ??= Timer.periodic(const Duration(seconds: 5), (_) async {
      await _loadSmsStats();
    });
  }

  void _stopSmsStatsPolling() {
    _smsStatsTimer?.cancel();
    _smsStatsTimer = null;
  }

  Future<void> startProcessing() async {
    isRunning = true;
    await LocalDb.instance.saveBoolSetting('isRunning', true);
    _startSmsStatsPolling();
    notifyListeners();
  }

  Future<void> stopProcessing() async {
    isRunning = false;
    _stopSmsStatsPolling();
    await LocalDb.instance.saveBoolSetting('isRunning', false);
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (isRunning) {
        _loadSmsStats();
        _startSmsStatsPolling();
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _stopSmsStatsPolling();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _loadSettings() async {
    isRunning = await LocalDb.instance.getBoolSetting('isRunning');
    deviceLabel = await LocalDb.instance.getSetting('deviceLabel') ?? '';
    notifyListeners();
  }

  Future<void> _loadRules() async {
    rules = await LocalDb.instance.getAllRules();

    // Refresh selected rule data if it exists
    if (selectedRule != null) {
      final updatedRule = rules.where((r) => r['id'] == selectedRule!['id']).firstOrNull;
      if (updatedRule != null) {
        selectRule(updatedRule);
      } else {
        selectRule(null);
      }
    }
    notifyListeners();
  }

  Future<void> _loadSmsStats() async {
    final newReceivedCount = await LocalDb.instance.getReceivedSmsCount();
    final newLastSms = await LocalDb.instance.getLastSentSms();
    final newId = newLastSms?['id'];

    if (newReceivedCount != smsReceivedCount || newId != lastSmsId) {
      smsReceivedCount = newReceivedCount;
      smsSentCount = await LocalDb.instance.getSentSmsCount();
      lastSmsId = newId;
      lastSms = newLastSms;
      notifyListeners();
    }
  }

  // ================================================================================
  // Rules management
  // ================================================================================

  void selectRule(Map<String, dynamic>? rule) {
    selectedRule = rule;
    if (rule != null) {
      filterMode = rule['filter_mode'] ?? 0;
      config = safeDecode(rule['config_json']) ?? {};
      final filters = safeDecode(rule['filters_json']) ?? {};

      filterLists = { for (var key in AppConst.filterKeys) key: [] };
      for (var key in AppConst.filterKeys) {
        filterLists[key] = List<String>.from(filters[key] ??[]);
      }
    } else {
      filterMode = 0;
      config = {};
      filterLists = { for (var key in AppConst.filterKeys) key:[] };
    }
    notifyListeners();
  }

  Future<void> updateRuleName(int id, String name) async {
    await LocalDb.instance.updateRuleField(id, 'name', name);
    await _loadRules();
  }

  Future<void> toggleRuleActive(int id, bool isActive) async {
    await LocalDb.instance.updateRuleField(id, 'is_active', isActive ? 1 : 0);
    await _loadRules();
  }

  Future<void> deleteRule(int id) async {
    await LocalDb.instance.deleteRule(id);
    await _loadRules();
  }

  Future<void> addRule() async {
    final configJson = jsonEncode({'botToken': '', 'chatId': ''});

    await LocalDb.instance.insertRule(
      name: AppLocalizations.of(navigatorKey.currentContext!)!.rule,
      isActive: 0,
      configJson: configJson,
    );
    await _loadRules();
  }

  Future<void> duplicateRule(Map<String, dynamic> ruleToCopy) async {
    String newName = '${ruleToCopy['name']} (${AppLocalizations.of(navigatorKey.currentContext!)!.rule_copySuffix})';

    await LocalDb.instance.insertRule(
      name: newName,
      isActive: 0,
      filterMode: ruleToCopy['filter_mode'],
      configJson: ruleToCopy['config_json'],
      filtersJson: ruleToCopy['filters_json'],
    );
    await _loadRules();
  }

  Future<void> updateConnectionData(Map<String, dynamic> newConfig) async {
    if (selectedRule == null) return;
    final ruleId = selectedRule!['id'];

    await LocalDb.instance.updateRuleField(ruleId, 'config_json', jsonEncode(newConfig));
    await _loadRules();
  }

  Future<void> updateDeviceLabel(String newDeviceLabel) async {
    await LocalDb.instance.saveSetting('deviceLabel', newDeviceLabel);
    deviceLabel = newDeviceLabel;
    notifyListeners();
  }

  Future<bool> checkFiltersNative(String sender, String sms) async {
    try {
      final result = await _mainChannel.invokeMethod<bool>('checkFilters', {
        'sender': sender,
        'sms': sms,
        'mode': filterMode,
        'whitelistSenders': filterLists[AppConst.filterKeys[0]] ?? <String>[],
        'whitelistBody': filterLists[AppConst.filterKeys[1]] ?? <String>[],
        'blacklistSenders': filterLists[AppConst.filterKeys[2]] ?? <String>[],
        'blacklistBody': filterLists[AppConst.filterKeys[3]] ?? <String>[],
      });
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  void setFilterMode(int newMode) {
    filterMode = newMode;
    notifyListeners();
  }

  void addToFilterList(String listName, String item) {
    filterLists[listName]!.add(item);
    notifyListeners();
  }

  void removeFromFilterList(String listName, String item) {
    filterLists[listName]!.remove(item);
    notifyListeners();
  }

  Future<void> saveFilters() async {
    if (selectedRule == null) return;
    final ruleId = selectedRule!['id'];

    final Map<String, dynamic> filtersMap = {};
    for (var key in AppConst.filterKeys) {
      filtersMap[key] = filterLists[key] ?? [];
    }
    final String filtersJson = jsonEncode(filtersMap);

    await LocalDb.instance.updateRule(ruleId, {
      'filter_mode': filterMode,
      'filters_json': filtersJson,
    });

    await _loadRules();
  }

  bool get canStartProcessing {
    return rules.any((r) {
      if (r['is_active'] != 1) return false;
      final cfg = safeDecode(r['config_json']) ?? {};
      return cfg.isNotEmpty && cfg.values.every((v) => v != null && v.toString().isNotEmpty);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopSmsStatsPolling();
    super.dispose();
  }
}