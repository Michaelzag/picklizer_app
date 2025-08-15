import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';
import '../providers/message_provider.dart';
import '../models/player.dart';
import 'player_setup_screen.dart';

class PlayersManagementScreen extends ConsumerWidget {
  final bool isWalkthrough;

  const PlayersManagementScreen({
    super.key,
    this.isWalkthrough = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(enhancedPlayersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isWalkthrough ? 'Setup Players' : 'Manage Players'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header section
          _buildHeader(context, players.length),
          
          // Players list or empty state
          Expanded(
            child: players.isEmpty 
                ? _buildEmptyState(context)
                : _buildPlayersList(context, ref, players),
          ),
          
          // Bottom action buttons
          _buildBottomActions(context, ref, players),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int playerCount) {
    final bool hasEnoughPlayers = playerCount >= 2;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.people,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                isWalkthrough ? 'Setup Your Players' : 'Manage Players',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                playerCount == 0
                    ? 'Add at least 2 players to continue'
                    : playerCount == 1
                        ? '1 player added - need at least 1 more'
                        : '$playerCount players configured',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (hasEnoughPlayers) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Ready to continue',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (playerCount > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Need ${2 - playerCount} more player${2 - playerCount != 1 ? 's' : ''}',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 24),
          Text(
            'No Players Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add at least 2 players to start playing.\nYou can add more players anytime.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddPlayer(context),
            icon: const Icon(Icons.person_add),
            label: const Text('Add First Player'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersList(BuildContext context, WidgetRef ref, List<Player> players) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                player.name[0].toUpperCase(),
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
                Text(
                  'Modes: ${player.gameModesDisplay}',
                  style: const TextStyle(fontSize: 12),
                ),
                if (player.totalGamesPlayed > 0)
                  Text(
                    'Games: ${player.totalGamesPlayed} • Wins: ${player.totalWins}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditPlayerDialog(context, ref, player);
                    break;
                  case 'delete':
                    _confirmDeletePlayer(context, ref, player);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(BuildContext context, WidgetRef ref, List<Player> players) {
    final bool hasEnoughPlayers = players.length >= 2;
    
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add Player button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _navigateToAddPlayer(context),
                icon: const Icon(Icons.person_add),
                label: Text(players.isEmpty ? 'Add First Player' : 'Add Another Player'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            
            // Continue button (only show if we have enough players and this is walkthrough)
            if (hasEnoughPlayers && isWalkthrough) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Continue with ${players.length} Player${players.length != 1 ? 's' : ''}'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToAddPlayer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlayerSetupScreen(),
      ),
    );
  }

  void _showEditPlayerDialog(BuildContext context, WidgetRef ref, Player player) {
    final nameController = TextEditingController(text: player.name);
    bool playsSingles = player.playsSingles;
    bool playsDoubles = player.playsDoubles;
    bool playsKingOfHill = player.playsKingOfHill;
    bool playsRoundRobin = player.playsRoundRobin;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Player'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Player Name',
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                
                // Game mode preferences
                const Text(
                  'Game Mode Preferences:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                
                CheckboxListTile(
                  title: const Text('Singles'),
                  value: playsSingles,
                  onChanged: (value) {
                    setState(() {
                      playsSingles = value ?? true;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  title: const Text('Doubles'),
                  value: playsDoubles,
                  onChanged: (value) {
                    setState(() {
                      playsDoubles = value ?? true;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  title: const Text('King of Hill'),
                  value: playsKingOfHill,
                  onChanged: (value) {
                    setState(() {
                      playsKingOfHill = value ?? true;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  title: const Text('Round Robin'),
                  value: playsRoundRobin,
                  onChanged: (value) {
                    setState(() {
                      playsRoundRobin = value ?? true;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                
                // Warning if no preferences selected
                if (!playsSingles && !playsDoubles && !playsKingOfHill && !playsRoundRobin) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Player must be available for at least one game mode',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  // Validate that at least one game mode is selected
                  if (!playsSingles && !playsDoubles && !playsKingOfHill && !playsRoundRobin) {
                    ref.read(messageProvider.notifier).showError('Player must be available for at least one game mode');
                    return;
                  }
                  
                  try {
                    final storage = ref.read(enhancedStorageServiceProvider);
                    final updatedPlayer = player.copyWith(
                      name: name,
                      playsSingles: playsSingles,
                      playsDoubles: playsDoubles,
                      playsKingOfHill: playsKingOfHill,
                      playsRoundRobin: playsRoundRobin,
                    );
                    await storage.updatePlayer(updatedPlayer);
                    
                    if (context.mounted) {
                      Navigator.pop(context);
                      ref.read(messageProvider.notifier).showSuccess('Player "$name" updated');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      ref.read(messageProvider.notifier).showError('Error updating player: $e');
                    }
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeletePlayer(BuildContext context, WidgetRef ref, Player player) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Player'),
        content: Text('Are you sure you want to delete "${player.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final storage = ref.read(enhancedStorageServiceProvider);
                await storage.deletePlayer(player.id);
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ref.read(messageProvider.notifier).showSuccess('Player "${player.name}" deleted');
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ref.read(messageProvider.notifier).showError('Error deleting player: $e');
                }
              }
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