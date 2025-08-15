import 'package:flutter/material.dart';
import '../../../models/player.dart';
import '../widgets/progressive_accordion_widget.dart';

/// Players step for the accordion walkthrough
class AccordionPlayersStep extends AccordionStep {
  final List<Player> allPlayers;
  final Set<String> selectedPlayerIds;
  final VoidCallback? onChanged;
  final Function(String name)? onAddPlayer;
  final Function(String playerId)? onTogglePlayer;

  AccordionPlayersStep({
    required this.allPlayers,
    required this.selectedPlayerIds,
    this.onChanged,
    this.onAddPlayer,
    this.onTogglePlayer,
  });

  @override
  String get title => 'Select Players';

  @override
  String get description => 'Choose players for this session (minimum 2 required)';

  @override
  Widget buildCurrentContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Available Players',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddPlayerDialog(),
              icon: const Icon(Icons.person_add),
              label: const Text('Add Player'),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        if (allPlayers.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Center(
              child: Text(
                'No players available. Add some players to get started.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ...allPlayers.map((player) => _buildPlayerCard(player)),
        
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selectedPlayerIds.length >= 2 ? Colors.green[50] : Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selectedPlayerIds.length >= 2 ? Colors.green : Colors.orange,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selectedPlayerIds.length >= 2 ? Icons.check_circle : Icons.warning,
                color: selectedPlayerIds.length >= 2 ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedPlayerIds.length >= 2
                      ? '${selectedPlayerIds.length} players selected - ready to start!'
                      : 'Select at least 2 players to start a session',
                  style: TextStyle(
                    color: selectedPlayerIds.length >= 2 ? Colors.green[700] : Colors.orange[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard(Player player) {
    final isSelected = selectedPlayerIds.contains(player.id);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Colors.blue[50] : null,
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (_) => onTogglePlayer?.call(player.id),
        title: Text(
          player.name,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text('Total games: ${player.totalGamesPlayed} • Wins: ${player.totalWins}'),
        secondary: CircleAvatar(
          backgroundColor: isSelected ? Colors.blue : Colors.grey,
          child: Text(
            player.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _showAddPlayerDialog() {
    // This would show a dialog to add a new player
    // For now, we'll add a default player
    final playerCount = allPlayers.length + 1;
    onAddPlayer?.call('Player $playerCount');
  }

  @override
  Widget buildCompletedSummary() {
    final selectedPlayers = allPlayers.where((p) => selectedPlayerIds.contains(p.id)).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.people, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              '${selectedPlayerIds.length} player${selectedPlayerIds.length == 1 ? '' : 's'} selected',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (selectedPlayers.isNotEmpty) ...[
          const Text('Selected players:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...selectedPlayers.map((player) => Padding(
            padding: const EdgeInsets.only(left: 16, top: 2),
            child: Text('• ${player.name}'),
          )),
        ],
      ],
    );
  }

  @override
  String getSummaryText() {
    if (selectedPlayerIds.isEmpty) return 'No players selected';
    return '${selectedPlayerIds.length} player${selectedPlayerIds.length == 1 ? '' : 's'} ready';
  }

  bool get isValid => selectedPlayerIds.length >= 2;
}