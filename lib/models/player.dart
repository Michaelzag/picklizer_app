import 'package:uuid/uuid.dart';
import 'enums.dart';

class Player {
  final String id;
  final String name;
  final String? phone; // NEW: Optional for future features
  final String? email; // NEW: Optional for future features
  final int skillLevel; // NEW: Default skill level (1-3)
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
    this.skillLevel = 2, // Default to intermediate
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

  String get skillLevelDisplay {
    switch (skillLevel) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Intermediate';
      case 3:
        return 'Advanced';
      default:
        return 'Intermediate';
    }
  }

  // Backward compatibility getters
  int get gamesPlayed => totalGamesPlayed;
  int get wins => totalWins;
  double get winRate => totalWinRate;
  bool get isSkipping => false; // This will be handled by session queue

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'skill_level': skillLevel,
    'added_at': addedAt.millisecondsSinceEpoch,
    'total_games_played': totalGamesPlayed,
    'total_wins': totalWins,
    'is_active': isActive ? 1 : 0,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
    'sync_status': syncStatus.name,
  };

  static Player fromJson(Map<String, dynamic> json) => Player(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    skillLevel: json['skill_level'] ?? 2,
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
    int? skillLevel,
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
      skillLevel: skillLevel ?? this.skillLevel,
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