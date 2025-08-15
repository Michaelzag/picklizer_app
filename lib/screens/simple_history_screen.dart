import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';

/// Simple history screen that works with enhanced providers
/// Shows session history and basic stats
class SimpleHistoryScreen extends ConsumerWidget {
  const SimpleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSession = ref.watch(currentSessionProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session History'),
        centerTitle: true,
      ),
      body: currentSession == null
          ? _buildNoSessionState(context)
          : _buildHistoryContent(context, ref, currentSession),
    );
  }

  Widget _buildNoSessionState(BuildContext context) {
    return Center(
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
            'No Active Session',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text('Start a session to track match history'),
        ],
      ),
    );
  }

  Widget _buildHistoryContent(BuildContext context, WidgetRef ref, dynamic session) {
    final checkIns = ref.watch(sessionCheckInsProvider);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Session',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Started: ${_formatTime(session.startTime)}'),
                  Text('${checkIns.length} players participated'),
                  Text('Status: ${session.status.displayName}'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Player Stats
          Text(
            'Player Participation',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Expanded(
            child: checkIns.isEmpty
                ? const Center(child: Text('No players checked in yet'))
                : ListView.builder(
                    itemCount: checkIns.length,
                    itemBuilder: (context, index) {
                      final checkIn = checkIns[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: checkIn.isCheckedIn 
                                ? Colors.green 
                                : Colors.grey,
                            child: Icon(
                              checkIn.isCheckedIn ? Icons.check : Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          title: Text('Player ${checkIn.playerId}'), // TODO: Get actual player name
                          subtitle: Text(
                            'Checked in: ${_formatTime(checkIn.checkInTime)}',
                          ),
                          trailing: checkIn.isCheckedIn
                              ? const Text('Active')
                              : Text('Left: ${_formatTime(checkIn.checkOutTime!)}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}