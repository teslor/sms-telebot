import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MainDb {
  // Singleton pattern to keep a single DB instance for the whole app
  static final MainDb instance = MainDb._init();
  static Database? _database;
  static Future<Database>? _openingDatabase;

  MainDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    if (_openingDatabase != null) return _openingDatabase!;

    // Prevent parallel openDatabase/init races across isolates/tasks
    _openingDatabase = _initDB('main.db');
    try {
      _database = await _openingDatabase!;
      return _database!;
    } finally {
      _openingDatabase = null;
    }
  }

  // Database initialization
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    final db = await openDatabase(
      path,
      version: 2,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE sms_history RENAME TO messages_history');
          await db.execute('ALTER TABLE messages_history ADD COLUMN type TEXT DEFAULT "sms"');
          try {
            await db.execute('ALTER TABLE messages_history RENAME COLUMN smsc_at TO source_at');
          } on DatabaseException {
            await db.execute('ALTER TABLE messages_history ADD COLUMN source_at INTEGER');
            await db.execute('UPDATE messages_history SET source_at = smsc_at WHERE source_at IS NULL');
          }
          await db.execute('ALTER TABLE event_log RENAME TO app_logs');
          await db.execute('DROP INDEX IF EXISTS idx_sh_received_at');
          await db.execute('CREATE INDEX idx_mh_received_at ON messages_history(received_at)');
        }
      },
    );

    // Ensure default data is present
    await _seedDefaults(db);

    return db;
  }

  // Enable WAL mode for concurrent Dart/Kotlin access
  Future<void> _onConfigure(Database db) async {
    await db.rawQuery('PRAGMA busy_timeout = 5000');
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
        is_active INTEGER DEFAULT 0,
        filter_mode INTEGER DEFAULT 0,
        config_json TEXT DEFAULT NULL,
        filters_json TEXT DEFAULT NULL,
        created_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE messages_history (
        id TEXT PRIMARY KEY,
        type TEXT DEFAULT 'sms',
        sender TEXT,
        body TEXT,
        source_at INTEGER,
        received_at INTEGER,
        last_attempt_at INTEGER,
        sent_at INTEGER,
        attempt_count INTEGER DEFAULT 0,
        status INTEGER DEFAULT 0
      )
    ''');
    await db.execute('CREATE INDEX idx_mh_received_at ON messages_history(received_at)');

    await db.execute('''
      CREATE TABLE app_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp INTEGER,
        level INTEGER,
        message TEXT
      )
    ''');
  }

  Future<void> _seedDefaults(Database db) async {
    final batch = db.batch();

    final defaults = {
      'isRunning': '0',
      'forwardSms': '0',
      'forwardCalls': '0',
      'notifyLowBattery': '0',
      'notifyChargerState': '0',
      'deviceLabel': '',
    };

    defaults.forEach((key, value) {
      batch.insert(
        'app_settings', {'key': key, 'value': value},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    });

    await batch.commit(noResult: true);
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

  /// Save settings bulk
  Future<void> saveSettings(Map<String, String> settings) async {
    final db = await instance.database;
    final batch = db.batch();

    settings.forEach((key, value) {
      batch.insert(
        'app_settings', {'key': key, 'value': value},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true); // noResult speeds up execution if row IDs are not needed
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

  /// Insert/Update a setting (creates a row if missing, replaces if exists)
  Future<int> saveSetting(String key, String value) async {
    final db = await instance.database;
    return await db.insert('app_settings', {
      'key': key, 'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
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

  // ================================================================================
  // FORWARDING_RULES
  // ================================================================================

  /// Get ALL rules from forwarding_rules
  Future<List<Map<String, dynamic>>> getAllRules() async {
    final db = await instance.database;
    return await db.query('forwarding_rules', orderBy: 'name ASC');
  }

  /// Create a new rule in forwarding_rules
  Future<int> insertRule({
    String name = 'Telegram Bot',
    String provider = 'telegram_bot',
    int isActive = 0,
    int filterMode = 0,
    String? configJson,
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
      'created_at': DateTime.now().millisecondsSinceEpoch,
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

  /// Delete a specific rule by ID
  Future<int> deleteRule(int id) async {
    final db = await instance.database;
    return await db.delete('forwarding_rules', where: 'id = ?', whereArgs: [id]);
  }

  // ================================================================================
  // MESSAGES_HISTORY
  // ================================================================================

  /// Get the number of messages RECEIVED by the phone in the last 24 hours
  Future<int> getReceivedMessagesCount() async {
    final db = await instance.database;
    // Compute the timestamp: now minus 24 hours (in milliseconds)
    final limitTime = DateTime.now().millisecondsSinceEpoch - (24 * 60 * 60 * 1000);

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM messages_history WHERE received_at >= ?',
      [limitTime],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get the number of messages successfully sent in the last 24 hours
  Future<int> getSentMessagesCount() async {
    final db = await instance.database;
    final limitTime = DateTime.now().millisecondsSinceEpoch - (24 * 60 * 60 * 1000);

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM messages_history WHERE status IN (3, 4) AND sent_at >= ?',
      [limitTime],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get the latest [limit] messages received in the last 24 hours
  Future<List<Map<String, dynamic>>> getRecentMessages({int limit = 10}) async {
    final db = await instance.database;
    final limitTime = DateTime.now().millisecondsSinceEpoch - (24 * 60 * 60 * 1000);

    return await db.query(
      'messages_history', where: 'received_at >= ?', whereArgs: [limitTime],
      orderBy: 'received_at DESC', limit: limit,
    );
  }
}
