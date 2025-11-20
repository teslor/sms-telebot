import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readsms/readsms.dart';
import 'dart:convert';
import 'constants.dart';
import 'service.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final appLoc = AppLocalizations.of(navigatorKey.currentState!.context);

class AppState extends ChangeNotifier {
  SharedPreferences? _prefs;
  final _smsPlugin = Readsms();
  final Map<String, bool> _isFilterListChanged = { for (var key in AppConst.filterKeys) key: false };

  int smsReceived = 0;
  int smsSentToBot = 0;
  Map latestSms = {};
  String? botToken;
  String? chatId;
  String? deviceLabel;
  int filterMode = 0;
  Map<String, List<String>> filterLists = { for (var key in AppConst.filterKeys) key: [] };

  AppState() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();

    if (await getPermission()) {
      _smsPlugin.read();
      _smsPlugin.smsStream.listen((event) async {
        smsReceived++;

        String deviceInfo = deviceLabel!.isNotEmpty ? ' <i>($deviceLabel)</i>' : '';
        bool sendResult = checkFilters(event.sender, event.body) ? 
                          await sendMessage(botToken, chatId, '${appLoc!.sms_from} <b>${event.sender}</b>$deviceInfo:\n${event.body}') : false;
        if (sendResult) smsSentToBot++;
        latestSms = { 'time': event.timeReceived.toString(), 'sender': event.sender, 'sms': event.body, 'sent': sendResult };
        notifyListeners();
      });
    }
  }
  
  Future<void> _loadSettings() async {
    botToken = _prefs?.getString('botToken') ?? '';
    chatId = _prefs?.getString('chatId') ?? '';
    deviceLabel = _prefs?.getString('deviceLabel') ?? '';
    filterMode = _prefs?.getInt('filterMode') ?? filterMode;
    for (var key in AppConst.filterKeys) {
      filterLists[key] = List<String>.from(jsonDecode(_prefs?.getString(key) ?? '[]'));
    }
    notifyListeners();
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
    _smsPlugin.dispose();
    super.dispose();
  }
}