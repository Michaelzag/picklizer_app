import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/player.dart';
import '../models/court.dart';
import '../models/match.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'pickleizer.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Players table
    await db.execute('''
      CREATE TABLE players(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        added_at INTEGER NOT NULL,
        games_played INTEGER DEFAULT 0,
        wins INTEGER DEFAULT 0,
        is_skipping INTEGER DEFAULT 0
      )
    ''');

    // Courts table
    await db.execute('''
      CREATE TABLE courts(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        team_size INTEGER NOT NULL,
        game_mode TEXT NOT NULL,
        current_player_ids TEXT DEFAULT '',
        match_in_progress INTEGER DEFAULT 0,
        match_start_time INTEGER,
        position INTEGER NOT NULL
      )
    ''');

    // Matches table
    await db.execute('''
      CREATE TABLE matches(
        id TEXT PRIMARY KEY,
        court_id TEXT NOT NULL,
        team1_players TEXT NOT NULL,
        team2_players TEXT NOT NULL,
        team1_score INTEGER NOT NULL,
        team2_score INTEGER NOT NULL,
        start_time INTEGER NOT NULL,
        end_time INTEGER,
        completed INTEGER DEFAULT 0
      )
    ''');

    // Queue table
    await db.execute('''
      CREATE TABLE queue(
        player_id TEXT PRIMARY KEY,
        position INTEGER NOT NULL,
        FOREIGN KEY (player_id) REFERENCES players(id)
      )
    ''');
  }

  // Player CRUD operations
  Future<void> savePlayer(Player player) async {
    final db = await database;
    await db.insert(
      'players',
      player.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Player?> getPlayer(String id) async {
    final db = await database;
    final maps = await db.query(
      'players',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Player.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Player>> getAllPlayers() async {
    final db = await database;
    final maps = await db.query('players', orderBy: 'name ASC');
    return maps.map((map) => Player.fromJson(map)).toList();
  }

  Future<void> updatePlayer(Player player) async {
    final db = await database;
    await db.update(
      'players',
      player.toJson(),
      where: 'id = ?',
      whereArgs: [player.id],
    );
  }

  Future<void> deletePlayer(String id) async {
    final db = await database;
    await db.delete(
      'players',
      where: 'id = ?',
      whereArgs: [id],
    );
    // Also remove from queue if present
    await db.delete(
      'queue',
      where: 'player_id = ?',
      whereArgs: [id],
    );
  }

  // Court CRUD operations
  Future<void> saveCourt(Court court) async {
    final db = await database;
    await db.insert(
      'courts',
      court.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCourt(Court court) async {
    final db = await database;
    await db.update(
      'courts',
      court.toJson(),
      where: 'id = ?',
      whereArgs: [court.id],
    );
  }

  Future<List<Court>> getAllCourts() async {
    final db = await database;
    final maps = await db.query('courts', orderBy: 'position ASC');
    return maps.map((map) => Court.fromJson(map)).toList();
  }

  Future<void> deleteCourt(String id) async {
    final db = await database;
    await db.delete(
      'courts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Match CRUD operations
  Future<void> saveMatch(Match match) async {
    final db = await database;
    await db.insert(
      'matches',
      match.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMatch(Match match) async {
    final db = await database;
    await db.update(
      'matches',
      match.toJson(),
      where: 'id = ?',
      whereArgs: [match.id],
    );
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

  // Queue management
  Future<void> saveQueue(List<Player> queue) async {
    final db = await database;
    
    // Clear existing queue
    await db.delete('queue');
    
    // Insert new queue
    for (int i = 0; i < queue.length; i++) {
      await db.insert('queue', {
        'player_id': queue[i].id,
        'position': i,
      });
    }
  }

  Future<List<Player>> loadQueue() async {
    final db = await database;
    
    final maps = await db.rawQuery('''
      SELECT p.* 
      FROM players p
      INNER JOIN queue q ON p.id = q.player_id
      ORDER BY q.position ASC
    ''');

    return maps.map((map) => Player.fromJson(map)).toList();
  }

  Future<void> addToQueue(String playerId, {int? position}) async {
    final db = await database;
    
    if (position == null) {
      // Add to end of queue
      final maxPosition = await db.rawQuery(
        'SELECT MAX(position) as max_pos FROM queue'
      );
      final maxPos = maxPosition.first['max_pos'] as int? ?? -1;
      position = maxPos + 1;
    }

    await db.insert(
      'queue',
      {
        'player_id': playerId,
        'position': position,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFromQueue(String playerId) async {
    final db = await database;
    await db.delete(
      'queue',
      where: 'player_id = ?',
      whereArgs: [playerId],
    );
  }

  // Daily reset for stats
  Future<void> resetDailyStats() async {
    final db = await database;
    await db.update(
      'players',
      {
        'games_played': 0,
        'wins': 0,
      },
    );
  }

  // Clean old matches (older than 30 days)
  Future<void> cleanOldMatches() async {
    final db = await database;
    final thirtyDaysAgo = DateTime.now()
        .subtract(const Duration(days: 30))
        .millisecondsSinceEpoch;

    await db.delete(
      'matches',
      where: 'start_time < ?',
      whereArgs: [thirtyDaysAgo],
    );
  }

  // Clear all data (for testing or reset)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('players');
    await db.delete('courts');
    await db.delete('matches');
    await db.delete('queue');
  }
}