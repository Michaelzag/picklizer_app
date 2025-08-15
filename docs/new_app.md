# Pickleizer Offline - Complete New App Specification

**Date**: August 15, 2025  
**Decision**: Build a completely new Flutter app for offline-first court management  
**Author Context**: Michael's complete requirements and our discussion history

## 🎯 Critical Context from Michael

### The Problem That Started Everything

Michael read an article about an app that was **rejected from the App Store** because it locked all functionality behind a login screen. This triggered a major realization:

> "we made some decisions early on to just use the fastapi for everything, and for the app to not actually do much except be a fancy UI. This might not be appropriate though, maybe we need to write some functionality into the app and then have the database stuff behind a login. so the app should work in host mode without any login, and we shouldnt gate the app access behind a login."

### Michael's Core Requirements

1. **App Store Compliance**: No login wall, substantial functionality without account
2. **Simple Host Mode**: One facility, add courts, manage players locally
3. **Basic Features**: 
   - Singles vs doubles configuration per court
   - Two game modes: King of the Hill and Round Robin
   - Simple rotation algorithm (nothing fancy)
   - Player skip button
   - Score recording for history
   - Simple history screen
4. **Offline First**: "This app is offline first, almost entirely right now"

### The Decision to Start Fresh

After analyzing the refactor complexity, Michael asked:
> "Should we just write a new app then? and leave this one untouched for reference later?"

**Answer: YES!** Building fresh is cleaner, faster, and risk-free.

## 📁 New Project Structure

When you reorganize, the structure will be:
```
pickleizer-offline/           # New clean Flutter project (main)
├── lib/                      # New offline app code
├── test/                     # New app tests
├── docs/                     # Documentation (this file will be here)
└── reference_app/            # Current app for reference (read-only)
    └── [entire current app]
```

## 🏗️ Complete Implementation Specification

### Core Data Models (Local Only)

```dart
// models/court.dart
class Court {
  final String id;          // UUID
  final String name;        // "Court 1", "Court 2"
  final TeamSize teamSize;  // singles or doubles
  final GameMode gameMode;  // kingOfHill or roundRobin
  List<String> currentPlayerIds;
  bool matchInProgress;
  DateTime? matchStartTime;
}

enum TeamSize { 
  singles,  // 1v1 (2 players)
  doubles   // 2v2 (4 players)
}

enum GameMode {
  kingOfHill,  // Winners stay, losers out
  roundRobin   // Everyone rotates
}

// models/player.dart
class Player {
  final String id;        // UUID
  final String name;      // Just a name, NO PHONE!
  final DateTime addedAt;
  int gamesPlayed;        // Today only
  int wins;               // Today only
  bool isSkipping;        // Currently skipping
}

// models/match.dart
class Match {
  final String id;
  final String courtId;
  final List<String> team1PlayerIds;
  final List<String> team2PlayerIds;
  int team1Score;
  int team2Score;
  final DateTime startTime;
  DateTime? endTime;
  bool completed;
}
```

### Rotation Algorithms (Simple Implementation)

```dart
// services/rotation_service.dart

class RotationService {
  
  // King of the Hill - Winners stay, losers rotate
  RotationResult rotateKingOfHill({
    required List<Player> winners,
    required List<Player> losers,
    required List<Player> queue,
    required TeamSize teamSize,
  }) {
    // 1. Losers go to back of queue
    queue.addAll(losers);
    
    // 2. Take next players from queue
    int playersNeeded = teamSize == TeamSize.singles ? 1 : 2;
    var nextPlayers = queue.take(playersNeeded).toList();
    queue.removeRange(0, min(playersNeeded, queue.length));
    
    // 3. Mix winners with new players (split teams)
    var team1 = <Player>[];
    var team2 = <Player>[];
    
    if (teamSize == TeamSize.singles) {
      team1.add(winners[0]);
      team2.add(nextPlayers[0]);
    } else {
      // Doubles: split winners
      team1.add(winners[0]);
      team1.add(nextPlayers[0]);
      team2.add(winners[1]);
      team2.add(nextPlayers.length > 1 ? nextPlayers[1] : null);
    }
    
    return RotationResult(
      team1: team1,
      team2: team2,
      updatedQueue: queue,
    );
  }
  
  // Round Robin - Everyone rotates
  RotationResult rotateRoundRobin({
    required List<Player> currentPlayers,
    required List<Player> queue,
    required TeamSize teamSize,
  }) {
    // 1. All current players to back of queue
    queue.addAll(currentPlayers);
    
    // 2. Take next group from queue
    int playersNeeded = teamSize == TeamSize.singles ? 2 : 4;
    var nextPlayers = queue.take(playersNeeded).toList();
    queue.removeRange(0, min(playersNeeded, queue.length));
    
    // 3. Form new teams
    var team1 = <Player>[];
    var team2 = <Player>[];
    
    if (teamSize == TeamSize.singles) {
      if (nextPlayers.length >= 2) {
        team1.add(nextPlayers[0]);
        team2.add(nextPlayers[1]);
      }
    } else {
      // Doubles
      if (nextPlayers.length >= 4) {
        team1.add(nextPlayers[0]);
        team1.add(nextPlayers[1]);
        team2.add(nextPlayers[2]);
        team2.add(nextPlayers[3]);
      }
    }
    
    return RotationResult(
      team1: team1,
      team2: team2,
      updatedQueue: queue,
    );
  }
}
```

### Local Storage (SQLite)

```dart
// services/storage_service.dart

class StorageService {
  late Database _database;
  
  Future<void> init() async {
    _database = await openDatabase(
      'pickleizer.db',
      version: 1,
      onCreate: (db, version) {
        // Players table
        db.execute('''
          CREATE TABLE players(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            added_at INTEGER NOT NULL,
            games_played INTEGER DEFAULT 0,
            wins INTEGER DEFAULT 0
          )
        ''');
        
        // Courts table
        db.execute('''
          CREATE TABLE courts(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            team_size INTEGER NOT NULL,
            game_mode TEXT NOT NULL,
            position INTEGER NOT NULL
          )
        ''');
        
        // Matches table
        db.execute('''
          CREATE TABLE matches(
            id TEXT PRIMARY KEY,
            court_id TEXT NOT NULL,
            team1_players TEXT NOT NULL,
            team2_players TEXT NOT NULL,
            team1_score INTEGER NOT NULL,
            team2_score INTEGER NOT NULL,
            start_time INTEGER NOT NULL,
            end_time INTEGER,
            completed INTEGER DEFAULT 0
          )
        ''');
        
        // Queue table
        db.execute('''
          CREATE TABLE queue(
            player_id TEXT PRIMARY KEY,
            position INTEGER NOT NULL,
            is_skipping INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }
  
  // Player CRUD
  Future<void> savePlayer(Player player) async { }
  Future<Player?> getPlayer(String id) async { }
  Future<List<Player>> getAllPlayers() async { }
  Future<void> deletePlayer(String id) async { }
  
  // Court CRUD
  Future<void> saveCourt(Court court) async { }
  Future<List<Court>> getAllCourts() async { }
  
  // Match CRUD
  Future<void> saveMatch(Match match) async { }
  Future<List<Match>> getTodaysMatches() async { }
  Future<List<Match>> getMatchHistory(int limit) async { }
  
  // Queue management
  Future<void> saveQueue(List<Player> queue) async { }
  Future<List<Player>> loadQueue() async { }
}
```

### State Management (Provider)

```dart
// providers/session_provider.dart

class SessionProvider extends ChangeNotifier {
  final StorageService _storage;
  
  // State
  List<Court> courts = [];
  List<Player> queue = [];
  List<Player> allPlayers = [];
  List<Match> todaysMatches = [];
  Map<String, Match> activeMatches = {};
  
  // Add a player (name only!)
  Future<void> addPlayer(String name) async {
    final player = Player(
      id: Uuid().v4(),
      name: name,
      addedAt: DateTime.now(),
    );
    
    await _storage.savePlayer(player);
    allPlayers.add(player);
    queue.add(player);
    notifyListeners();
  }
  
  // Skip player's turn
  void skipPlayer(String playerId) {
    final index = queue.indexWhere((p) => p.id == playerId);
    if (index != -1) {
      final player = queue.removeAt(index);
      queue.add(player); // Move to back
      notifyListeners();
    }
  }
  
  // Start match on court
  Future<void> startMatch(String courtId) async {
    final court = courts.firstWhere((c) => c.id == courtId);
    final playersNeeded = court.teamSize == TeamSize.singles ? 2 : 4;
    
    if (queue.length < playersNeeded) {
      throw Exception('Not enough players in queue');
    }
    
    // Take players from queue
    final matchPlayers = queue.take(playersNeeded).toList();
    queue.removeRange(0, playersNeeded);
    
    // Create match
    final match = Match(
      id: Uuid().v4(),
      courtId: courtId,
      team1PlayerIds: matchPlayers
          .take(playersNeeded ~/ 2)
          .map((p) => p.id)
          .toList(),
      team2PlayerIds: matchPlayers
          .skip(playersNeeded ~/ 2)
          .map((p) => p.id)
          .toList(),
      team1Score: 0,
      team2Score: 0,
      startTime: DateTime.now(),
      completed: false,
    );
    
    await _storage.saveMatch(match);
    activeMatches[courtId] = match;
    court.currentPlayerIds = matchPlayers.map((p) => p.id).toList();
    court.matchInProgress = true;
    
    notifyListeners();
  }
  
  // End match and rotate
  Future<void> endMatch(String courtId, int team1Score, int team2Score) async {
    final court = courts.firstWhere((c) => c.id == courtId);
    final match = activeMatches[courtId]!;
    
    // Update match
    match.team1Score = team1Score;
    match.team2Score = team2Score;
    match.completed = true;
    match.endTime = DateTime.now();
    
    await _storage.saveMatch(match);
    
    // Get players from match
    final team1Players = match.team1PlayerIds
        .map((id) => allPlayers.firstWhere((p) => p.id == id))
        .toList();
    final team2Players = match.team2PlayerIds
        .map((id) => allPlayers.firstWhere((p) => p.id == id))
        .toList();
    
    // Determine winners/losers
    final winners = team1Score > team2Score ? team1Players : team2Players;
    final losers = team1Score > team2Score ? team2Players : team1Players;
    
    // Update stats
    for (var winner in winners) {
      winner.gamesPlayed++;
      winner.wins++;
    }
    for (var loser in losers) {
      loser.gamesPlayed++;
    }
    
    // Perform rotation
    final rotationService = RotationService();
    RotationResult rotation;
    
    if (court.gameMode == GameMode.kingOfHill) {
      rotation = rotationService.rotateKingOfHill(
        winners: winners,
        losers: losers,
        queue: queue,
        teamSize: court.teamSize,
      );
    } else {
      rotation = rotationService.rotateRoundRobin(
        currentPlayers: [...team1Players, ...team2Players],
        queue: queue,
        teamSize: court.teamSize,
      );
    }
    
    // Update queue
    queue = rotation.updatedQueue;
    
    // Clear court
    activeMatches.remove(courtId);
    court.matchInProgress = false;
    court.currentPlayerIds = [];
    
    // Add to history
    todaysMatches.add(match);
    
    await _storage.saveQueue(queue);
    notifyListeners();
  }
}
```

### UI Screens

```dart
// screens/dashboard_screen.dart
// MAIN SCREEN - NO LOGIN REQUIRED!

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pickleizer Court Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.push(context, 
              MaterialPageRoute(builder: (_) => HistoryScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          // Courts Section
          CourtsSection(),
          
          // Queue Section
          Expanded(child: QueueSection()),
          
          // Add Player Button
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => _showAddPlayerDialog(context),
              child: Text('Add Player'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => CourtSetupScreen())),
        child: Icon(Icons.add),
        tooltip: 'Add Court',
      ),
    );
  }
  
  void _showAddPlayerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddPlayerDialog(),
    );
  }
}

// screens/court_setup_screen.dart
class CourtSetupScreen extends StatefulWidget {
  // Configure:
  // - Court name
  // - Team size (singles/doubles)
  // - Game mode (KOTH/RR)
}

// screens/match_screen.dart
class MatchScreen extends StatefulWidget {
  final String courtId;
  
  // Shows:
  // - Current players
  // - Score tracking (+/- buttons)
  // - End match button
}

// screens/queue_screen.dart
class QueueScreen extends StatelessWidget {
  // Shows:
  // - Queue order
  // - Drag to reorder
  // - Skip button per player
  // - Clear indication of who's up next
}

// screens/history_screen.dart
class HistoryScreen extends StatelessWidget {
  // Shows:
  // - Today's matches
  // - Scores
  // - Player stats for today
  // - Clear all option
}
```

## 🚀 Implementation Plan

### Day 1: Project Setup & Foundation
```bash
# Create new project
flutter create pickleizer_offline
cd pickleizer_offline

# Add dependencies
flutter pub add sqflite
flutter pub add shared_preferences
flutter pub add provider
flutter pub add uuid
flutter pub add collection

# Create folder structure
mkdir lib/models
mkdir lib/services
mkdir lib/providers
mkdir lib/screens
mkdir lib/widgets
```

Create:
- All model classes
- Storage service
- Basic provider setup

### Day 2: Core Logic
- Implement rotation algorithms
- Complete SessionProvider
- Write algorithm tests

### Day 3: Main UI
- Dashboard screen (no login!)
- Court setup screen
- Queue display

### Day 4: Match Management
- Match screen with scoring
- End match flow
- Rotation execution

### Day 5: Polish & History
- History screen
- Player stats
- UI improvements

### Day 6: Testing
- Complete test coverage
- Edge cases
- Performance testing

### Day 7: Release Prep
- App Store screenshots
- Final testing
- Documentation

## 🎨 UI/UX Principles

### Key Screens Flow
```
App Launch
    ↓ (NO LOGIN!)
Dashboard
    ├── Configure Courts → Court Setup
    ├── Add Players → Simple Name Dialog
    ├── Start Match → Match Screen
    ├── View Queue → Queue Management
    └── History → Today's Matches
```

### Design Principles
1. **Large Touch Targets** - Court-side usability
2. **Clear Visual States** - Who's playing, who's waiting
3. **Minimal Input** - Just names, no forms
4. **Quick Actions** - One tap for common operations
5. **No Account Required** - Works immediately

## 📱 App Store Compliance

### What Makes This Compliant
1. ✅ **No Login Wall** - Dashboard appears immediately
2. ✅ **Substantial Functionality** - Full court management offline
3. ✅ **No Personal Data Required** - Just player names
4. ✅ **Works Offline** - No network dependency
5. ✅ **Clear Value** - Digital court list replacement

### What to Avoid
1. ❌ Asking for phone numbers
2. ❌ Requiring email addresses
3. ❌ Forcing account creation
4. ❌ Blocking features behind login
5. ❌ Collecting unnecessary data

## 🔄 Migration from Reference App

### What to Copy (Selectively)
```dart
// From reference_app/lib/widgets/
- Color schemes
- Button styles
- Card designs
- Icons used

// From reference_app/lib/config/
- Theme configuration
- Color constants
```

### What NOT to Copy
- API client
- WebSocket service
- Authentication logic
- Backend models
- Network error handling

### How to Reference
```dart
// When building new screens, look at reference for:
// 1. Widget composition patterns
// 2. State management approaches
// 3. Navigation patterns
// 4. BUT simplify everything for offline
```

## 💾 Data Persistence Strategy

### Daily Reset
- Games played resets each day
- Win counts reset each day
- Match history kept for 30 days
- Players persist indefinitely

### Settings Storage
```dart
// SharedPreferences keys
'default_team_size'     // singles or doubles
'default_game_mode'     // kingOfHill or roundRobin
'last_session_date'     // For daily reset
'sound_enabled'         // UI feedback sounds
```

## 🧪 Testing Strategy

### Critical Test Coverage
```dart
// test/services/rotation_service_test.dart
- Test King of the Hill with singles
- Test King of the Hill with doubles
- Test Round Robin with singles
- Test Round Robin with doubles
- Test with insufficient players
- Test skip functionality

// test/services/storage_service_test.dart
- Test player CRUD
- Test court CRUD
- Test match persistence
- Test queue save/load
- Test daily reset

// test/providers/session_provider_test.dart
- Test add player
- Test start match
- Test end match
- Test rotation execution
- Test stats update
```

## 🚨 Edge Cases to Handle

1. **Not enough players for match**
   - Show clear message
   - Disable start match button
   
2. **Player leaves mid-session**
   - Remove from queue
   - If in active match, handle gracefully
   
3. **App crash/restart**
   - Restore queue from storage
   - Restore court configuration
   - Active matches marked as incomplete

4. **Tie scores**
   - Force a winner selection
   - Or treat first team as winner

## 📋 Final Checklist

### Before Starting Development
- [ ] Create new Flutter project
- [ ] Copy this file to new docs/
- [ ] Set up git repository
- [ ] Create folder structure

### Core Features (Must Have)
- [ ] Add/remove courts
- [ ] Configure singles/doubles per court
- [ ] Configure KOTH/RR per court
- [ ] Add players by name only
- [ ] Queue management with drag to reorder
- [ ] Skip player functionality
- [ ] Start match from queue
- [ ] Score tracking
- [ ] End match with rotation
- [ ] Today's history
- [ ] Daily stats reset

### Nice to Have (If Time)
- [ ] Export today's matches
- [ ] Undo last action
- [ ] Court timer
- [ ] Break timer
- [ ] Sound effects

## 🎯 Success Criteria

1. **App Store Approval** - No login required
2. **Immediate Value** - Works within 10 seconds
3. **Simple** - Anyone can use without training
4. **Reliable** - No crashes, no data loss
5. **Fast** - All operations under 100ms

## 💭 Final Context from Michael

Remember:
- This is a complete rewrite, not a refactor
- The existing app becomes reference_app/
- Build offline-first from the ground up
- No backend, no API, no authentication
- Simple rotation algorithms
- Focus on court management utility
- App Store compliance is critical

The sophisticated backend with Memgraph and 38 endpoints still exists and works, but it's for future online features. This offline app proves the concept and provides immediate value without any infrastructure.

## 🚀 You're Ready!

This document contains everything you need to build Pickleizer Offline from scratch. When you come back to this project after reorganization, this file will restore your complete context. The app should be simple, functional, and guarantee App Store approval.

Build it clean. Build it simple. Build it offline-first.

Good luck!