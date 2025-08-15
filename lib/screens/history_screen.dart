import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/match.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchState = ref.watch(matchesProvider);
    final players = ref.watch(playersProvider);
    final completedMatches = matchState.todaysMatches
        .where((match) => match.completed)
        .toList()
      ..sort((a, b) => b.endTime!.compareTo(a.endTime!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Matches'),
        centerTitle: true,
      ),
      body: completedMatches.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No completed matches today',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: completedMatches.length + 1, // +1 for stats header
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildStatsHeader(context, players);
                }
                
                final match = completedMatches[index - 1];
                return _buildMatchCard(context, match, players);
              },
            ),
    );
  }

  Widget _buildStatsHeader(BuildContext context, List<dynamic> players) {
    // Calculate today's stats
    final playersWithGames = players.where((p) => p.gamesPlayed > 0).toList()
      ..sort((a, b) {
        // Sort by wins first, then by win rate
        if (b.wins != a.wins) {
          return b.wins.compareTo(a.wins);
        }
        return b.winRate.compareTo(a.winRate);
      });

    if (playersWithGames.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Leaders',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...playersWithGames.take(3).map((player) {
              final winPercentage = (player.winRate * 100).toStringAsFixed(0);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        player.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        player.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      '${player.wins}W-${player.gamesPlayed - player.wins}L',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$winPercentage%',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, Match match, List<dynamic> players) {
    // Get player names
    final team1Names = match.team1PlayerIds.map((id) {
      try {
        final player = players.firstWhere((p) => p.id == id);
        return player.name;
      } catch (e) {
        return 'Unknown';
      }
    }).join(' & ');
    
    final team2Names = match.team2PlayerIds.map((id) {
      try {
        final player = players.firstWhere((p) => p.id == id);
        return player.name;
      } catch (e) {
        return 'Unknown';
      }
    }).join(' & ');

    final isTeam1Winner = match.team1Score > match.team2Score;
    final duration = match.duration;
    final durationText = duration != null
        ? '${duration.inMinutes}m'
        : 'Unknown';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                team1Names,
                style: TextStyle(
                  fontWeight: isTeam1Winner ? FontWeight.bold : FontWeight.normal,
                  color: isTeam1Winner ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
            ),
            Text(
              '${match.team1Score} - ${match.team2Score}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                team2Names,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: !isTeam1Winner ? FontWeight.bold : FontWeight.normal,
                  color: !isTeam1Winner ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatTime(match.endTime!),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Duration: $durationText',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}