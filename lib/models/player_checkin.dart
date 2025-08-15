import 'package:uuid/uuid.dart';
import 'enums.dart';

class PlayerCheckIn {
  final String id;
  final String playerId;
  final String sessionId;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final int preferenceTier; // 1-3 skill level for this session
  final int gamesPlayedSession;
  final int winsSession;
  final bool isCurrentlyPlaying;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;

  PlayerCheckIn({
    String? id,
    required this.playerId,
    required this.sessionId,
    DateTime? checkInTime,
    this.checkOutTime,
    this.preferenceTier = 2, // Default to middle skill level
    this.gamesPlayedSession = 0,
    this.winsSession = 0,
    this.isCurrentlyPlaying = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.syncStatus = SyncStatus.local,
  }) : id = id ?? const Uuid().v4(),
       checkInTime = checkInTime ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  bool get isCheckedIn => checkOutTime == null;
  
  double get sessionWinRate => gamesPlayedSession > 0 ? winsSession / gamesPlayedSession : 0.0;
  
  Duration get sessionDuration {
    final endTime = checkOutTime ?? DateTime.now();
    return endTime.difference(checkInTime);
  }

  String get preferenceTierDisplay {
    switch (preferenceTier) {
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

  String get checkInTimeDisplay {
    final hour = checkInTime.hour > 12 ? checkInTime.hour - 12 : (checkInTime.hour == 0 ? 12 : checkInTime.hour);
    final period = checkInTime.hour >= 12 ? 'PM' : 'AM';
    final minute = checkInTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'player_id': playerId,
    'session_id': sessionId,
    'check_in_time': checkInTime.millisecondsSinceEpoch,
    'check_out_time': checkOutTime?.millisecondsSinceEpoch,
    'preference_tier': preferenceTier,
    'games_played_session': gamesPlayedSession,
    'wins_session': winsSession,
    'is_currently_playing': isCurrentlyPlaying ? 1 : 0,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
    'sync_status': syncStatus.name,
  };

  static PlayerCheckIn fromJson(Map<String, dynamic> json) => PlayerCheckIn(
    id: json['id'],
    playerId: json['player_id'],
    sessionId: json['session_id'],
    checkInTime: DateTime.fromMillisecondsSinceEpoch(json['check_in_time']),
    checkOutTime: json['check_out_time'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(json['check_out_time'])
        : null,
    preferenceTier: json['preference_tier'] ?? 2,
    gamesPlayedSession: json['games_played_session'] ?? 0,
    winsSession: json['wins_session'] ?? 0,
    isCurrentlyPlaying: json['is_currently_playing'] == 1,
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
    syncStatus: SyncStatus.values.firstWhere(
      (status) => status.name == json['sync_status'],
      orElse: () => SyncStatus.local,
    ),
  );

  PlayerCheckIn copyWith({
    String? id,
    String? playerId,
    String? sessionId,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    int? preferenceTier,
    int? gamesPlayedSession,
    int? winsSession,
    bool? isCurrentlyPlaying,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return PlayerCheckIn(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      sessionId: sessionId ?? this.sessionId,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      preferenceTier: preferenceTier ?? this.preferenceTier,
      gamesPlayedSession: gamesPlayedSession ?? this.gamesPlayedSession,
      winsSession: winsSession ?? this.winsSession,
      isCurrentlyPlaying: isCurrentlyPlaying ?? this.isCurrentlyPlaying,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(), // Always update timestamp on changes
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerCheckIn &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlayerCheckIn(id: $id, playerId: $playerId, sessionId: $sessionId, isCheckedIn: $isCheckedIn)';
}