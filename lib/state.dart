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
  static const MethodChannel _filtersChannel = MethodChannel(AppConst.filtersChannel);

  // App settings
  bool isRunning = false;
  String? deviceLabel;

  // Connection & filters
  String? botToken;
  String? chatId;
  int filterMode = 0;
  Map<String, List<String>> filterLists = { for (var key in AppConst.filterKeys) key: [] };

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
      final current = await DbHelper.instance.getSetting('l10n_smsFrom');
      if (current != localizations.sms_from) {
        await DbHelper.instance.saveSetting('l10n_smsFrom', localizations.sms_from);
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
    await DbHelper.instance.saveBoolSetting('is_running', true);
    _startSmsStatsPolling();
    notifyListeners();
  }

  Future<void> stopProcessing() async {
    isRunning = false;
    _stopSmsStatsPolling();
    await DbHelper.instance.saveBoolSetting('is_running', false);
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

  // ============================================================
  // Read data from DB
  // ============================================================
  
  Future<void> _loadSettings() async {
    isRunning = await DbHelper.instance.getBoolSetting('is_running');
    deviceLabel = await DbHelper.instance.getSetting('device_label') ?? '';
    notifyListeners();
  }

  Future<void> _loadRules() async {
    final rules = await DbHelper.instance.getAllRules();
    if (rules.isEmpty) return;
    final rule = rules.first;
    final config = safeDecode(rule['config_json']) ?? {};
    final filters = safeDecode(rule['filters_json']) ?? {};

    botToken = config['botToken'] ?? '';
    chatId = config['chatId'] ?? '';
    filterMode = filters['filter_mode'] ?? filterMode;

    for (var key in AppConst.filterKeys) {
      filterLists[key] = List<String>.from(filters[key] ?? []);
    }
    notifyListeners();
  }

  Future<void> _loadSmsStats() async {
    final newReceivedCount = await DbHelper.instance.getReceivedSmsCount();
    final lastSmsData = await DbHelper.instance.getLastSentSms();
    final newId = lastSmsData?['id'] ?? '';

    if (newReceivedCount != smsReceivedCount || newId != lastSmsId) {
      smsReceivedCount = newReceivedCount;
      smsSentCount = await DbHelper.instance.getSentSmsCount();
      lastSmsId = newId;
      lastSms = lastSmsData;
      notifyListeners();
    }
  }

  // ============================================================
  // Rules methods
  // ============================================================

  Future<void> updateBotSettings(String newBotToken, String newChatId, String newDeviceLabel) async {
    await DbHelper.instance.saveSetting('device_label', newDeviceLabel);

    final configMap = {'botToken': newBotToken, 'chatId': newChatId};
    final configJson = jsonEncode(configMap);
    final rules = await DbHelper.instance.getAllRules();
    if (rules.isNotEmpty) {
      await DbHelper.instance.updateRuleField(rules.first['id'], 'config_json', configJson);
    } else {
      await DbHelper.instance.insertDefaultRule(configJson);
    }

    botToken = newBotToken;
    chatId = newChatId;
    deviceLabel = newDeviceLabel;

    notifyListeners();
  }

  Future<bool> checkFiltersNative(String sender, String sms) async {
    try {
      final result = await _filtersChannel.invokeMethod<bool>('checkFilters', {
        'mode': filterMode,
        'sender': sender,
        'sms': sms,
        'wSenders': filterLists[AppConst.filterKeys[0]] ?? <String>[],
        'wSms': filterLists[AppConst.filterKeys[1]] ?? <String>[],
        'bSenders': filterLists[AppConst.filterKeys[2]] ?? <String>[],
        'bSms': filterLists[AppConst.filterKeys[3]] ?? <String>[],
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
    final Map<String, dynamic> filtersMap = {'filter_mode': filterMode};
    for (var key in AppConst.filterKeys) {
      filtersMap[key] = filterLists[key] ?? [];
    }
    final String filtersJson = jsonEncode(filtersMap);

    final rules = await DbHelper.instance.getAllRules();
    if (rules.isNotEmpty) {
      await DbHelper.instance.updateRuleField(rules.first['id'], 'filters_json', filtersJson);
    } else {
      await DbHelper.instance.insertDefaultRule(
        jsonEncode({'botToken': '', 'chatId': ''}),
        filtersJson,
      );
    }

    notifyListeners();
  }

  // ============================================================

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopSmsStatsPolling();
    super.dispose();
  }
}