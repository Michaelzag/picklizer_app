import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';
import '../models/player.dart';
import '../models/queue_entry.dart';

class OnDeckScreen extends ConsumerWidget {
  const OnDeckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSession = ref.watch(currentSessionProvider);
    final queue = ref.watch(sessionQueueProvider);
    final players = ref.watch(enhancedPlayersProvider);
    final undoOperations = ref.watch(undoOperationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Queue'),
        centerTitle: true,
        actions: [
          if (undoOperations.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () => _showUndoDialog(context, ref),
              tooltip: 'Undo last action',
            ),
        ],
      ),
      body: currentSession == null
          ? _buildNoSessionState(context, ref)
          : Column(
              children: [
                // Live matches section
                _buildLiveMatchesSection(context, ref),
                
                const Divider(),
                
                // Queue section
                Expanded(
                  child: _buildQueueSection(context, ref, queue, players),
                ),
              ],
            ),
    );
  }

  Widget _buildNoSessionState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_circle_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No Active Session',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text('Start a session to see the queue'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showStartSessionDialog(context, ref),
            child: const Text('Start Session'),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMatchesSection(BuildContext context, WidgetRef ref) {
    // TODO: Get active matches from current session
    // For now, show placeholder
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Matches',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.sports_tennis,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('No active matches'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueSection(BuildContext context, WidgetRef ref, List<QueueEntry> queue, List<Player> players) {
    if (queue.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.queue,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Queue is empty',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Check in players to add them to the queue'),
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
              Text(
                'Estimated order - may change',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: queue.length,
            onReorder: (oldIndex, newIndex) {
              ref.read(sessionQueueProvider.notifier).reorderQueue(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final entry = queue[index];
              final player = players.firstWhere((p) => p.id == entry.playerId);
              
              return Card(
                key: ValueKey(entry.id),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    player.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Skill Level: ${player.skillLevelDisplay}'),
                      if (entry.skipCount > 0)
                        Text(
                          'Skipped ${entry.skipCount} time${entry.skipCount > 1 ? 's' : ''}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'soft_skip':
                          _softSkipPlayer(ref, entry, player);
                          break;
                        case 'hard_skip':
                          _hardSkipPlayer(ref, entry, player);
                          break;
                        case 'remove':
                          _confirmRemovePlayer(context, ref, entry, player);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'soft_skip',
                        child: ListTile(
                          leading: Icon(Icons.pause),
                          title: Text('Soft Skip'),
                          subtitle: Text('Stay at front'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'hard_skip',
                        child: ListTile(
                          leading: Icon(Icons.skip_next),
                          title: Text('Hard Skip'),
                          subtitle: Text('Go to back'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: ListTile(
                          leading: Icon(Icons.remove_circle, color: Colors.red),
                          title: Text('Remove', style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showStartSessionDialog(BuildContext context, WidgetRef ref) {
    final facilities = ref.read(facilitiesProvider);
    
    if (facilities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a facility first')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start New Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select a facility to start a new session:'),
            const SizedBox(height: 16),
            ...facilities.map((facility) => ListTile(
              title: Text(facility.name),
              subtitle: facility.location != null ? Text(facility.location!) : null,
              onTap: () {
                ref.read(currentSessionProvider.notifier).startNewSession(
                  facilityId: facility.id,
                );
                Navigator.pop(context);
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _softSkipPlayer(WidgetRef ref, QueueEntry entry, Player player) {
    // Soft skip: keep at current position but mark as skipped
    ref.read(sessionQueueProvider.notifier).softSkipPlayer(entry.playerId);
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(content: Text('${player.name} soft skipped (staying at front)')),
    );
  }

  void _hardSkipPlayer(WidgetRef ref, QueueEntry entry, Player player) {
    // Hard skip: move to back of queue
    ref.read(sessionQueueProvider.notifier).hardSkipPlayer(entry.playerId);
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(content: Text('${player.name} moved to back of queue')),
    );
  }

  void _confirmRemovePlayer(BuildContext context, WidgetRef ref, QueueEntry entry, Player player) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Queue'),
        content: Text('Remove ${player.name} from the queue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(sessionQueueProvider.notifier).removePlayerFromQueue(entry.playerId);
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

  void _showUndoDialog(BuildContext context, WidgetRef ref) {
    final operations = ref.read(undoOperationsProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Undo Last Action'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Undo: ${operations.first.description}?'),
            const SizedBox(height: 8),
            Text(
              operations.first.timeDisplay,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await ref.read(undoOperationsProvider.notifier).undoLastOperation();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Action undone' : 'Could not undo action'),
                  ),
                );
              }
            },
            child: const Text('Undo'),
          ),
        ],
      ),
    );
  }
}