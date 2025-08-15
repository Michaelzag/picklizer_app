import 'package:uuid/uuid.dart';
import 'enums.dart';

class QueueEntry {
  final String id;
  final String sessionId;
  final String playerId;
  final int position;
  final int skipCount;
  final int softSkipCount; // NEW: Track soft skips separately
  final int opportunitiesGiven;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;

  QueueEntry({
    String? id,
    required this.sessionId,
    required this.playerId,
    required this.position,
    this.skipCount = 0,
    this.softSkipCount = 0,
    this.opportunitiesGiven = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.syncStatus = SyncStatus.local,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'session_id': sessionId,
    'player_id': playerId,
    'position': position,
    'skip_count': skipCount,
    'soft_skip_count': softSkipCount,
    'opportunities_given': opportunitiesGiven,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
    'sync_status': syncStatus.name,
  };

  static QueueEntry fromJson(Map<String, dynamic> json) => QueueEntry(
    id: json['id'],
    sessionId: json['session_id'],
    playerId: json['player_id'],
    position: json['position'],
    skipCount: json['skip_count'] ?? 0,
    softSkipCount: json['soft_skip_count'] ?? 0,
    opportunitiesGiven: json['opportunities_given'] ?? 0,
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
    syncStatus: SyncStatus.values.firstWhere(
      (status) => status.name == json['sync_status'],
      orElse: () => SyncStatus.local,
    ),
  );

  QueueEntry copyWith({
    String? id,
    String? sessionId,
    String? playerId,
    int? position,
    int? skipCount,
    int? softSkipCount,
    int? opportunitiesGiven,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return QueueEntry(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      playerId: playerId ?? this.playerId,
      position: position ?? this.position,
      skipCount: skipCount ?? this.skipCount,
      softSkipCount: softSkipCount ?? this.softSkipCount,
      opportunitiesGiven: opportunitiesGiven ?? this.opportunitiesGiven,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(), // Always update timestamp on changes
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'QueueEntry(id: $id, sessionId: $sessionId, playerId: $playerId, position: $position)';
}