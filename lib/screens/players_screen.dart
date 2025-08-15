import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';
import '../models/player.dart';
import 'player_setup_screen.dart';

class PlayersScreen extends ConsumerWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(enhancedPlayersProvider);
    final currentSession = ref.watch(currentSessionProvider);
    final checkIns = ref.watch(sessionCheckInsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Players'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _navigateToAddPlayer(context),
            tooltip: 'Add Player',
          ),
        ],
      ),
      body: players.isEmpty
          ? _buildEmptyState(context)
          : _buildPlayersList(context, ref, players, currentSession, checkIns),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddPlayer(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Player'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No Players Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add players to your database',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddPlayer(context),
            icon: const Icon(Icons.person_add),
            label: const Text('Add Player'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersList(BuildContext context, WidgetRef ref, List<Player> players, 
                          dynamic currentSession, List<dynamic> checkIns) {
    return Column(
      children: [
        if (currentSession != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Session',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${checkIns.length} players checked in',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              final isCheckedIn = checkIns.any((c) => c.playerId == player.id && c.isCheckedIn);
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isCheckedIn 
                        ? Colors.green 
                        : Theme.of(context).colorScheme.primary,
                    child: Icon(
                      isCheckedIn ? Icons.check : Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    player.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Games: ${player.totalGamesPlayed}'),
                      Text('Total Wins: ${player.totalWins}'),
                      if (isCheckedIn)
                        Text(
                          'Checked In',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (currentSession != null && !isCheckedIn)
                        IconButton(
                          icon: const Icon(Icons.login),
                          onPressed: () => _checkInPlayer(ref, player.id),
                          tooltip: 'Check In',
                        ),
                      if (currentSession != null && isCheckedIn)
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () => _checkOutPlayer(ref, player.id),
                          tooltip: 'Check Out',
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editPlayer(context, player),
                        tooltip: 'Edit Player',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePlayer(context, ref, player),
                        tooltip: 'Delete Player',
                      ),
                    ],
                  ),
                  onTap: () => _viewPlayerDetails(context, player),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToAddPlayer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PlayerSetupScreen(),
      ),
    );
  }

  void _editPlayer(BuildContext context, Player player) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerSetupScreen(player: player),
      ),
    );
  }

  void _viewPlayerDetails(BuildContext context, Player player) {
    // TODO: Navigate to player detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Player details for ${player.name} - Coming soon')),
    );
  }

  void _checkInPlayer(WidgetRef ref, String playerId) {
    ref.read(sessionCheckInsProvider.notifier).checkInPlayer(playerId: playerId);
  }

  void _checkOutPlayer(WidgetRef ref, String playerId) {
    ref.read(sessionCheckInsProvider.notifier).checkOutPlayer(playerId);
  }

  void _deletePlayer(BuildContext context, WidgetRef ref, Player player) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Player'),
        content: Text('Are you sure you want to delete "${player.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(enhancedPlayersProvider.notifier).removePlayer(player.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${player.name} deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}