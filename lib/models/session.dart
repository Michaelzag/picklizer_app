import 'package:uuid/uuid.dart';
import 'enums.dart';

class Session {
  final String id;
  final String facilityId;
  final DateTime sessionDate;
  final DateTime startTime;
  final DateTime? endTime;
  final SessionStatus status;
  final int courtsAllocated;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;

  Session({
    String? id,
    required this.facilityId,
    DateTime? sessionDate,
    DateTime? startTime,
    this.endTime,
    this.status = SessionStatus.active,
    this.courtsAllocated = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.syncStatus = SyncStatus.local,
  }) : id = id ?? const Uuid().v4(),
       sessionDate = sessionDate ?? DateTime.now(),
       startTime = startTime ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Duration? get duration {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return status.isActive ? DateTime.now().difference(startTime) : null;
  }

  String get dateDisplay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDay = DateTime(sessionDate.year, sessionDate.month, sessionDate.day);
    
    if (sessionDay == today) {
      return 'Today';
    } else if (sessionDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${sessionDate.month}/${sessionDate.day}/${sessionDate.year}';
    }
  }

  String get timeDisplay {
    final hour = startTime.hour > 12 ? startTime.hour - 12 : (startTime.hour == 0 ? 12 : startTime.hour);
    final period = startTime.hour >= 12 ? 'PM' : 'AM';
    final minute = startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'facility_id': facilityId,
    'session_date': sessionDate.millisecondsSinceEpoch,
    'start_time': startTime.millisecondsSinceEpoch,
    'end_time': endTime?.millisecondsSinceEpoch,
    'status': status.name,
    'courts_allocated': courtsAllocated,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
    'sync_status': syncStatus.name,
  };

  static Session fromJson(Map<String, dynamic> json) => Session(
    id: json['id'],
    facilityId: json['facility_id'],
    sessionDate: DateTime.fromMillisecondsSinceEpoch(json['session_date']),
    startTime: DateTime.fromMillisecondsSinceEpoch(json['start_time']),
    endTime: json['end_time'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(json['end_time'])
        : null,
    status: SessionStatus.values.firstWhere(
      (status) => status.name == json['status'],
      orElse: () => SessionStatus.active,
    ),
    courtsAllocated: json['courts_allocated'] ?? 0,
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
    syncStatus: SyncStatus.values.firstWhere(
      (status) => status.name == json['sync_status'],
      orElse: () => SyncStatus.local,
    ),
  );

  Session copyWith({
    String? id,
    String? facilityId,
    DateTime? sessionDate,
    DateTime? startTime,
    DateTime? endTime,
    SessionStatus? status,
    int? courtsAllocated,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return Session(
      id: id ?? this.id,
      facilityId: facilityId ?? this.facilityId,
      sessionDate: sessionDate ?? this.sessionDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      courtsAllocated: courtsAllocated ?? this.courtsAllocated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(), // Always update timestamp on changes
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Session &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Session(id: $id, facilityId: $facilityId, date: $dateDisplay, status: ${status.displayName})';
}