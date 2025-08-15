import 'package:uuid/uuid.dart';
import 'enums.dart';

enum TeamSize {
  singles,  // 1v1 (2 players)
  doubles   // 2v2 (4 players)
}

enum GameMode {
  kingOfHill,  // Winners stay, losers out
  roundRobin   // Everyone rotates
}

extension TeamSizeExtension on TeamSize {
  String get displayName {
    switch (this) {
      case TeamSize.singles:
        return 'Singles';
      case TeamSize.doubles:
        return 'Doubles';
    }
  }
  
  int get requiredPlayers => this == TeamSize.singles ? 2 : 4;
}

extension GameModeExtension on GameMode {
  String get displayName {
    switch (this) {
      case GameMode.kingOfHill:
        return 'King of Hill';
      case GameMode.roundRobin:
        return 'Round Robin';
    }
  }
}

class Court {
  final String id;
  final String facilityId; // NEW: Courts belong to facilities
  final String name;
  final TeamSize teamSize;
  final GameMode gameMode;
  final int targetScore; // NEW: Customizable target score (7, 11, 15, etc.)
  final int position; // For ordering courts in the UI
  final bool isActive; // NEW: Courts can be deactivated
  final String? currentSessionId; // NEW: Current session using this court
  List<String> currentPlayerIds;
  bool matchInProgress;
  DateTime? matchStartTime;
  final DateTime createdAt; // NEW: For sync
  final DateTime updatedAt; // NEW: For sync
  final SyncStatus syncStatus; // NEW: For sync

  Court({
    String? id,
    required this.facilityId,
    required this.name,
    required this.teamSize,
    required this.gameMode,
    this.targetScore = 11, // Default to 11 points
    this.position = 0,
    this.isActive = true,
    this.currentSessionId,
    this.currentPlayerIds = const [],
    this.matchInProgress = false,
    this.matchStartTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.syncStatus = SyncStatus.local,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  int get requiredPlayers => teamSize == TeamSize.singles ? 2 : 4;
  
  bool get isAvailable => !matchInProgress && currentPlayerIds.isEmpty;
  
  bool get isOccupied => matchInProgress && currentPlayerIds.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'id': id,
    'facility_id': facilityId,
    'name': name,
    'team_size': teamSize.index,
    'game_mode': gameMode.name,
    'target_score': targetScore,
    'win_by_two': 1, // Always 1 since win by 2 is standard pickleball rule
    'position': position,
    'is_active': isActive ? 1 : 0,
    'current_session_id': currentSessionId,
    'current_player_ids': currentPlayerIds.join(','),
    'match_in_progress': matchInProgress ? 1 : 0,
    'match_start_time': matchStartTime?.millisecondsSinceEpoch,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
    'sync_status': syncStatus.name,
  };

  static Court fromJson(Map<String, dynamic> json) => Court(
    id: json['id'],
    facilityId: json['facility_id'],
    name: json['name'],
    teamSize: TeamSize.values[json['team_size']],
    gameMode: GameMode.values.firstWhere(
      (mode) => mode.name == json['game_mode'],
      orElse: () => GameMode.roundRobin,
    ),
    targetScore: json['target_score'] ?? 11,
    position: json['position'] ?? 0,
    isActive: json['is_active'] == 1,
    currentSessionId: json['current_session_id'],
    currentPlayerIds: json['current_player_ids']?.toString().isEmpty ?? true
        ? []
        : json['current_player_ids'].toString().split(','),
    matchInProgress: json['match_in_progress'] == 1,
    matchStartTime: json['match_start_time'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['match_start_time'])
        : null,
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
    syncStatus: SyncStatus.values.firstWhere(
      (status) => status.name == json['sync_status'],
      orElse: () => SyncStatus.local,
    ),
  );

  Court copyWith({
    String? id,
    String? facilityId,
    String? name,
    TeamSize? teamSize,
    GameMode? gameMode,
    int? targetScore,
    int? position,
    bool? isActive,
    String? currentSessionId,
    List<String>? currentPlayerIds,
    bool? matchInProgress,
    DateTime? matchStartTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return Court(
      id: id ?? this.id,
      facilityId: facilityId ?? this.facilityId,
      name: name ?? this.name,
      teamSize: teamSize ?? this.teamSize,
      gameMode: gameMode ?? this.gameMode,
      targetScore: targetScore ?? this.targetScore,
      position: position ?? this.position,
      isActive: isActive ?? this.isActive,
      currentSessionId: currentSessionId ?? this.currentSessionId,
      currentPlayerIds: currentPlayerIds ?? this.currentPlayerIds,
      matchInProgress: matchInProgress ?? this.matchInProgress,
      matchStartTime: matchStartTime ?? this.matchStartTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(), // Always update timestamp on changes
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}