import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/court.dart';
import '../models/player.dart';
import '../models/match.dart';
import '../services/storage_service.dart';
import '../services/rotation_service.dart';

// Service Providers
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final rotationServiceProvider = Provider<RotationService>((ref) {
  return RotationService();
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// State Providers
final courtsProvider = StateNotifierProvider<CourtsNotifier, List<Court>>((ref) {
  return CourtsNotifier(ref);
});

final playersProvider = StateNotifierProvider<PlayersNotifier, List<Player>>((ref) {
  return PlayersNotifier(ref);
});

final queueProvider = StateNotifierProvider<QueueNotifier, List<Player>>((ref) {
  return QueueNotifier(ref);
});

final matchesProvider = StateNotifierProvider<MatchesNotifier, MatchState>((ref) {
  return MatchesNotifier(ref);
});

// Loading State Provider
final isLoadingProvider = StateProvider<bool>((ref) => false);

// Error State Provider
final errorMessageProvider = StateProvider<String?>((ref) => null);

// Locale Provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier(ref);
});

// Courts Notifier
class CourtsNotifier extends StateNotifier<List<Court>> {
  final Ref ref;
  
  CourtsNotifier(this.ref) : super([]) {
    loadCourts();
  }

  Future<void> loadCourts() async {
    if (!mounted) return;
    final storage = ref.read(storageServiceProvider);
    final courts = await storage.getAllCourts();
    if (!mounted) return;
    state = courts;
  }

  Future<void> addCourt({
    required String facilityId,
    required String name,
    required TeamSize teamSize,
    required GameMode gameMode,
  }) async {
    final storage = ref.read(storageServiceProvider);
    final court = Court(
      facilityId: facilityId,
      name: name,
      teamSize: teamSize,
      gameMode: gameMode,
      position: state.length,
    );
    
    await storage.saveCourt(court);
    state = [...state, court];
  }

  Future<void> updateCourt(Court court) async {
    final storage = ref.read(storageServiceProvider);
    await storage.updateCourt(court);
    state = state.map((c) => c.id == court.id ? court : c).toList();
  }

  Future<void> removeCourt(String courtId) async {
    final storage = ref.read(storageServiceProvider);
    await storage.deleteCourt(courtId);
    state = state.where((c) => c.id != courtId).toList();
  }
}

// Players Notifier
class PlayersNotifier extends StateNotifier<List<Player>> {
  final Ref ref;
  
  PlayersNotifier(this.ref) : super([]) {
    loadPlayers();
  }

  Future<void> loadPlayers() async {
    if (!mounted) return;
    final storage = ref.read(storageServiceProvider);
    final players = await storage.getAllPlayers();
    if (!mounted) return;
    state = players;
  }

  Future<void> addPlayer(String name) async {
    if (name.trim().isEmpty) return;
    
    final storage = ref.read(storageServiceProvider);
    final player = Player(name: name.trim());
    
    await storage.savePlayer(player);
    state = [...state, player];
    
    // Also add to queue
    ref.read(queueProvider.notifier).addToQueue(player);
  }

  Future<void> updatePlayer(Player player) async {
    final storage = ref.read(storageServiceProvider);
    await storage.updatePlayer(player);
    state = state.map((p) => p.id == player.id ? player : p).toList();
  }

  Future<void> removePlayer(String playerId) async {
    final storage = ref.read(storageServiceProvider);
    await storage.deletePlayer(playerId);
    state = state.where((p) => p.id != playerId).toList();
    
    // Also remove from queue
    ref.read(queueProvider.notifier).removeFromQueue(playerId);
  }

  Player? getPlayer(String id) {
    try {
      return state.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

// Queue Notifier
class QueueNotifier extends StateNotifier<List<Player>> {
  final Ref ref;
  
  QueueNotifier(this.ref) : super([]) {
    loadQueue();
  }

  Future<void> loadQueue() async {
    if (!mounted) return;
    final storage = ref.read(storageServiceProvider);
    final queue = await storage.loadQueue();
    if (!mounted) return;
    state = queue;
  }

  void addToQueue(Player player) {
    state = [...state, player];
    _saveQueue();
  }

  void removeFromQueue(String playerId) {
    state = state.where((p) => p.id != playerId).toList();
    _saveQueue();
  }

  void skipPlayer(String playerId) {
    final index = state.indexWhere((p) => p.id == playerId);
    if (index != -1) {
      final player = state[index];
      final newState = [...state];
      newState.removeAt(index);
      newState.add(player);
      state = newState;
      _saveQueue();
    }
  }

  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final newState = [...state];
    final player = newState.removeAt(oldIndex);
    newState.insert(newIndex, player);
    state = newState;
    _saveQueue();
  }

  List<Player> takePlayersForMatch(int count) {
    if (state.length < count) return [];
    
    final players = state.take(count).toList();
    state = state.skip(count).toList();
    _saveQueue();
    return players;
  }

  void addPlayersToQueue(List<Player> players) {
    state = [...state, ...players];
    _saveQueue();
  }

  Future<void> _saveQueue() async {
    if (!mounted) return;
    final storage = ref.read(storageServiceProvider);
    await storage.saveQueue(state);
  }
}

// Match State
class MatchState {
  final List<Match> todaysMatches;
  final Map<String, Match> activeMatches;

  MatchState({
    this.todaysMatches = const [],
    this.activeMatches = const {},
  });

  MatchState copyWith({
    List<Match>? todaysMatches,
    Map<String, Match>? activeMatches,
  }) {
    return MatchState(
      todaysMatches: todaysMatches ?? this.todaysMatches,
      activeMatches: activeMatches ?? this.activeMatches,
    );
  }
}

// Matches Notifier
class MatchesNotifier extends StateNotifier<MatchState> {
  final Ref ref;
  
  MatchesNotifier(this.ref) : super(MatchState()) {
    loadMatches();
  }

  Future<void> loadMatches() async {
    if (!mounted) return;
    final storage = ref.read(storageServiceProvider);
    final matches = await storage.getTodaysMatches();
    
    if (!mounted) return;
    
    // Rebuild active matches map
    final activeMatches = <String, Match>{};
    final courts = ref.read(courtsProvider);
    
    for (final court in courts) {
      if (court.matchInProgress) {
        try {
          final match = matches.firstWhere(
            (m) => m.courtId == court.id && !m.completed,
          );
          activeMatches[court.id] = match;
        } catch (_) {
          // No active match found for this court
        }
      }
    }
    
    if (!mounted) return;
    state = MatchState(
      todaysMatches: matches,
      activeMatches: activeMatches,
    );
  }

  Future<void> startMatch(String courtId) async {
    final courts = ref.read(courtsProvider);
    final court = courts.firstWhere((c) => c.id == courtId);
    final queue = ref.read(queueProvider);
    final storage = ref.read(storageServiceProvider);
    
    if (queue.length < court.requiredPlayers) {
      ref.read(errorMessageProvider.notifier).state = 'Not enough players in queue';
      return;
    }
    
    // Take players from queue
    final matchPlayers = ref.read(queueProvider.notifier).takePlayersForMatch(court.requiredPlayers);
    
    // Create teams
    final team1PlayerIds = <String>[];
    final team2PlayerIds = <String>[];
    
    if (court.teamSize == TeamSize.singles) {
      team1PlayerIds.add(matchPlayers[0].id);
      team2PlayerIds.add(matchPlayers[1].id);
    } else {
      team1PlayerIds.addAll([matchPlayers[0].id, matchPlayers[1].id]);
      team2PlayerIds.addAll([matchPlayers[2].id, matchPlayers[3].id]);
    }
    
    // Create match
    final match = Match(
      sessionId: 'temp-session-id', // TODO: Get from current session
      courtId: courtId,
      team1PlayerIds: team1PlayerIds,
      team2PlayerIds: team2PlayerIds,
    );
    
    await storage.saveMatch(match);
    
    // Update court
    final updatedCourt = court.copyWith(
      currentPlayerIds: matchPlayers.map((p) => p.id).toList(),
      matchInProgress: true,
      matchStartTime: match.startTime,
    );
    await ref.read(courtsProvider.notifier).updateCourt(updatedCourt);
    
    // Update state
    final newActiveMatches = {...state.activeMatches, courtId: match};
    final newTodaysMatches = [...state.todaysMatches, match];
    
    state = state.copyWith(
      activeMatches: newActiveMatches,
      todaysMatches: newTodaysMatches,
    );
  }

  Future<void> updateScore(String courtId, int team1Score, int team2Score) async {
    final match = state.activeMatches[courtId];
    if (match == null) return;
    
    final storage = ref.read(storageServiceProvider);
    final updatedMatch = match.copyWith(
      team1Score: team1Score,
      team2Score: team2Score,
    );
    
    await storage.updateMatch(updatedMatch);
    
    final newActiveMatches = {...state.activeMatches, courtId: updatedMatch};
    state = state.copyWith(activeMatches: newActiveMatches);
  }

  Future<void> endMatch(String courtId) async {
    final match = state.activeMatches[courtId];
    if (match == null) return;
    
    final storage = ref.read(storageServiceProvider);
    final courts = ref.read(courtsProvider);
    final court = courts.firstWhere((c) => c.id == courtId);
    final players = ref.read(playersProvider);
    final rotationService = ref.read(rotationServiceProvider);
    
    // Complete the match
    final completedMatch = match.copyWith(
      completed: true,
      endTime: DateTime.now(),
    );
    await storage.updateMatch(completedMatch);
    
    // Get players from match
    final team1Players = match.team1PlayerIds
        .map((id) => players.firstWhere((p) => p.id == id))
        .toList();
    final team2Players = match.team2PlayerIds
        .map((id) => players.firstWhere((p) => p.id == id))
        .toList();
    
    // Determine winners/losers
    final winners = match.team1Score > match.team2Score ? team1Players : team2Players;
    final losers = match.team1Score > match.team2Score ? team2Players : team1Players;
    
    // Update player stats
    for (var winner in winners) {
      final updated = winner.copyWith(
        totalGamesPlayed: winner.totalGamesPlayed + 1,
        totalWins: winner.totalWins + 1,
      );
      await ref.read(playersProvider.notifier).updatePlayer(updated);
    }
    for (var loser in losers) {
      final updated = loser.copyWith(
        totalGamesPlayed: loser.totalGamesPlayed + 1,
      );
      await ref.read(playersProvider.notifier).updatePlayer(updated);
    }
    
    // Perform rotation based on game mode
    final queue = ref.read(queueProvider);
    
    if (court.gameMode == GameMode.kingOfHill) {
      final rotation = rotationService.rotateKingOfHill(
        winners: winners,
        losers: losers,
        queue: queue,
        teamSize: court.teamSize,
      );
      
      // Update queue
      ref.read(queueProvider.notifier).state = rotation.updatedQueue;
      
      // If we have enough players for next match, start it automatically
      if (rotation.isValid) {
        await _startNextMatch(court, rotation.team1, rotation.team2);
      } else {
        // Not enough players, clear court
        await _clearCourt(court);
      }
    } else {
      // Round Robin
      final rotation = rotationService.rotateRoundRobin(
        currentPlayers: [...team1Players, ...team2Players],
        queue: queue,
        teamSize: court.teamSize,
      );
      
      // Update queue
      ref.read(queueProvider.notifier).state = rotation.updatedQueue;
      
      // If we have enough players for next match, start it automatically
      if (rotation.isValid) {
        await _startNextMatch(court, rotation.team1, rotation.team2);
      } else {
        // Not enough players, clear court
        await _clearCourt(court);
      }
    }
    
    // Remove from active matches
    final newActiveMatches = {...state.activeMatches};
    newActiveMatches.remove(courtId);
    
    state = state.copyWith(activeMatches: newActiveMatches);
  }

  Future<void> _startNextMatch(Court court, List<Player> team1, List<Player> team2) async {
    final storage = ref.read(storageServiceProvider);
    
    // Create new match with rotated players
    final match = Match(
      sessionId: 'temp-session-id', // TODO: Get from current session
      courtId: court.id,
      team1PlayerIds: team1.map((p) => p.id).toList(),
      team2PlayerIds: team2.map((p) => p.id).toList(),
    );
    
    await storage.saveMatch(match);
    
    // Update court
    final updatedCourt = court.copyWith(
      currentPlayerIds: [...team1, ...team2].map((p) => p.id).toList(),
      matchInProgress: true,
      matchStartTime: match.startTime,
    );
    await ref.read(courtsProvider.notifier).updateCourt(updatedCourt);
    
    // Update state
    final newActiveMatches = {...state.activeMatches, court.id: match};
    final newTodaysMatches = [...state.todaysMatches, match];
    
    state = state.copyWith(
      activeMatches: newActiveMatches,
      todaysMatches: newTodaysMatches,
    );
  }

  Future<void> _clearCourt(Court court) async {
    final updatedCourt = court.copyWith(
      matchInProgress: false,
      currentPlayerIds: [],
      matchStartTime: null,
    );
    await ref.read(courtsProvider.notifier).updateCourt(updatedCourt);
  }
}

// Locale Notifier
class LocaleNotifier extends StateNotifier<Locale?> {
  final Ref ref;
  
  LocaleNotifier(this.ref) : super(null) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString('language_code', locale.languageCode);
    state = locale;
  }
}

// Daily reset check
final dailyResetProvider = FutureProvider<void>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final storage = ref.read(storageServiceProvider);
  
  final lastSessionDate = prefs.getString('last_session_date');
  final today = DateTime.now().toIso8601String().split('T')[0];
  
  if (lastSessionDate != today) {
    await storage.resetDailyStats();
    await prefs.setString('last_session_date', today);
    
    // Reload all data
    ref.invalidate(playersProvider);
    ref.invalidate(matchesProvider);
  }
});