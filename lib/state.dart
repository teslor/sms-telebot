import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'constants.dart';
import 'service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppState extends ChangeNotifier with WidgetsBindingObserver {
  SharedPreferences? _prefs;
  final Map<String, bool> _isFilterListChanged = { for (var key in AppConst.filterKeys) key: false };
  Timer? _smsStatsTimer;
  static const MethodChannel _filtersChannel = MethodChannel('sms_telebot/filters');

  bool isRunning = false;
  int smsReceived = 0;
  int smsSentToBot = 0;
  Map latestSms = {};
  String? botToken;
  String? chatId;
  String? deviceLabel;
  int filterMode = 0;
  Map<String, List<String>> filterLists = { for (var key in AppConst.filterKeys) key: [] };

  AppState() {
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
    await _loadSmsStats();
    await getSmsPermission();
    await getNotificationPermission();

    // Save l10n required for background process after first frame when context is available
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final localizations = AppLocalizations.of(navigatorKey.currentContext!)!;
      final current = _prefs?.getString('l10n_sms_from');
      if (current != localizations.sms_from) {
        await _prefs?.setString('l10n_sms_from', localizations.sms_from);
      }
    });

    _startSmsStatsPolling();
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadSmsStats();
      _startSmsStatsPolling();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _stopSmsStatsPolling();
    }
    super.didChangeAppLifecycleState(state);
  }
  
  Future<void> _loadSettings() async {
    isRunning = _prefs?.getBool('isRunning') ?? isRunning;
    botToken = _prefs?.getString('botToken') ?? '';
    chatId = _prefs?.getString('chatId') ?? '';
    deviceLabel = _prefs?.getString('deviceLabel') ?? '';
    filterMode = _prefs?.getInt('filterMode') ?? filterMode;
    for (var key in AppConst.filterKeys) {
      filterLists[key] = List<String>.from(jsonDecode(_prefs?.getString(key) ?? '[]'));
    }
    notifyListeners();
  }

  Future<void> _loadSmsStats() async {
    await _prefs?.reload();
    final nextReceived = _prefs?.getInt('smsReceived') ?? smsReceived;
    final nextSent = _prefs?.getInt('smsSentToBot') ?? smsSentToBot;
    Map nextLatest = latestSms;
    final latestRaw = _prefs?.getString('latestSms') ?? '';
    if (latestRaw.isNotEmpty) {
      try {
        nextLatest = jsonDecode(latestRaw);
      } catch (_) {
        nextLatest = {};
      }
    }

    if (nextReceived != smsReceived || nextSent != smsSentToBot ||
        nextLatest.toString() != latestSms.toString()) {
      smsReceived = nextReceived;
      smsSentToBot = nextSent;
      latestSms = nextLatest;
      notifyListeners();
    }
  }

  bool checkFilters(String sender, String sms) {
    if (filterMode == 0) { // filters off
      return true;
    } else if (filterMode == 1) { // whitelist
      return (hasFilterMatches(sender, filterLists[AppConst.filterKeys[0]]) || hasFilterMatches(sms, filterLists[AppConst.filterKeys[1]]));
    } else { // blacklist
      return (!hasFilterMatches(sender, filterLists[AppConst.filterKeys[2]]) && !hasFilterMatches(sms, filterLists[AppConst.filterKeys[3]]));
    }
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
      return checkFilters(sender, sms);
    }
  }

  void setFilterMode(int newMode) {
    filterMode = newMode;
    notifyListeners();
  }

  void addToFilterList(String listName, String item) {
    filterLists[listName]!.add(item);
    _isFilterListChanged[listName] = true;
    notifyListeners();
  }

  void removeFromFilterList(String listName, String item) {
    filterLists[listName]!.remove(item);
    _isFilterListChanged[listName] = true;
    notifyListeners();
  }

  Future<void> saveFilters() async {
    await _prefs?.setInt('filterMode', filterMode);
    for (var key in AppConst.filterKeys) {
      if (_isFilterListChanged[key]!) {
        _prefs?.setString(key, jsonEncode(filterLists[key]));
        _isFilterListChanged[key] = false;
      }
    }
  }

  Future<void> startProcessing() async {
    isRunning = true;
    await _prefs?.setBool('isRunning', true);
    notifyListeners();
  }

  Future<void> stopProcessing() async {
    isRunning = false;
    smsReceived = 0;
    smsSentToBot = 0;
    latestSms = {};

    await _prefs?.setBool('isRunning', false);
    await _prefs?.setInt('smsReceived', 0);
    await _prefs?.setInt('smsSentToBot', 0);
    await _prefs?.remove('latestSms');
    await _prefs?.remove('lastSmsId');
    await _prefs?.remove('lastSmsSent');

    notifyListeners();
  }

  Future<void> updateBotSettings(String newBotToken, String newChatId, String newDeviceLabel) async {
    await _prefs?.setString('botToken', newBotToken);
    await _prefs?.setString('chatId', newChatId);
    if (newDeviceLabel.isNotEmpty) {
      await _prefs?.setString('deviceLabel', newDeviceLabel);
    } else {
      await _prefs?.remove('deviceLabel');
    }
    botToken = newBotToken;
    chatId = newChatId;
    deviceLabel = newDeviceLabel;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopSmsStatsPolling();
    super.dispose();
  }
}