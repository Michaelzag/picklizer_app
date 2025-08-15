import 'package:uuid/uuid.dart';
import 'enums.dart';

class Match {
  final String id;
  final String sessionId; // NEW: Matches belong to sessions
  final String courtId;
  final List<String> team1PlayerIds;
  final List<String> team2PlayerIds;
  int team1Score;
  int team2Score;
  final DateTime startTime;
  DateTime? endTime;
  bool completed;
  final DateTime createdAt; // NEW: For sync
  final DateTime updatedAt; // NEW: For sync
  final SyncStatus syncStatus; // NEW: For sync

  Match({
    String? id,
    required this.sessionId,
    required this.courtId,
    required this.team1PlayerIds,
    required this.team2PlayerIds,
    this.team1Score = 0,
    this.team2Score = 0,
    DateTime? startTime,
    this.endTime,
    this.completed = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.syncStatus = SyncStatus.local,
  }) : id = id ?? const Uuid().v4(),
       startTime = startTime ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Duration? get duration => endTime?.difference(startTime);

  String get scoreDisplay => '$team1Score - $team2Score';

  List<String> get winnerIds {
    if (!completed) return [];
    return team1Score > team2Score ? team1PlayerIds : team2PlayerIds;
  }

  List<String> get loserIds {
    if (!completed) return [];
    return team1Score > team2Score ? team2PlayerIds : team1PlayerIds;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'session_id': sessionId,
    'court_id': courtId,
    'team1_players': team1PlayerIds.join(','),
    'team2_players': team2PlayerIds.join(','),
    'team1_score': team1Score,
    'team2_score': team2Score,
    'start_time': startTime.millisecondsSinceEpoch,
    'end_time': endTime?.millisecondsSinceEpoch,
    'completed': completed ? 1 : 0,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
    'sync_status': syncStatus.name,
  };

  static Match fromJson(Map<String, dynamic> json) => Match(
    id: json['id'],
    sessionId: json['session_id'],
    courtId: json['court_id'],
    team1PlayerIds: json['team1_players'].toString().split(','),
    team2PlayerIds: json['team2_players'].toString().split(','),
    team1Score: json['team1_score'] ?? 0,
    team2Score: json['team2_score'] ?? 0,
    startTime: DateTime.fromMillisecondsSinceEpoch(json['start_time']),
    endTime: json['end_time'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['end_time'])
        : null,
    completed: json['completed'] == 1,
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
    syncStatus: SyncStatus.values.firstWhere(
      (status) => status.name == json['sync_status'],
      orElse: () => SyncStatus.local,
    ),
  );

  Match copyWith({
    String? id,
    String? sessionId,
    String? courtId,
    List<String>? team1PlayerIds,
    List<String>? team2PlayerIds,
    int? team1Score,
    int? team2Score,
    DateTime? startTime,
    DateTime? endTime,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return Match(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      courtId: courtId ?? this.courtId,
      team1PlayerIds: team1PlayerIds ?? this.team1PlayerIds,
      team2PlayerIds: team2PlayerIds ?? this.team2PlayerIds,
      team1Score: team1Score ?? this.team1Score,
      team2Score: team2Score ?? this.team2Score,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(), // Always update timestamp on changes
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}