import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/facility.dart';
import '../models/session.dart';
import '../models/player.dart';
import '../models/player_checkin.dart';
import '../models/player_preferences.dart';
import '../models/queue_entry.dart';
import '../models/undo_operation.dart';
import '../models/court.dart';
import '../models/enums.dart';
import '../services/enhanced_storage_service.dart';
import '../services/rotation_service.dart';

// Service Providers
final enhancedStorageServiceProvider = Provider<EnhancedStorageService>((ref) {
  return EnhancedStorageService();
});

final rotationServiceProvider = Provider<RotationService>((ref) {
  return RotationService();
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// Facility Providers
final facilitiesProvider = StateNotifierProvider<FacilitiesNotifier, List<Facility>>((ref) {
  return FacilitiesNotifier(ref);
});

class FacilitiesNotifier extends StateNotifier<List<Facility>> {
  final Ref ref;
  
  FacilitiesNotifier(this.ref) : super([]) {
    loadFacilities();
  }

  Future<void> loadFacilities() async {
    if (!mounted) return;
    final storage = ref.read(enhancedStorageServiceProvider);
    final facilities = await storage.getAllFacilities();
    if (!mounted) return;
    state = facilities;
  }

  Future<void> addFacility({
    required String name,
    String? location,
  }) async {
    final storage = ref.read(enhancedStorageServiceProvider);
    final facility = Facility(
      name: name,
      location: location,
    );
    
    await storage.saveFacility(facility);
    state = [...state, facility];
  }

  Future<void> updateFacility(Facility facility) async {
    final storage = ref.read(enhancedStorageServiceProvider);
    await storage.updateFacility(facility);
    state = state.map((f) => f.id == facility.id ? facility : f).toList();
  }

  Future<void> removeFacility(String facilityId) async {
    final storage = ref.read(enhancedStorageServiceProvider);
    await storage.deleteFacility(facilityId);
    state = state.where((f) => f.id != facilityId).toList();
  }
}

// Session Providers
final currentSessionProvider = StateNotifierProvider<CurrentSessionNotifier, Session?>((ref) {
  return CurrentSessionNotifier(ref);
});

class CurrentSessionNotifier extends StateNotifier<Session?> {
  final Ref ref;
  
  CurrentSessionNotifier(this.ref) : super(null) {
    loadActiveSession();
  }

  Future<void> loadActiveSession() async {
    if (!mounted) return;
    final storage = ref.read(enhancedStorageServiceProvider);
    final session = await storage.getActiveSession();
    if (!mounted) return;
    state = session;
  }

  Future<void> startNewSession({
    required String facilityId,
  }) async {
    final storage = ref.read(enhancedStorageServiceProvider);
    
    // End any existing active session
    if (state != null) {
      await endCurrentSession();
    }
    
    final session = Session(
      facilityId: facilityId,
    );
    
    await storage.saveSession(session);
    state = session;
    
    // Notify other providers
    ref.invalidate(sessionCheckInsProvider);
    ref.invalidate(sessionQueueProvider);
  }

  Future<void> endCurrentSession() async {
    if (state == null) return;
    
    final storage = ref.read(enhancedStorageServiceProvider);
    final endedSession = state!.copyWith(
      status: SessionStatus.ended,
      endTime: DateTime.now(),
    );
    
    await storage.updateSession(endedSession);
    state = null;
    
    // Clear session-specific data
    ref.invalidate(sessionCheckInsProvider);
    ref.invalidate(sessionQueueProvider);
  }

  Future<void> pauseSession() async {
    if (state == null) return;
    
    final storage = ref.read(enhancedStorageServiceProvider);
    final pausedSession = state!.copyWith(
      status: SessionStatus.paused,
    );
    
    await storage.updateSession(pausedSession);
    state = pausedSession;
  }

  Future<void> resumeSession() async {
    if (state == null) return;
    
    final storage = ref.read(enhancedStorageServiceProvider);
    final resumedSession = state!.copyWith(
      status: SessionStatus.active,
    );
    
    await storage.updateSession(resumedSession);
    state = resumedSession;
  }
}

// Enhanced Players Provider
final enhancedPlayersProvider = StateNotifierProvider<EnhancedPlayersNotifier, List<Player>>((ref) {
  return EnhancedPlayersNotifier(ref);
});

class EnhancedPlayersNotifier extends StateNotifier<List<Player>> {
  final Ref ref;
  
  EnhancedPlayersNotifier(this.ref) : super([]) {
    loadPlayers();
  }

  Future<void> loadPlayers() async {
    if (!mounted) return;
    final storage = ref.read(enhancedStorageServiceProvider);
    final players = await storage.getAllPlayers();
    if (!mounted) return;
    state = players;
  }

  Future<void> addPlayer({
    required String name,
    String? phone,
    String? email,
    int skillLevel = 2,
  }) async {
    if (name.trim().isEmpty) return;
    
    final storage = ref.read(enhancedStorageServiceProvider);
    final player = Player(
      name: name.trim(),
      phone: phone,
      email: email,
      skillLevel: skillLevel,
    );
    
    await storage.savePlayer(player);
    
    // Create default preferences (accepts all game modes)
    final preferences = PlayerPreferences(playerId: player.id);
    await storage.savePlayerPreferences(preferences);
    
    state = [...state, player];
  }

  Future<void> updatePlayer(Player player) async {
    final storage = ref.read(enhancedStorageServiceProvider);
    await storage.updatePlayer(player);
    state = state.map((p) => p.id == player.id ? player : p).toList();
  }

  Future<void> removePlayer(String playerId) async {
    final storage = ref.read(enhancedStorageServiceProvider);
    await storage.deletePlayer(playerId);
    state = state.where((p) => p.id != playerId).toList();
  }

  Player? getPlayer(String id) {
    try {
      return state.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

// Session Check-ins Provider
final sessionCheckInsProvider = StateNotifierProvider<SessionCheckInsNotifier, List<PlayerCheckIn>>((ref) {
  return SessionCheckInsNotifier(ref);
});

class SessionCheckInsNotifier extends StateNotifier<List<PlayerCheckIn>> {
  final Ref ref;
  
  SessionCheckInsNotifier(this.ref) : super([]) {
    loadCheckIns();
  }

  Future<void> loadCheckIns() async {
    if (!mounted) return;
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) {
      state = [];
      return;
    }
    
    final storage = ref.read(enhancedStorageServiceProvider);
    final checkIns = await storage.getSessionCheckIns(currentSession.id);
    if (!mounted) return;
    state = checkIns;
  }

  Future<void> checkInPlayer({
    required String playerId,
    int preferenceTier = 2,
  }) async {
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return;
    
    final storage = ref.read(enhancedStorageServiceProvider);
    final checkIn = PlayerCheckIn(
      playerId: playerId,
      sessionId: currentSession.id,
      preferenceTier: preferenceTier,
    );
    
    await storage.savePlayerCheckIn(checkIn);
    state = [...state, checkIn];
    
    // Add to queue
    await ref.read(sessionQueueProvider.notifier).addPlayerToQueue(playerId);
    
    // Record undo operation
    final player = ref.read(enhancedPlayersProvider.notifier).getPlayer(playerId);
    if (player != null) {
      final undoOp = UndoOperationFactory.playerCheckIn(
        playerId: playerId,
        playerName: player.name,
        sessionId: currentSession.id,
      );
      await storage.saveUndoOperation(undoOp);
    }
  }

  Future<void> checkOutPlayer(String playerId) async {
    final checkIn = state.firstWhere((c) => c.playerId == playerId && c.isCheckedIn);
    final updatedCheckIn = checkIn.copyWith(checkOutTime: DateTime.now());
    
    final storage = ref.read(enhancedStorageServiceProvider);
    await storage.updatePlayerCheckIn(updatedCheckIn);
    
    state = state.map((c) => c.id == checkIn.id ? updatedCheckIn : c).toList();
    
    // Remove from queue
    await ref.read(sessionQueueProvider.notifier).removePlayerFromQueue(playerId);
  }

  bool isPlayerCheckedIn(String playerId) {
    return state.any((c) => c.playerId == playerId && c.isCheckedIn);
  }
}

// Session Queue Provider
final sessionQueueProvider = StateNotifierProvider<SessionQueueNotifier, List<QueueEntry>>((ref) {
  return SessionQueueNotifier(ref);
});

class SessionQueueNotifier extends StateNotifier<List<QueueEntry>> {
  final Ref ref;
  
  SessionQueueNotifier(this.ref) : super([]) {
    loadQueue();
  }

  Future<void> loadQueue() async {
    if (!mounted) return;
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) {
      state = [];
      return;
    }
    
    final storage = ref.read(enhancedStorageServiceProvider);
    final queue = await storage.getSessionQueue(currentSession.id);
    if (!mounted) return;
    state = queue;
  }

  Future<void> addPlayerToQueue(String playerId) async {
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return;
    
    final storage = ref.read(enhancedStorageServiceProvider);
    final entry = QueueEntry(
      sessionId: currentSession.id,
      playerId: playerId,
      position: state.length,
    );
    
    await storage.saveQueueEntry(entry);
    state = [...state, entry];
  }

  Future<void> removePlayerFromQueue(String playerId) async {
    final storage = ref.read(enhancedStorageServiceProvider);
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return;
    
    // Remove from database
    await storage.clearSessionQueue(currentSession.id);
    
    // Update state and reposition
    final newQueue = state.where((e) => e.playerId != playerId).toList();
    for (int i = 0; i < newQueue.length; i++) {
      final updatedEntry = newQueue[i].copyWith(position: i);
      await storage.saveQueueEntry(updatedEntry);
      newQueue[i] = updatedEntry;
    }
    
    state = newQueue;
  }

  Future<void> skipPlayer(String playerId) async {
    await hardSkipPlayer(playerId);
  }

  Future<void> hardSkipPlayer(String playerId) async {
    final playerIndex = state.indexWhere((e) => e.playerId == playerId);
    if (playerIndex == -1) return;
    
    final storage = ref.read(enhancedStorageServiceProvider);
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return;
    
    // Record undo operation
    final player = ref.read(enhancedPlayersProvider.notifier).getPlayer(playerId);
    if (player != null) {
      final undoOp = UndoOperationFactory.playerSkip(
        playerId: playerId,
        playerName: player.name,
        oldPosition: playerIndex,
        newPosition: state.length - 1,
      );
      await storage.saveUndoOperation(undoOp);
    }
    
    // Move player to end
    final newQueue = [...state];
    final skippedEntry = newQueue.removeAt(playerIndex);
    final updatedSkippedEntry = skippedEntry.copyWith(
      position: newQueue.length,
      skipCount: skippedEntry.skipCount + 1,
    );
    newQueue.add(updatedSkippedEntry);
    
    // Update positions
    await storage.clearSessionQueue(currentSession.id);
    for (int i = 0; i < newQueue.length; i++) {
      final updatedEntry = newQueue[i].copyWith(position: i);
      await storage.saveQueueEntry(updatedEntry);
      newQueue[i] = updatedEntry;
    }
    
    state = newQueue;
  }

  Future<void> softSkipPlayer(String playerId) async {
    final playerIndex = state.indexWhere((e) => e.playerId == playerId);
    if (playerIndex == -1) return;
    
    final storage = ref.read(enhancedStorageServiceProvider);
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return;
    
    // Record undo operation
    final player = ref.read(enhancedPlayersProvider.notifier).getPlayer(playerId);
    if (player != null) {
      final undoOp = UndoOperationFactory.playerSkip(
        playerId: playerId,
        playerName: player.name,
        oldPosition: playerIndex,
        newPosition: playerIndex, // Same position for soft skip
      );
      await storage.saveUndoOperation(undoOp);
    }
    
    // Update soft skip count but keep position
    final newQueue = [...state];
    final skippedEntry = newQueue[playerIndex];
    final updatedSkippedEntry = skippedEntry.copyWith(
      softSkipCount: skippedEntry.softSkipCount + 1,
    );
    newQueue[playerIndex] = updatedSkippedEntry;
    
    // Save updated entry
    await storage.saveQueueEntry(updatedSkippedEntry);
    state = newQueue;
  }

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final storage = ref.read(enhancedStorageServiceProvider);
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return;
    
    // Record undo operation
    final movedEntry = state[oldIndex];
    final player = ref.read(enhancedPlayersProvider.notifier).getPlayer(movedEntry.playerId);
    if (player != null) {
      final undoOp = UndoOperationFactory.queueReorder(
        playerId: movedEntry.playerId,
        playerName: player.name,
        oldPosition: oldIndex,
        newPosition: newIndex,
      );
      await storage.saveUndoOperation(undoOp);
    }
    
    final newQueue = [...state];
    final entry = newQueue.removeAt(oldIndex);
    newQueue.insert(newIndex, entry);
    
    // Update positions
    await storage.clearSessionQueue(currentSession.id);
    for (int i = 0; i < newQueue.length; i++) {
      final updatedEntry = newQueue[i].copyWith(position: i);
      await storage.saveQueueEntry(updatedEntry);
      newQueue[i] = updatedEntry;
    }
    
    state = newQueue;
  }
}

// Undo Operations Provider
final undoOperationsProvider = StateNotifierProvider<UndoOperationsNotifier, List<UndoOperation>>((ref) {
  return UndoOperationsNotifier(ref);
});

class UndoOperationsNotifier extends StateNotifier<List<UndoOperation>> {
  final Ref ref;
  
  UndoOperationsNotifier(this.ref) : super([]) {
    loadRecentOperations();
  }

  Future<void> loadRecentOperations() async {
    if (!mounted) return;
    final storage = ref.read(enhancedStorageServiceProvider);
    final operations = await storage.getRecentUndoOperations();
    if (!mounted) return;
    state = operations;
  }

  Future<bool> undoLastOperation() async {
    if (state.isEmpty) return false;
    
    final operation = state.first;
    final storage = ref.read(enhancedStorageServiceProvider);
    
    // Mark operation as used
    await storage.markUndoOperationUsed(operation.id);
    
    // Perform undo based on operation type
    bool success = false;
    switch (operation.type) {
      case UndoOperationType.playerSkip:
        success = await _undoPlayerSkip(operation);
        break;
      case UndoOperationType.playerCheckIn:
        success = await _undoPlayerCheckIn(operation);
        break;
      case UndoOperationType.queueReorder:
        success = await _undoQueueReorder(operation);
        break;
      default:
        // Other undo operations can be implemented as needed
        break;
    }
    
    if (success) {
      // Reload operations
      await loadRecentOperations();
    }
    
    return success;
  }

  Future<bool> _undoPlayerSkip(UndoOperation operation) async {
    final playerId = operation.data['playerId'] as String;
    final oldPosition = operation.data['oldPosition'] as int;
    
    // Move player back to original position
    final queueNotifier = ref.read(sessionQueueProvider.notifier);
    final currentIndex = ref.read(sessionQueueProvider).indexWhere((e) => e.playerId == playerId);
    
    if (currentIndex != -1) {
      await queueNotifier.reorderQueue(currentIndex, oldPosition);
      return true;
    }
    
    return false;
  }

  Future<bool> _undoPlayerCheckIn(UndoOperation operation) async {
    final playerId = operation.data['playerId'] as String;
    
    // Check out the player
    await ref.read(sessionCheckInsProvider.notifier).checkOutPlayer(playerId);
    return true;
  }

  Future<bool> _undoQueueReorder(UndoOperation operation) async {
    final playerId = operation.data['playerId'] as String;
    final oldPosition = operation.data['oldPosition'] as int;
    
    // Move player back to original position
    final queueNotifier = ref.read(sessionQueueProvider.notifier);
    final currentIndex = ref.read(sessionQueueProvider).indexWhere((e) => e.playerId == playerId);
    
    if (currentIndex != -1) {
      await queueNotifier.reorderQueue(currentIndex, oldPosition);
      return true;
    }
    
    return false;
  }
}

// Loading State Provider
final isLoadingProvider = StateProvider<bool>((ref) => false);

// Error State Provider
final errorMessageProvider = StateProvider<String?>((ref) => null);

// Facility Courts Provider
final facilityCourtsProvider = FutureProvider.family<List<Court>, String>((ref, facilityId) async {
  if (facilityId.isEmpty) return [];
  final storage = ref.read(enhancedStorageServiceProvider);
  return await storage.getCourtsByFacility(facilityId);
});

// Session Checked-in Players Provider
final sessionCheckedInPlayersProvider = Provider<List<Player>>((ref) {
  final checkIns = ref.watch(sessionCheckInsProvider);
  final players = ref.watch(enhancedPlayersProvider);
  
  final checkedInPlayerIds = checkIns
      .where((checkIn) => checkIn.isCheckedIn)
      .map((checkIn) => checkIn.playerId)
      .toSet();
  
  return players.where((player) => checkedInPlayerIds.contains(player.id)).toList();
});