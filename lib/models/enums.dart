enum SessionStatus { 
  active, 
  ended, 
  paused 
}

enum SyncStatus { 
  local,     // Only exists locally
  synced,    // Synced with backend
  pending,   // Waiting to sync
  conflict   // Sync conflict needs resolution
}

extension SessionStatusExtension on SessionStatus {
  String get displayName {
    switch (this) {
      case SessionStatus.active:
        return 'Active';
      case SessionStatus.ended:
        return 'Ended';
      case SessionStatus.paused:
        return 'Paused';
    }
  }
  
  bool get isActive => this == SessionStatus.active;
  bool get isEnded => this == SessionStatus.ended;
}

extension SyncStatusExtension on SyncStatus {
  String get displayName {
    switch (this) {
      case SyncStatus.local:
        return 'Local';
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.pending:
        return 'Pending';
      case SyncStatus.conflict:
        return 'Conflict';
    }
  }
  
  bool get needsSync => this == SyncStatus.pending || this == SyncStatus.conflict;
}