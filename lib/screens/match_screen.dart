import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class MatchScreen extends ConsumerWidget {
  final String courtId;
  final String courtName;

  const MatchScreen({
    super.key,
    required this.courtId,
    required this.courtName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchState = ref.watch(matchesProvider);
    final match = matchState.activeMatches[courtId];
    final players = ref.watch(playersProvider);
    
    if (match == null) {
      return Scaffold(
        appBar: AppBar(title: Text(courtName)),
        body: const Center(
          child: Text('No active match on this court'),
        ),
      );
    }

    // Get player names
    final team1Names = match.team1PlayerIds.map((id) {
      final player = players.firstWhere((p) => p.id == id);
      return player.name;
    }).join(' & ');
    
    final team2Names = match.team2PlayerIds.map((id) {
      final player = players.firstWhere((p) => p.id == id);
      return player.name;
    }).join(' & ');

    return Scaffold(
      appBar: AppBar(
        title: Text(courtName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Match duration
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDuration(DateTime.now().difference(match.startTime)),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Team 1
            _buildTeamCard(
              context,
              ref,
              'Team 1',
              team1Names,
              match.team1Score,
              true,
              match,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'VS',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Team 2
            _buildTeamCard(
              context,
              ref,
              'Team 2',
              team2Names,
              match.team2Score,
              false,
              match,
            ),
            
            const Spacer(),
            
            // End match button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showEndMatchDialog(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('End Match'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(
    BuildContext context,
    WidgetRef ref,
    String teamLabel,
    String playerNames,
    int score,
    bool isTeam1,
    dynamic match,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              teamLabel,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            Text(
              playerNames,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: score > 0
                      ? () {
                          if (isTeam1) {
                            ref.read(matchesProvider.notifier).updateScore(
                                courtId, score - 1, match.team2Score);
                          } else {
                            ref.read(matchesProvider.notifier).updateScore(
                                courtId, match.team1Score, score - 1);
                          }
                        }
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                  iconSize: 32,
                ),
                const SizedBox(width: 24),
                Text(
                  score.toString(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: score > (isTeam1 ? match.team2Score : match.team1Score)
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  onPressed: () {
                    if (isTeam1) {
                      ref.read(matchesProvider.notifier).updateScore(
                          courtId, score + 1, match.team2Score);
                    } else {
                      ref.read(matchesProvider.notifier).updateScore(
                          courtId, match.team1Score, score + 1);
                    }
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 32,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEndMatchDialog(BuildContext context, WidgetRef ref) {
    final matchState = ref.read(matchesProvider);
    final match = matchState.activeMatches[courtId];
    
    if (match == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Match'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Final Score: ${match.team1Score} - ${match.team2Score}'),
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
            onPressed: () async {
              await ref.read(matchesProvider.notifier).endMatch(courtId);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to dashboard
              }
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

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes < 60) {
      return '${minutes}m ${seconds}s';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins}m';
  }
}