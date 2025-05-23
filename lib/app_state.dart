import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readsms/readsms.dart';
import 'dart:convert';
import 'utils.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final appLoc = AppLocalizations.of(navigatorKey.currentState!.context);
List<String> _filterKeys = ['wSenders', 'wSms', 'bSenders', 'bSms'];

class AppState extends ChangeNotifier {
  final _smsPlugin = Readsms();
  Map<String, bool> isFilterListChanged = { for (var key in _filterKeys) key: false };

  String? botToken;
  String? chatId;
  int filterMode = 0;
  Map<String, List<String>> filterLists = { for (var key in _filterKeys) key: [] };

  int smsReceived = 0;
  int smsSentToBot = 0;
  Map latestSms = {};

  AppState() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadSettings();

    if (await getPermission()) {
      _smsPlugin.read();
      _smsPlugin.smsStream.listen((event) async {
        smsReceived++;

        bool sendResult = checkFilters(event.sender, event.body) ? 
                          await sendMessage(botToken, chatId, '${appLoc!.sms_from} ${event.sender}:\n${event.body}') : false;
        if (sendResult) smsSentToBot++;
        latestSms = { 'time': event.timeReceived.toString(), 'sender': event.sender, 'sms': event.body, 'sent': sendResult };
        notifyListeners();
      });
    }
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    botToken = prefs.getString('botToken') ?? '';
    chatId = prefs.getString('chatId') ?? '';
    filterMode = prefs.getInt('filterMode') ?? filterMode;
    for (var key in _filterKeys) {
      filterLists[key] = List<String>.from(jsonDecode(prefs.getString(key) ?? '[]'));
    }
    notifyListeners();
  }

  void addToFilterList(String listName, String item) {
    filterLists[listName]!.add(item);
    isFilterListChanged[listName] = true;
    notifyListeners();
  }

  void removeFromFilterList(String listName, String item) {
    filterLists[listName]!.remove(item);
    isFilterListChanged[listName] = true;
    notifyListeners();
  }

  bool checkFilters(String sender, String sms) {
    if (filterMode == 0) { // filters off
      return true;
    } else if (filterMode == 1) { // whitelist
      return (hasFilterMatches(sender, filterLists['wSenders']) || hasFilterMatches(sms, filterLists['wSms']));
    } else { // blacklist
      return (!hasFilterMatches(sender, filterLists['bSenders']) && !hasFilterMatches(sms, filterLists['bSms']));
    }
  }

  Future<void> updateFilterMode(int newMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('filterMode', newMode);
    filterMode = newMode;
    notifyListeners();
  }

  Future<void> updateBotSettings(String newBotToken, String newChatId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('botToken', newBotToken);
    await prefs.setString('chatId', newChatId);
    botToken = newBotToken;
    chatId = newChatId;
    notifyListeners();
  }

  Future<void> saveFilters() async {
    SharedPreferences? prefs;
    for (var key in _filterKeys) {
      if (isFilterListChanged[key]!) {
        prefs = prefs ?? await SharedPreferences.getInstance();
        prefs.setString(key, jsonEncode(filterLists[key]));
        isFilterListChanged[key] = false;
      }
    }
  }

  @override
  void dispose() {
    _smsPlugin.dispose();
    super.dispose();
  }
}