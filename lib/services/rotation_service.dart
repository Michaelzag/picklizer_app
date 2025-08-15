import 'dart:math';
import '../models/player.dart';
import '../models/court.dart';
import '../models/rotation_result.dart';

class RotationService {
  // King of the Hill - Winners stay, losers rotate
  RotationResult rotateKingOfHill({
    required List<Player> winners,
    required List<Player> losers,
    required List<Player> queue,
    required TeamSize teamSize,
  }) {
    // Create a mutable copy of the queue
    final updatedQueue = List<Player>.from(queue);
    
    // 1. Losers go to back of queue
    updatedQueue.addAll(losers);
    
    // 2. Calculate how many new players we need
    final playersNeeded = teamSize == TeamSize.singles ? 1 : 2;
    
    // 3. Take next players from queue
    final nextPlayers = <Player>[];
    for (int i = 0; i < playersNeeded && updatedQueue.isNotEmpty; i++) {
      nextPlayers.add(updatedQueue.removeAt(0));
    }
    
    // 4. Form new teams
    final team1 = <Player>[];
    final team2 = <Player>[];
    
    if (teamSize == TeamSize.singles) {
      // Singles: winner vs new player
      if (winners.isNotEmpty) team1.add(winners[0]);
      if (nextPlayers.isNotEmpty) team2.add(nextPlayers[0]);
    } else {
      // Doubles: split winners and pair with new players
      if (winners.isNotEmpty) {
        // Split winners across teams for variety
        team1.add(winners[0]);
        if (winners.length > 1) {
          team2.add(winners[1]);
        }
      }
      
      // Add new players
      if (nextPlayers.isNotEmpty) {
        if (team2.isEmpty && nextPlayers.isNotEmpty) {
          team2.add(nextPlayers[0]);
          if (nextPlayers.length > 1) {
            team1.add(nextPlayers[1]);
          }
        } else {
          if (nextPlayers.isNotEmpty) team1.add(nextPlayers[0]);
          if (nextPlayers.length > 1) team2.add(nextPlayers[1]);
        }
      }
    }
    
    return RotationResult(
      team1: team1,
      team2: team2,
      updatedQueue: updatedQueue,
    );
  }
  
  // Round Robin - Everyone rotates
  RotationResult rotateRoundRobin({
    required List<Player> currentPlayers,
    required List<Player> queue,
    required TeamSize teamSize,
  }) {
    // Create a mutable copy of the queue
    final updatedQueue = List<Player>.from(queue);
    
    // 1. All current players go to back of queue
    updatedQueue.addAll(currentPlayers);
    
    // 2. Calculate how many players we need for the next match
    final playersNeeded = teamSize == TeamSize.singles ? 2 : 4;
    
    // 3. Take next group from queue
    final nextPlayers = <Player>[];
    for (int i = 0; i < playersNeeded && updatedQueue.isNotEmpty; i++) {
      nextPlayers.add(updatedQueue.removeAt(0));
    }
    
    // 4. Form new teams
    final team1 = <Player>[];
    final team2 = <Player>[];
    
    if (teamSize == TeamSize.singles) {
      // Singles: first vs second from queue
      if (nextPlayers.isNotEmpty) team1.add(nextPlayers[0]);
      if (nextPlayers.length > 1) team2.add(nextPlayers[1]);
    } else {
      // Doubles: distribute players evenly
      for (int i = 0; i < nextPlayers.length; i++) {
        if (i < 2) {
          team1.add(nextPlayers[i]);
        } else {
          team2.add(nextPlayers[i]);
        }
      }
    }
    
    return RotationResult(
      team1: team1,
      team2: team2,
      updatedQueue: updatedQueue,
    );
  }
  
  // Helper method to check if we have enough players for a match
  bool canStartMatch({
    required List<Player> queue,
    required TeamSize teamSize,
  }) {
    final requiredPlayers = teamSize == TeamSize.singles ? 2 : 4;
    return queue.length >= requiredPlayers;
  }
  
  // Helper method to get next up players
  List<Player> getNextUpPlayers({
    required List<Player> queue,
    required TeamSize teamSize,
  }) {
    final requiredPlayers = teamSize == TeamSize.singles ? 2 : 4;
    return queue.take(requiredPlayers).toList();
  }
  
  // Shuffle teams for variety (optional enhancement)
  RotationResult shuffleTeams({
    required List<Player> players,
    required TeamSize teamSize,
  }) {
    final shuffled = List<Player>.from(players)..shuffle(Random());
    
    final team1 = <Player>[];
    final team2 = <Player>[];
    
    if (teamSize == TeamSize.singles) {
      if (shuffled.isNotEmpty) team1.add(shuffled[0]);
      if (shuffled.length > 1) team2.add(shuffled[1]);
    } else {
      // Doubles: distribute evenly
      for (int i = 0; i < shuffled.length; i++) {
        if (i < 2) {
          team1.add(shuffled[i]);
        } else {
          team2.add(shuffled[i]);
        }
      }
    }
    
    return RotationResult(
      team1: team1,
      team2: team2,
      updatedQueue: [],
    );
  }
}