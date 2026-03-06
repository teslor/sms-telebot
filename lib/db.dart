import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'constants.dart';

class LocalDb {
  // Singleton pattern to keep a single DB instance for the whole app
  static final LocalDb instance = LocalDb._init();
  static Database? _database;

  LocalDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sms_telebot.db');
    return _database!;
  }

  // Database initialization
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  // Enable WAL mode for concurrent Dart/Kotlin access
  Future<void> _onConfigure(Database db) async {
    await db.rawQuery('PRAGMA journal_mode = WAL');
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Create tables on first launch
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE forwarding_rules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        provider TEXT,
        is_active INTEGER DEFAULT 1,
        filter_mode INTEGER DEFAULT 0,
        config_json TEXT,
        filters_json TEXT DEFAULT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE sms_history (
        id TEXT PRIMARY KEY,
        sender TEXT,
        body TEXT,
        received_at INTEGER,
        sent_at INTEGER,
        status INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE event_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp INTEGER,
        level INTEGER,
        message TEXT
      )
    ''');

    await _migrateFromPrefs(db);
  }

  // Migrate data from SharedPreferences
  Future<void> _migrateFromPrefs(Database db) async {
    final prefs = await SharedPreferences.getInstance();
    final botToken = prefs.getString('botToken');

    // If botToken is empty, the migration has already been done before
    // Exit immediately to avoid wasting resources
    if (botToken == null || botToken.isEmpty) return;

    // Move settings into app_settings
    final deviceLabel = prefs.getString('deviceLabel') ?? '';
    final isRunning = prefs.getBool('isRunning') ?? false;
    final l10nSmsFrom = prefs.getString('l10nSmsFrom') ?? '';

    final settingsBatch = db.batch();
    settingsBatch.insert('app_settings', {'key': 'device_label', 'value': deviceLabel});
    settingsBatch.insert('app_settings', {'key': 'is_running','value': isRunning ? '1' : '0'});
    settingsBatch.insert('app_settings', {'key': 'l10n_sms_from', 'value': l10nSmsFrom});
    await settingsBatch.commit();

    // Build JSON for the first rule
    final chatId = prefs.getString('chatId') ?? '';
    final filterMode = prefs.getInt('filterMode') ?? 0;
    final configJson = jsonEncode({'botToken': botToken, 'chatId': chatId});

    // Local helper to safely parse JSON arrays
    List<dynamic> parseList(String key) {
      final str = prefs.getString(key);
      if (str == null || str.isEmpty) return [];
      try {
        return jsonDecode(str) as List<dynamic>;
      } catch (e) {
        return [];
      }
    }

    // Map old keys to the new naming scheme
    final filtersJson = jsonEncode({
      AppConst.filterKeys[0]: parseList('wSenders'),
      AppConst.filterKeys[1]: parseList('wSms'),
      AppConst.filterKeys[2]: parseList('bSenders'),
      AppConst.filterKeys[3]: parseList('bSms'),
    });

    // Create the default rule using the currently opened DB executor to avoid
    // re-entering instance.database while the database is still opening
    await insertRule(filterMode: filterMode, configJson: configJson, filtersJson: filtersJson, executor: db);

    // Clear SharedPreferences permanently
    await prefs.clear();
  }

  // ================================================================================
  // APP_SETTINGS
  // ================================================================================

  /// Read ALL settings from app_settings as a map
  Future<Map<String, String>> getAllSettings() async {
    final db = await instance.database;
    final result = await db.query('app_settings');

    Map<String, String> settings = {};
    for (var row in result) {
      settings[row['key'] as String] = row['value'] as String;
    }
    return settings;
  }

  /// Read a specific setting by key
  Future<String?> getSetting(String key) async {
    final db = await instance.database;
    final result = await db.query(
      'app_settings', columns: ['value'], where: 'key = ?', whereArgs: [key],
    );

    if (result.isNotEmpty) {
      return result.first['value'] as String?;
    }
    return null;
  }

  /// Read a boolean setting
  Future<bool> getBoolSetting(String key, {bool defaultValue = false}) async {
    final val = await getSetting(key);
    if (val == null) return defaultValue;
    return val == '1' || val.toLowerCase() == 'true';
  }

  /// Save a boolean setting
  Future<int> saveBoolSetting(String key, bool value) async {
    // Store as '1' or '0' — a common convention for SQLite
    return await saveSetting(key, value ? '1' : '0');
  }

  /// Insert/Update a setting (creates a row if missing, replaces if exists)
  Future<int> saveSetting(String key, String value) async {
    final db = await instance.database;
    return await db.insert('app_settings', {
      'key': key, 'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ================================================================================
  // FORWARDING_RULES
  // ================================================================================

  /// Get ALL rules from forwarding_rules
  Future<List<Map<String, dynamic>>> getAllRules() async {
    final db = await instance.database;
    return await db.query('forwarding_rules', orderBy: 'id ASC');
  }

  /// Create a new rule in forwarding_rules
  Future<int> insertRule({
    String name = 'Telegram Bot',
    String provider = 'telegram_bot',
    int isActive = 1,
    int filterMode = 0,
    required String configJson,
    String? filtersJson,
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await instance.database;
    return await db.insert('forwarding_rules', {
      'name': name,
      'provider': provider,
      'is_active': isActive,
      'filter_mode': filterMode,
      'config_json': configJson,
      'filters_json': filtersJson,
    });
  }

  /// Update a specific rule by ID
  Future<int> updateRule(int id, Map<String, dynamic> ruleData) async {
    final db = await instance.database;
    return await db.update(
      'forwarding_rules', ruleData, where: 'id = ?', whereArgs: [id],
    );
  }

  /// Update a specific field of a rule by ID
  Future<int> updateRuleField(int id, String column, dynamic value) async {
    final db = await instance.database;
    return await db.update(
      'forwarding_rules', {column: value}, where: 'id = ?', whereArgs: [id],
    );
  }

  // ================================================================================
  // SMS_HISTORY
  // ================================================================================

  /// Get the number of SMS messages RECEIVED by the phone in the last 24 hours
  Future<int> getReceivedSmsCount() async {
    final db = await instance.database;
    // Compute the timestamp: now minus 24 hours (in milliseconds)
    final limitTime = DateTime.now().millisecondsSinceEpoch - (24 * 60 * 60 * 1000);

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM sms_history WHERE received_at >= ?',
      [limitTime],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get the number of SMS messages with non-zero status in the last 24 hours
  Future<int> getSentSmsCount() async {
    final db = await instance.database;
    final limitTime = DateTime.now().millisecondsSinceEpoch - (24 * 60 * 60 * 1000);

    // Non-zero status is treated as successfully sent
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM sms_history WHERE status != 0 AND sent_at >= ?',
      [limitTime],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get the latest SMS with non-zero status
  Future<Map<String, dynamic>?> getLastSentSms() async {
    final db = await instance.database;

    final result = await db.query(
      'sms_history', where: 'status != 0', orderBy: 'sent_at DESC', limit: 1,
    );

    if (result.isNotEmpty) return result.first;
    return null;
  }
}
