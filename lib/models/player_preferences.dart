import 'package:uuid/uuid.dart';
import 'enums.dart';
import 'court.dart';

class PlayerPreferences {
  final String id;
  final String playerId;
  final bool acceptsSinglesKingOfHill;
  final bool acceptsSinglesRoundRobin;
  final bool acceptsDoublesKingOfHill;
  final bool acceptsDoublesRoundRobin;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;

  PlayerPreferences({
    String? id,
    required this.playerId,
    this.acceptsSinglesKingOfHill = true, // Default to accepting all modes
    this.acceptsSinglesRoundRobin = true,
    this.acceptsDoublesKingOfHill = true,
    this.acceptsDoublesRoundRobin = true,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.syncStatus = SyncStatus.local,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Check if player accepts a specific game mode combination
  bool acceptsGameMode(TeamSize teamSize, GameMode gameMode) {
    switch (teamSize) {
      case TeamSize.singles:
        switch (gameMode) {
          case GameMode.kingOfHill:
            return acceptsSinglesKingOfHill;
          case GameMode.roundRobin:
            return acceptsSinglesRoundRobin;
        }
      case TeamSize.doubles:
        switch (gameMode) {
          case GameMode.kingOfHill:
            return acceptsDoublesKingOfHill;
          case GameMode.roundRobin:
            return acceptsDoublesRoundRobin;
        }
    }
  }

  // Get list of accepted game modes
  List<String> get acceptedGameModes {
    final modes = <String>[];
    if (acceptsSinglesKingOfHill) modes.add('Singles King of Hill');
    if (acceptsSinglesRoundRobin) modes.add('Singles Round Robin');
    if (acceptsDoublesKingOfHill) modes.add('Doubles King of Hill');
    if (acceptsDoublesRoundRobin) modes.add('Doubles Round Robin');
    return modes;
  }

  // Get list of rejected game modes
  List<String> get rejectedGameModes {
    final modes = <String>[];
    if (!acceptsSinglesKingOfHill) modes.add('Singles King of Hill');
    if (!acceptsSinglesRoundRobin) modes.add('Singles Round Robin');
    if (!acceptsDoublesKingOfHill) modes.add('Doubles King of Hill');
    if (!acceptsDoublesRoundRobin) modes.add('Doubles Round Robin');
    return modes;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'player_id': playerId,
    'accepts_singles_king_of_hill': acceptsSinglesKingOfHill ? 1 : 0,
    'accepts_singles_round_robin': acceptsSinglesRoundRobin ? 1 : 0,
    'accepts_doubles_king_of_hill': acceptsDoublesKingOfHill ? 1 : 0,
    'accepts_doubles_round_robin': acceptsDoublesRoundRobin ? 1 : 0,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
    'sync_status': syncStatus.name,
  };

  static PlayerPreferences fromJson(Map<String, dynamic> json) => PlayerPreferences(
    id: json['id'],
    playerId: json['player_id'],
    acceptsSinglesKingOfHill: json['accepts_singles_king_of_hill'] == 1,
    acceptsSinglesRoundRobin: json['accepts_singles_round_robin'] == 1,
    acceptsDoublesKingOfHill: json['accepts_doubles_king_of_hill'] == 1,
    acceptsDoublesRoundRobin: json['accepts_doubles_round_robin'] == 1,
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
    syncStatus: SyncStatus.values.firstWhere(
      (status) => status.name == json['sync_status'],
      orElse: () => SyncStatus.local,
    ),
  );

  PlayerPreferences copyWith({
    String? id,
    String? playerId,
    bool? acceptsSinglesKingOfHill,
    bool? acceptsSinglesRoundRobin,
    bool? acceptsDoublesKingOfHill,
    bool? acceptsDoublesRoundRobin,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return PlayerPreferences(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      acceptsSinglesKingOfHill: acceptsSinglesKingOfHill ?? this.acceptsSinglesKingOfHill,
      acceptsSinglesRoundRobin: acceptsSinglesRoundRobin ?? this.acceptsSinglesRoundRobin,
      acceptsDoublesKingOfHill: acceptsDoublesKingOfHill ?? this.acceptsDoublesKingOfHill,
      acceptsDoublesRoundRobin: acceptsDoublesRoundRobin ?? this.acceptsDoublesRoundRobin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(), // Always update timestamp on changes
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerPreferences &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlayerPreferences(id: $id, playerId: $playerId, accepted: ${acceptedGameModes.length}/4)';
}