import 'package:uuid/uuid.dart';

enum UndoOperationType {
  matchCreation,
  playerSkip,
  playerCheckIn,
  playerCheckOut,
  queueReorder,
  matchEnd,
}

class UndoOperation {
  final String id;
  final UndoOperationType type;
  final String description;
  final Map<String, dynamic> data; // Store operation-specific data
  final DateTime timestamp;
  final bool canUndo;

  UndoOperation({
    String? id,
    required this.type,
    required this.description,
    required this.data,
    DateTime? timestamp,
    this.canUndo = true,
  }) : id = id ?? const Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();

  String get typeDisplay {
    switch (type) {
      case UndoOperationType.matchCreation:
        return 'Match Created';
      case UndoOperationType.playerSkip:
        return 'Player Skipped';
      case UndoOperationType.playerCheckIn:
        return 'Player Check-in';
      case UndoOperationType.playerCheckOut:
        return 'Player Check-out';
      case UndoOperationType.queueReorder:
        return 'Queue Reordered';
      case UndoOperationType.matchEnd:
        return 'Match Ended';
    }
  }

  String get timeDisplay {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'description': description,
    'data': data,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'can_undo': canUndo ? 1 : 0,
  };

  static UndoOperation fromJson(Map<String, dynamic> json) => UndoOperation(
    id: json['id'],
    type: UndoOperationType.values.firstWhere(
      (type) => type.name == json['type'],
      orElse: () => UndoOperationType.matchCreation,
    ),
    description: json['description'],
    data: Map<String, dynamic>.from(json['data']),
    timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    canUndo: json['can_undo'] == 1,
  );

  UndoOperation copyWith({
    String? id,
    UndoOperationType? type,
    String? description,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    bool? canUndo,
  }) {
    return UndoOperation(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      canUndo: canUndo ?? this.canUndo,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UndoOperation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UndoOperation(type: ${type.name}, description: $description, time: $timeDisplay)';
}

// Factory methods for creating specific undo operations
class UndoOperationFactory {
  static UndoOperation matchCreation({
    required String matchId,
    required String courtId,
    required List<String> playerIds,
    required String description,
  }) {
    return UndoOperation(
      type: UndoOperationType.matchCreation,
      description: description,
      data: {
        'matchId': matchId,
        'courtId': courtId,
        'playerIds': playerIds,
      },
    );
  }

  static UndoOperation playerSkip({
    required String playerId,
    required String playerName,
    required int oldPosition,
    required int newPosition,
  }) {
    return UndoOperation(
      type: UndoOperationType.playerSkip,
      description: 'Skipped $playerName',
      data: {
        'playerId': playerId,
        'playerName': playerName,
        'oldPosition': oldPosition,
        'newPosition': newPosition,
      },
    );
  }

  static UndoOperation playerCheckIn({
    required String playerId,
    required String playerName,
    required String sessionId,
  }) {
    return UndoOperation(
      type: UndoOperationType.playerCheckIn,
      description: 'Checked in $playerName',
      data: {
        'playerId': playerId,
        'playerName': playerName,
        'sessionId': sessionId,
      },
    );
  }

  static UndoOperation queueReorder({
    required String playerId,
    required String playerName,
    required int oldPosition,
    required int newPosition,
  }) {
    return UndoOperation(
      type: UndoOperationType.queueReorder,
      description: 'Moved $playerName in queue',
      data: {
        'playerId': playerId,
        'playerName': playerName,
        'oldPosition': oldPosition,
        'newPosition': newPosition,
      },
    );
  }
}