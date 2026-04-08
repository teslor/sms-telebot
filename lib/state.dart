import 'package:flutter/material.dart';
import 'l10n/generated/app_localizations.dart';
import 'dart:convert';
import 'dart:async';
import 'constants.dart';
import 'db.dart';
import 'service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppState extends ChangeNotifier with WidgetsBindingObserver {
  Timer? _smsStatsTimer;

  // App settings
  bool isRunning = false;
  String deviceLabel = '';

  // Rule list
  List<Map<String, dynamic>> rules = [];
  Map<String, dynamic>? selectedRule;

  // Selected rule data
  int filterMode = 0;
  Map<String, dynamic> config = {};
  Map<String, List<String>> filterLists = {
    for (var key in AppConst.filterKeys) key: [],
  };

  // SMS stats
  int smsReceivedCount = 0;
  int smsSentCount = 0;
  List<Map<String, dynamic>> smsReceivedList = [];

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
      final current = await MainDb.instance.getSetting('l10nSmsFrom');
      if (current != localizations.sms_from) {
        await MainDb.instance.saveSetting('l10nSmsFrom', localizations.sms_from);
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
    notifyListeners();
    await MainDb.instance.saveBoolSetting('isRunning', true);
    _startSmsStatsPolling();
  }

  Future<void> stopProcessing() async {
    isRunning = false;
    notifyListeners();
    _stopSmsStatsPolling();
    await MainDb.instance.saveBoolSetting('isRunning', false);
    stopWorkersNative();
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
    isRunning = await MainDb.instance.getBoolSetting('isRunning');
    deviceLabel = await MainDb.instance.getSetting('deviceLabel') ?? '';
    notifyListeners();
  }

  Future<void> _loadRules() async {
    rules = await MainDb.instance.getAllRules();

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
    final newReceivedCount = await MainDb.instance.getReceivedSmsCount();
    final newList = await MainDb.instance.getRecentSmsList(limit: 10);

    final newFirstSmsId = newList.isNotEmpty ? newList.first['id'] : null;
    final currentFirstSmsId = smsReceivedList.isNotEmpty ? smsReceivedList.first['id'] : null;    

    if (newReceivedCount != smsReceivedCount || newFirstSmsId != currentFirstSmsId) {
      smsReceivedCount = newReceivedCount;
      smsSentCount = await MainDb.instance.getSentSmsCount();
      smsReceivedList = newList;
      notifyListeners();
    }
  }

  // ================================================================================
  // Rules
  // ================================================================================

  Future<CallResult> selectRule(Map<String, dynamic>? rule) async {
    selectedRule = rule;
    CallResult result = okResult();

    if (rule != null) {
      filterMode = rule['filter_mode'] ?? 0;
      final filters = safeDecode(rule['filters_json']) ?? {};
      filterLists = {
        for (var key in AppConst.filterKeys) key: List<String>.from(filters[key] ?? [])
      };

      config = safeDecode(rule['config_json']) ?? {};
      result = await readSecretNative(rule['id'].toString());
      if (result.isSuccess) {
        final secret = result.data;
        if (secret != null && secret.isNotEmpty) {
          if (rule['provider'] == 'telegram_bot') {
            config['token'] = secret;
          } else {
            config['password'] = secret;
          }
        }
      }
    } else {
      filterMode = 0;
      config = {};
      filterLists = {for (var key in AppConst.filterKeys) key: []};
    }
    notifyListeners();
    return result;
  }

  Future<CallResult> updateRuleName(int id, String name) async {
    await MainDb.instance.updateRuleField(id, 'name', name);
    await _loadRules();
    return okResult();
  }

  Future<CallResult> toggleRuleActive(int id, bool isActive) async {
    await MainDb.instance.updateRuleField(id, 'is_active', isActive ? 1 : 0);
    await _loadRules();
    return okResult();
  }

  Future<CallResult> deleteRule(int id) async {
    await MainDb.instance.deleteRule(id);
    await _loadRules();
    return okResult();
  }

  Future<CallResult> addRule({required String name, required String provider, bool autoSelect = false}) async {
    final newRuleId = await MainDb.instance.insertRule(name: name, provider: provider);
    await _loadRules();

    if (!autoSelect) return okResult();
    final newRule = rules.where((rule) => rule['id'] == newRuleId).firstOrNull;
    if (newRule != null) selectRule(newRule);
    return okResult();
  }

  Future<CallResult> duplicateRule(Map<String, dynamic> ruleToCopy) async {
    String newName =
      '${ruleToCopy['name']} (${AppLocalizations.of(navigatorKey.currentContext!)!.rule_copySuffix})';
    CallResult result = okResult();

    result = await readSecretNative(ruleToCopy['id'].toString());
    if (result.isSuccess) {
      final newRuleId = await MainDb.instance.insertRule(
        name: newName,
        provider: ruleToCopy['provider'],
        filterMode: ruleToCopy['filter_mode'],
        configJson: ruleToCopy['config_json'],
        filtersJson: ruleToCopy['filters_json'],
      );

      final secret = result.data;
      if (secret != null && secret.isNotEmpty) {
        result = await saveSecretNative(newRuleId.toString(), secret);
      }
    } else {
      return result;
    }

    await _loadRules();
    return result;
  }

  Future<CallResult> updateRuleConfig(Map<String, dynamic> newConfig, String? secret) async {
    CallResult result = okResult();
    
    if (selectedRule == null) return result;
    final ruleId = selectedRule!['id'];

    await MainDb.instance.updateRuleField(ruleId, 'config_json', jsonEncode(newConfig));
    result = await saveSecretNative(ruleId.toString(), secret ?? '');
    await _loadRules();
    return result;
  }

  // ================================================================================
  // Filters
  // ================================================================================

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

  Future<CallResult> saveFilters() async {
    if (selectedRule == null) return okResult();
    final ruleId = selectedRule!['id'];

    final Map<String, dynamic> filtersMap = {};
    for (var key in AppConst.filterKeys) {
      filtersMap[key] = filterLists[key] ?? [];
    }
    final String filtersJson = jsonEncode(filtersMap);

    await MainDb.instance.updateRule(ruleId, {
      'filter_mode': filterMode,
      'filters_json': filtersJson,
    });

    await _loadRules();
    return okResult();
  }

  // ================================================================================
  // Misc
  // ================================================================================

  Future<CallResult> updateDeviceLabel(String newDeviceLabel) async {
    await MainDb.instance.saveSetting('deviceLabel', newDeviceLabel);
    deviceLabel = newDeviceLabel;
    return okResult();
  }

  bool get canStartProcessing {
    return rules.any((r) => r['is_active'] == 1 && r['config_json'] != null);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopSmsStatsPolling();
    super.dispose();
  }
}
