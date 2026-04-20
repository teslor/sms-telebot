import 'package:flutter/material.dart';
import 'l10n/generated/app_localizations.dart';
import 'dart:convert';
import 'dart:async';
import 'constants.dart';
import 'db.dart';
import 'service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppState extends ChangeNotifier with WidgetsBindingObserver {
  Timer? _statsTimer;

  // App settings
  bool isRunning = false;
  bool forwardSms = false;
  bool notifyLowBattery = false;
  bool notifyChargerState = false;
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

  // Messages stats
  int receivedCount = 0;
  int sentCount = 0;
  List<Map<String, dynamic>> messagesList = [];
  String messagesListHash = '';

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
      final settings = await MainDb.instance.getAllSettings();
      final l10nSettings = <String, String>{
        'l10nSmsFrom': localizations.msg_smsFrom,
        'l10nLowBattery': localizations.msg_system_lowBattery,
        'l10nChargerConnected': localizations.msg_system_chargerConnected,
        'l10nChargerDisconnected': localizations.msg_system_chargerDisconnected,
      };

      final l10nChanged = <String, String>{};
      l10nSettings.forEach((key, value) {
        if (settings[key] != value) l10nChanged[key] = value;
      });

      if (l10nChanged.isNotEmpty) await MainDb.instance.saveSettings(l10nChanged);
    });

    _updateStats();
    if (isRunning) _startStatsPolling();
  }

  void _startStatsPolling() {
    _statsTimer ??= Timer.periodic(const Duration(seconds: 5), (_) async {
      await _updateStats();
    });
  }

  void _stopStatsPolling() {
    _statsTimer?.cancel();
    _statsTimer = null;
  }

  Future<void> startProcessing() async {
    isRunning = true;
    notifyListeners();
    await MainDb.instance.saveBoolSetting('isRunning', true);
    _startStatsPolling();
  }

  Future<void> stopProcessing() async {
    isRunning = false;
    notifyListeners();
    _stopStatsPolling();
    await MainDb.instance.saveBoolSetting('isRunning', false);
    stopWorkersNative();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (isRunning) {
        _updateStats();
        _startStatsPolling();
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _stopStatsPolling();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _loadSettings() async {
    final settings = await MainDb.instance.getAllSettings();
    isRunning = settings['isRunning'] == '1';
    forwardSms = settings['forwardSms'] == '1';
    notifyLowBattery = settings['notifyLowBattery'] == '1';
    notifyChargerState = settings['notifyChargerState'] == '1';
    deviceLabel = settings['deviceLabel'] ?? '';
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

  Future<void> _updateStats() async {
    final newReceivedCount = await MainDb.instance.getReceivedMessagesCount();
    final newSentCount = await MainDb.instance.getSentMessagesCount();
    final newList = await MainDb.instance.getRecentMessages(limit: 10);
    final statusesSum = newList
      .fold<int>(0, (sum, msg) => sum + ((msg['status'] as num?)?.toInt() ?? 0));
    final attemptsSum = newList
      .fold<int>(0, (sum, msg) => sum + ((msg['attempt_count'] as num?)?.toInt() ?? 0));
    final newHash = '$newReceivedCount$newSentCount$statusesSum$attemptsSum';

    if (newHash != messagesListHash) {
      receivedCount = newReceivedCount;
      sentCount = newSentCount;
      messagesList = newList;
      messagesListHash = newHash;
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

  Future<CallResult> updateSettings({
    required bool forwardSms,
    required bool notifyLowBattery,
    required bool notifyChargerState,
    required String deviceLabel,
  }) async {
    await MainDb.instance.saveSettings({
      'forwardSms': forwardSms ? '1' : '0',
      'notifyLowBattery': notifyLowBattery ? '1' : '0',
      'notifyChargerState': notifyChargerState ? '1' : '0',
      'deviceLabel': deviceLabel,
    });

    this.forwardSms = forwardSms;
    this.notifyLowBattery = notifyLowBattery;
    this.notifyChargerState = notifyChargerState;
    this.deviceLabel = deviceLabel;

    notifyListeners();
    return okResult();
  }

  bool get canStartProcessing {
    return rules.any((r) => r['is_active'] == 1 && r['config_json'] != null);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopStatsPolling();
    super.dispose();
  }
}
