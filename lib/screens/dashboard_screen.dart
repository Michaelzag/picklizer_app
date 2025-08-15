import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/court/court_card.dart';
import '../widgets/common/player_card.dart';
import '../models/court.dart';
import 'history_screen.dart';
import 'match_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickleizer Court Manager'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
            tooltip: 'Match History',
          ),
        ],
      ),
      body: ref.watch(isLoadingProvider)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Courts Section
                _buildCourtsSection(context, ref),
                
                const Divider(),
                
                // Queue Section
                Expanded(
                  child: _buildQueueSection(context, ref),
                ),
                
                // Add Player Section
                _buildAddPlayerSection(context, ref),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: This screen needs facility context - should be accessed through facility detail screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please use the Facilities tab to manage courts'),
            ),
          );
        },
        tooltip: 'Add Court',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCourtsSection(BuildContext context, WidgetRef ref) {
    final courts = ref.watch(courtsProvider);
    final matchState = ref.watch(matchesProvider);
    final queue = ref.watch(queueProvider);
    
    if (courts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.sports_tennis,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No courts configured',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Tap the + button to add your first court'),
          ],
        ),
      );
    }

    return Container(
      height: 280,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: courts.length,
        itemBuilder: (context, index) {
          final court = courts[index];
          final activeMatch = matchState.activeMatches[court.id];
          final canStartMatch = queue.length >= court.requiredPlayers;

          return SizedBox(
            width: 300,
            child: CourtCard(
              court: court,
              activeMatch: activeMatch,
              canStartMatch: canStartMatch,
              onTap: court.matchInProgress
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MatchScreen(
                            courtId: court.id,
                            courtName: court.name,
                          ),
                        ),
                      );
                    }
                  : null,
              onStartMatch: canStartMatch && !court.matchInProgress
                  ? () => ref.read(matchesProvider.notifier).startMatch(court.id)
                  : null,
              onEndMatch: court.matchInProgress
                  ? () => _showEndMatchDialog(context, ref, court)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildQueueSection(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(queueProvider);
    
    if (queue.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No players in queue',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Add players to get started'),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Queue (${queue.length} players)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (queue.isNotEmpty)
                TextButton(
                  onPressed: () => _showClearQueueDialog(context, ref),
                  child: const Text('Clear All'),
                ),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: queue.length,
            onReorder: (oldIndex, newIndex) {
              ref.read(queueProvider.notifier).reorderQueue(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final player = queue[index];
              return PlayerCard(
                key: ValueKey(player.id),
                player: player,
                isInQueue: true,
                queuePosition: index + 1,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () => ref.read(queueProvider.notifier).skipPlayer(player.id),
                      tooltip: 'Skip turn',
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _confirmRemovePlayer(context, ref, player.id),
                      color: Colors.red,
                      tooltip: 'Remove from queue',
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddPlayerSection(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showAddPlayerDialog(context, ref),
                icon: const Icon(Icons.person_add),
                label: const Text('Add Player'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPlayerDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Player'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Player Name',
            hintText: 'Enter player name',
          ),
          textCapitalization: TextCapitalization.words,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              ref.read(playersProvider.notifier).addPlayer(value.trim());
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                ref.read(playersProvider.notifier).addPlayer(name);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEndMatchDialog(BuildContext context, WidgetRef ref, Court court) {
    final matchState = ref.read(matchesProvider);
    final match = matchState.activeMatches[court.id];
    if (match == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Match'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Score: ${match.scoreDisplay}'),
            const SizedBox(height: 16),
            const Text('Are you sure you want to end this match?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(matchesProvider.notifier).endMatch(court.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('End Match'),
          ),
        ],
      ),
    );
  }

  void _confirmRemovePlayer(BuildContext context, WidgetRef ref, String playerId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Player'),
        content: const Text('Remove this player from the queue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(playersProvider.notifier).removePlayer(playerId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showClearQueueDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Queue'),
        content: const Text('Remove all players from the queue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final queue = ref.read(queueProvider);
              for (final player in List.from(queue)) {
                ref.read(playersProvider.notifier).removePlayer(player.id);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}