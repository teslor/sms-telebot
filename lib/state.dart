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

  // ================================================================================
  // Read data from DB
  // ================================================================================
  
  Future<void> _loadSettings() async {
    isRunning = await LocalDb.instance.getBoolSetting('isRunning');
    deviceLabel = await LocalDb.instance.getSetting('deviceLabel') ?? '';
    notifyListeners();
  }

  Future<void> _loadRules() async {
    final rules = await LocalDb.instance.getAllRules();
    if (rules.isEmpty) return;
    final rule = rules.first;
    final config = safeDecode(rule['config_json']) ?? {};
    final filters = safeDecode(rule['filters_json']) ?? {};

    botToken = config['botToken'] ?? '';
    chatId = config['chatId'] ?? '';
    filterMode = rule['filter_mode'] ?? filterMode;

    for (var key in AppConst.filterKeys) {
      filterLists[key] = List<String>.from(filters[key] ?? []);
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
  // Rules methods
  // ================================================================================

  Future<void> updateBotSettings(String newBotToken, String newChatId, String newDeviceLabel) async {
    await LocalDb.instance.saveSetting('deviceLabel', newDeviceLabel);

    final configMap = {'botToken': newBotToken, 'chatId': newChatId};
    final configJson = jsonEncode(configMap);
    final rules = await LocalDb.instance.getAllRules();
    if (rules.isNotEmpty) {
      await LocalDb.instance.updateRuleField(rules.first['id'], 'config_json', configJson);
    } else {
      await LocalDb.instance.insertRule(configJson: configJson);
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
    final Map<String, dynamic> filtersMap = {};
    for (var key in AppConst.filterKeys) {
      filtersMap[key] = filterLists[key] ?? [];
    }
    final String filtersJson = jsonEncode(filtersMap);

    final rules = await LocalDb.instance.getAllRules();
    if (rules.isNotEmpty) {
      await LocalDb.instance.updateRuleField(rules.first['id'], 'filters_json', filtersJson);
    } else {
      await LocalDb.instance.insertRule(
        filterMode: filterMode,
        configJson: jsonEncode({'botToken': '', 'chatId': ''}),
        filtersJson: filtersJson,
      );
    }

    notifyListeners();
  }

  // ================================================================================

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopSmsStatsPolling();
    super.dispose();
  }
}