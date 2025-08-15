import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/facility.dart';
import '../models/session.dart';
import '../models/player.dart';
import '../models/player_checkin.dart';
import '../models/player_preferences.dart';
import '../models/court.dart';
import '../models/match.dart';
import '../models/queue_entry.dart';
import '../models/undo_operation.dart';

class EnhancedStorageService {
  static final EnhancedStorageService _instance = EnhancedStorageService._internal();
  factory EnhancedStorageService() => _instance;
  EnhancedStorageService._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'pickleizer_enhanced.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Facilities table
    await db.execute('''
      CREATE TABLE facilities(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        location TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        is_active INTEGER DEFAULT 1,
        sync_status TEXT DEFAULT 'local'
      )
    ''');

    // Sessions table
    await db.execute('''
      CREATE TABLE sessions(
        id TEXT PRIMARY KEY,
        facility_id TEXT NOT NULL,
        session_date INTEGER NOT NULL,
        start_time INTEGER NOT NULL,
        end_time INTEGER,
        status TEXT DEFAULT 'active',
        courts_allocated INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sync_status TEXT DEFAULT 'local',
        FOREIGN KEY (facility_id) REFERENCES facilities(id)
      )
    ''');

    // Enhanced Players table
    await db.execute('''
      CREATE TABLE players(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        skill_level INTEGER DEFAULT 2,
        added_at INTEGER NOT NULL,
        total_games_played INTEGER DEFAULT 0,
        total_wins INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sync_status TEXT DEFAULT 'local'
      )
    ''');

    // Player Preferences table
    await db.execute('''
      CREATE TABLE player_preferences(
        id TEXT PRIMARY KEY,
        player_id TEXT NOT NULL,
        accepts_singles_king_of_hill INTEGER DEFAULT 1,
        accepts_singles_round_robin INTEGER DEFAULT 1,
        accepts_doubles_king_of_hill INTEGER DEFAULT 1,
        accepts_doubles_round_robin INTEGER DEFAULT 1,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sync_status TEXT DEFAULT 'local',
        FOREIGN KEY (player_id) REFERENCES players(id),
        UNIQUE(player_id)
      )
    ''');

    // Player Check-ins table
    await db.execute('''
      CREATE TABLE player_checkins(
        id TEXT PRIMARY KEY,
        player_id TEXT NOT NULL,
        session_id TEXT NOT NULL,
        check_in_time INTEGER NOT NULL,
        check_out_time INTEGER,
        preference_tier INTEGER DEFAULT 2,
        games_played_session INTEGER DEFAULT 0,
        wins_session INTEGER DEFAULT 0,
        is_currently_playing INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sync_status TEXT DEFAULT 'local',
        FOREIGN KEY (player_id) REFERENCES players(id),
        FOREIGN KEY (session_id) REFERENCES sessions(id),
        UNIQUE(player_id, session_id)
      )
    ''');

    // Enhanced Courts table
    await db.execute('''
      CREATE TABLE courts(
        id TEXT PRIMARY KEY,
        facility_id TEXT NOT NULL,
        name TEXT NOT NULL,
        team_size INTEGER NOT NULL,
        game_mode TEXT NOT NULL,
        target_score INTEGER DEFAULT 11,
        win_by_two INTEGER DEFAULT 1,
        position INTEGER NOT NULL,
        is_active INTEGER DEFAULT 1,
        current_session_id TEXT,
        current_player_ids TEXT DEFAULT '',
        match_in_progress INTEGER DEFAULT 0,
        match_start_time INTEGER,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sync_status TEXT DEFAULT 'local',
        FOREIGN KEY (facility_id) REFERENCES facilities(id),
        FOREIGN KEY (current_session_id) REFERENCES sessions(id)
      )
    ''');

    // Enhanced Matches table
    await db.execute('''
      CREATE TABLE matches(
        id TEXT PRIMARY KEY,
        session_id TEXT NOT NULL,
        court_id TEXT NOT NULL,
        team1_players TEXT NOT NULL,
        team2_players TEXT NOT NULL,
        team1_score INTEGER DEFAULT 0,
        team2_score INTEGER DEFAULT 0,
        start_time INTEGER NOT NULL,
        end_time INTEGER,
        completed INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sync_status TEXT DEFAULT 'local',
        FOREIGN KEY (session_id) REFERENCES sessions(id),
        FOREIGN KEY (court_id) REFERENCES courts(id)
      )
    ''');

    // Session Queue table
    await db.execute('''
      CREATE TABLE session_queue(
        id TEXT PRIMARY KEY,
        session_id TEXT NOT NULL,
        player_id TEXT NOT NULL,
        position INTEGER NOT NULL,
        skip_count INTEGER DEFAULT 0,
        soft_skip_count INTEGER DEFAULT 0,
        opportunities_given INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sync_status TEXT DEFAULT 'local',
        FOREIGN KEY (session_id) REFERENCES sessions(id),
        FOREIGN KEY (player_id) REFERENCES players(id),
        UNIQUE(session_id, player_id)
      )
    ''');

    // Undo Operations table
    await db.execute('''
      CREATE TABLE undo_operations(
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        description TEXT NOT NULL,
        data TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        can_undo INTEGER DEFAULT 1
      )
    ''');
  }

  // Facility CRUD operations
  Future<void> saveFacility(Facility facility) async {
    final db = await database;
    await db.insert('facilities', facility.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Facility>> getAllFacilities() async {
    final db = await database;
    final maps = await db.query('facilities', where: 'is_active = 1', orderBy: 'name ASC');
    return maps.map((map) => Facility.fromJson(map)).toList();
  }

  Future<Facility?> getFacility(String id) async {
    final db = await database;
    final maps = await db.query('facilities', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Facility.fromJson(maps.first);
    }
    return null;
  }

  Future<void> updateFacility(Facility facility) async {
    final db = await database;
    await db.update('facilities', facility.toJson(), where: 'id = ?', whereArgs: [facility.id]);
  }

  Future<void> deleteFacility(String id) async {
    final db = await database;
    await db.update('facilities', {'is_active': 0}, where: 'id = ?', whereArgs: [id]);
  }

  // Session CRUD operations
  Future<void> saveSession(Session session) async {
    final db = await database;
    await db.insert('sessions', session.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Session>> getAllSessions() async {
    final db = await database;
    final maps = await db.query('sessions', orderBy: 'start_time DESC');
    return maps.map((map) => Session.fromJson(map)).toList();
  }

  Future<Session?> getActiveSession() async {
    final db = await database;
    final maps = await db.query('sessions', where: 'status = ?', whereArgs: ['active'], limit: 1);
    if (maps.isNotEmpty) {
      return Session.fromJson(maps.first);
    }
    return null;
  }

  Future<void> updateSession(Session session) async {
    final db = await database;
    await db.update('sessions', session.toJson(), where: 'id = ?', whereArgs: [session.id]);
  }

  // Player CRUD operations
  Future<void> savePlayer(Player player) async {
    final db = await database;
    await db.insert('players', player.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Player>> getAllPlayers() async {
    final db = await database;
    final maps = await db.query('players', where: 'is_active = 1', orderBy: 'name ASC');
    return maps.map((map) => Player.fromJson(map)).toList();
  }

  Future<Player?> getPlayer(String id) async {
    final db = await database;
    final maps = await db.query('players', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Player.fromJson(maps.first);
    }
    return null;
  }

  Future<void> updatePlayer(Player player) async {
    final db = await database;
    await db.update('players', player.toJson(), where: 'id = ?', whereArgs: [player.id]);
  }

  Future<void> deletePlayer(String id) async {
    final db = await database;
    await db.update('players', {'is_active': 0}, where: 'id = ?', whereArgs: [id]);
  }

  // Court CRUD operations
  Future<void> saveCourt(Court court) async {
    final db = await database;
    await db.insert('courts', court.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Court>> getAllCourts() async {
    final db = await database;
    final maps = await db.query('courts', where: 'is_active = 1', orderBy: 'position ASC');
    return maps.map((map) => Court.fromJson(map)).toList();
  }

  Future<List<Court>> getCourtsByFacility(String facilityId) async {
    final db = await database;
    final maps = await db.query('courts', where: 'facility_id = ? AND is_active = 1', whereArgs: [facilityId], orderBy: 'position ASC');
    return maps.map((map) => Court.fromJson(map)).toList();
  }

  Future<void> updateCourt(Court court) async {
    final db = await database;
    await db.update('courts', court.toJson(), where: 'id = ?', whereArgs: [court.id]);
  }

  Future<void> deleteCourt(String id) async {
    final db = await database;
    await db.update('courts', {'is_active': 0}, where: 'id = ?', whereArgs: [id]);
  }

  // Match CRUD operations
  Future<void> saveMatch(Match match) async {
    final db = await database;
    await db.insert('matches', match.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateMatch(Match match) async {
    final db = await database;
    await db.update('matches', match.toJson(), where: 'id = ?', whereArgs: [match.id]);
  }

  Future<List<Match>> getTodaysMatches() async {
    final db = await database;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final startTimestamp = startOfDay.millisecondsSinceEpoch;

    final maps = await db.query(
      'matches',
      where: 'start_time >= ?',
      whereArgs: [startTimestamp],
      orderBy: 'start_time DESC',
    );

    return maps.map((map) => Match.fromJson(map)).toList();
  }

  Future<List<Match>> getMatchHistory({int limit = 100}) async {
    final db = await database;
    final maps = await db.query(
      'matches',
      where: 'completed = 1',
      orderBy: 'start_time DESC',
      limit: limit,
    );

    return maps.map((map) => Match.fromJson(map)).toList();
  }

  // Player Preferences CRUD
  Future<void> savePlayerPreferences(PlayerPreferences preferences) async {
    final db = await database;
    await db.insert('player_preferences', preferences.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<PlayerPreferences?> getPlayerPreferences(String playerId) async {
    final db = await database;
    final maps = await db.query('player_preferences', where: 'player_id = ?', whereArgs: [playerId]);
    if (maps.isNotEmpty) {
      return PlayerPreferences.fromJson(maps.first);
    }
    return null;
  }

  // Player Check-in CRUD
  Future<void> savePlayerCheckIn(PlayerCheckIn checkIn) async {
    final db = await database;
    await db.insert('player_checkins', checkIn.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PlayerCheckIn>> getSessionCheckIns(String sessionId) async {
    final db = await database;
    final maps = await db.query('player_checkins', where: 'session_id = ? AND check_out_time IS NULL', whereArgs: [sessionId]);
    return maps.map((map) => PlayerCheckIn.fromJson(map)).toList();
  }

  Future<void> updatePlayerCheckIn(PlayerCheckIn checkIn) async {
    final db = await database;
    await db.update('player_checkins', checkIn.toJson(), where: 'id = ?', whereArgs: [checkIn.id]);
  }

  // Queue CRUD operations
  Future<void> saveQueueEntry(QueueEntry entry) async {
    final db = await database;
    await db.insert('session_queue', entry.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<QueueEntry>> getSessionQueue(String sessionId) async {
    final db = await database;
    final maps = await db.query('session_queue', where: 'session_id = ?', whereArgs: [sessionId], orderBy: 'position ASC');
    return maps.map((map) => QueueEntry.fromJson(map)).toList();
  }

  Future<void> clearSessionQueue(String sessionId) async {
    final db = await database;
    await db.delete('session_queue', where: 'session_id = ?', whereArgs: [sessionId]);
  }

  // Undo Operations CRUD
  Future<void> saveUndoOperation(UndoOperation operation) async {
    final db = await database;
    final data = operation.toJson();
    data['data'] = operation.data.toString(); // Convert map to string for storage
    await db.insert('undo_operations', data);
  }

  Future<List<UndoOperation>> getRecentUndoOperations({int limit = 10}) async {
    final db = await database;
    final maps = await db.query('undo_operations', where: 'can_undo = 1', orderBy: 'timestamp DESC', limit: limit);
    return maps.map((map) {
      final data = Map<String, dynamic>.from(map);
      // Parse the data string back to map (simplified - in real app would use JSON)
      data['data'] = <String, dynamic>{}; // Placeholder
      return UndoOperation.fromJson(data);
    }).toList();
  }

  Future<void> markUndoOperationUsed(String operationId) async {
    final db = await database;
    await db.update('undo_operations', {'can_undo': 0}, where: 'id = ?', whereArgs: [operationId]);
  }

  // Utility methods
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('facilities');
    await db.delete('sessions');
    await db.delete('players');
    await db.delete('player_preferences');
    await db.delete('player_checkins');
    await db.delete('courts');
    await db.delete('matches');
    await db.delete('session_queue');
    await db.delete('undo_operations');
  }

  Future<void> resetDailyStats() async {
    final db = await database;
    // Reset session-specific stats in player_checkins
    await db.update('player_checkins', {
      'games_played_session': 0,
      'wins_session': 0,
    });
  }
}