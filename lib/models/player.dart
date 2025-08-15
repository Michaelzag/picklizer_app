import 'package:uuid/uuid.dart';
import 'enums.dart';

class Player {
  final String id;
  final String name;
  final String? phone; // NEW: Optional for future features
  final String? email; // NEW: Optional for future features
  
  // Game mode preferences (opt-out system - all enabled by default)
  final bool playsSingles;
  final bool playsDoubles;
  final bool playsKingOfHill;
  final bool playsRoundRobin;
  
  final DateTime addedAt;
  int totalGamesPlayed; // NEW: Renamed from gamesPlayed for clarity
  int totalWins; // NEW: Renamed from wins for clarity
  final bool isActive; // NEW: Soft delete
  final DateTime createdAt; // NEW: For sync
  final DateTime updatedAt; // NEW: For sync
  final SyncStatus syncStatus; // NEW: For sync

  Player({
    String? id,
    required this.name,
    this.phone,
    this.email,
    this.playsSingles = true, // Default to all game modes enabled
    this.playsDoubles = true,
    this.playsKingOfHill = true,
    this.playsRoundRobin = true,
    DateTime? addedAt,
    this.totalGamesPlayed = 0,
    this.totalWins = 0,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.syncStatus = SyncStatus.local,
  }) : id = id ?? const Uuid().v4(),
       addedAt = addedAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  double get totalWinRate => totalGamesPlayed > 0 ? totalWins / totalGamesPlayed : 0.0;

  // Game mode preference helpers
  List<String> get enabledGameModes {
    final List<String> modes = [];
    if (playsSingles) modes.add('Singles');
    if (playsDoubles) modes.add('Doubles');
    if (playsKingOfHill) modes.add('King of Hill');
    if (playsRoundRobin) modes.add('Round Robin');
    return modes;
  }

  String get gameModesDisplay {
    final modes = enabledGameModes;
    if (modes.isEmpty) return 'No game modes';
    if (modes.length == 4) return 'All game modes';
    return modes.join(', ');
  }

  bool get canPlayGameMode => playsSingles || playsDoubles || playsKingOfHill || playsRoundRobin;

  // Backward compatibility getters
  int get gamesPlayed => totalGamesPlayed;
  int get wins => totalWins;
  double get winRate => totalWinRate;
  bool get isSkipping => false; // This will be handled by session queue
  
  // Backward compatibility for skill level (deprecated)
  @Deprecated('Use game mode preferences instead')
  int get skillLevel => 2; // Always return intermediate for backward compatibility

  @Deprecated('Use gameModesDisplay instead')
  String get skillLevelDisplay => 'Intermediate'; // Deprecated, use gameModesDisplay instead

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'plays_singles': playsSingles ? 1 : 0,
    'plays_doubles': playsDoubles ? 1 : 0,
    'plays_king_of_hill': playsKingOfHill ? 1 : 0,
    'plays_round_robin': playsRoundRobin ? 1 : 0,
    'added_at': addedAt.millisecondsSinceEpoch,
    'total_games_played': totalGamesPlayed,
    'total_wins': totalWins,
    'is_active': isActive ? 1 : 0,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
    'sync_status': syncStatus.name,
    // Backward compatibility
    'skill_level': 2, // Always save as intermediate for backward compatibility
  };

  static Player fromJson(Map<String, dynamic> json) => Player(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    playsSingles: json['plays_singles'] == 1 || json['plays_singles'] == null, // Default to true if not set
    playsDoubles: json['plays_doubles'] == 1 || json['plays_doubles'] == null, // Default to true if not set
    playsKingOfHill: json['plays_king_of_hill'] == 1 || json['plays_king_of_hill'] == null, // Default to true if not set
    playsRoundRobin: json['plays_round_robin'] == 1 || json['plays_round_robin'] == null, // Default to true if not set
    addedAt: DateTime.fromMillisecondsSinceEpoch(json['added_at']),
    totalGamesPlayed: json['total_games_played'] ?? json['games_played'] ?? 0, // Backward compatibility
    totalWins: json['total_wins'] ?? json['wins'] ?? 0, // Backward compatibility
    isActive: json['is_active'] == 1,
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
    syncStatus: SyncStatus.values.firstWhere(
      (status) => status.name == json['sync_status'],
      orElse: () => SyncStatus.local,
    ),
  );

  Player copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    bool? playsSingles,
    bool? playsDoubles,
    bool? playsKingOfHill,
    bool? playsRoundRobin,
    DateTime? addedAt,
    int? totalGamesPlayed,
    int? totalWins,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      playsSingles: playsSingles ?? this.playsSingles,
      playsDoubles: playsDoubles ?? this.playsDoubles,
      playsKingOfHill: playsKingOfHill ?? this.playsKingOfHill,
      playsRoundRobin: playsRoundRobin ?? this.playsRoundRobin,
      addedAt: addedAt ?? this.addedAt,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalWins: totalWins ?? this.totalWins,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(), // Always update timestamp on changes
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}