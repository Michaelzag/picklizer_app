import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';
import '../providers/message_provider.dart';
import '../models/player.dart';

class PlayerSetupScreen extends ConsumerStatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  ConsumerState<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends ConsumerState<PlayerSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _selectedSkillLevel = 2; // 1=Beginner, 2=Intermediate, 3=Advanced

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(enhancedPlayersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Players'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.people,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add Players',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add at least 2 players to start playing',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Current players count
            if (players.isNotEmpty) ...[
              Card(
                color: players.length >= 2
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        players.length >= 2 ? Icons.check_circle : Icons.info,
                        color: players.length >= 2 ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${players.length} player${players.length != 1 ? 's' : ''} added',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      if (players.length >= 2)
                        const Text('Ready to play!')
                      else
                        Text('Need ${2 - players.length} more'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Add player form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Player',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Player name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Player Name *',
                      hintText: 'Enter player name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a player name';
                      }
                      // Check for duplicate names
                      final existingNames = players.map((p) => p.name.toLowerCase()).toList();
                      if (existingNames.contains(value.trim().toLowerCase())) {
                        return 'A player with this name already exists';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Skill level
                  Text(
                    'Skill Level',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedSkillLevel,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.star),
                    ),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Beginner')),
                      DropdownMenuItem(value: 2, child: Text('Intermediate')),
                      DropdownMenuItem(value: 3, child: Text('Advanced')),
                    ],
                    onChanged: (level) {
                      if (level != null) {
                        setState(() {
                          _selectedSkillLevel = level;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Add player button
                  ElevatedButton(
                    onPressed: _addPlayer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Add Player',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Current players list
            if (players.isNotEmpty) ...[
              Text(
                'Current Players (${players.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            player.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(player.name),
                        subtitle: Text('Skill: ${player.skillLevelDisplay}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDeletePlayer(player),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            // Continue button (if enough players)
            if (players.length >= 2)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Continue with ${players.length} Players',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _addPlayer() async {
    if (_formKey.currentState!.validate()) {
      final storage = ref.read(enhancedStorageServiceProvider);
      
      try {
        final player = Player(
          name: _nameController.text.trim(),
          skillLevel: _selectedSkillLevel,
        );
        
        await storage.savePlayer(player);
        
        // Clear form
        _nameController.clear();
        setState(() {
          _selectedSkillLevel = 2; // Reset to intermediate
        });
        
        if (mounted) {
          ref.read(messageProvider.notifier).showSuccess('${player.name} added successfully!');
        }
      } catch (e) {
        if (mounted) {
          ref.read(messageProvider.notifier).showError('Error adding player: $e');
        }
      }
    }
  }

  void _confirmDeletePlayer(Player player) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Player'),
        content: Text('Are you sure you want to delete ${player.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final storage = ref.read(enhancedStorageServiceProvider);
              final navigator = Navigator.of(context);
              
              await storage.deletePlayer(player.id);
              navigator.pop();
              if (mounted) {
                ref.read(messageProvider.notifier).showSuccess('${player.name} deleted');
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