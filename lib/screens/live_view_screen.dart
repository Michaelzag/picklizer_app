import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';
import '../models/court.dart';
import '../models/session.dart';
import 'walkthrough/accordion_walkthrough_coordinator.dart';

class LiveViewScreen extends ConsumerWidget {
  const LiveViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSession = ref.watch(currentSessionProvider);
    final checkIns = ref.watch(sessionCheckInsProvider);
    
    final courtsAsync = currentSession != null 
        ? ref.watch(facilityCourtsProvider(currentSession.facilityId))
        : const AsyncValue.data(<Court>[]);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live View'),
        centerTitle: true,
        actions: [
          if (currentSession == null)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => _startNewSession(context),
              tooltip: 'Start Session',
            ),
          if (currentSession != null)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () => _endSession(context, ref),
              tooltip: 'End Session',
            ),
        ],
      ),
      body: currentSession == null
          ? _buildNoSessionState(context)
          : courtsAsync.when(
              data: (courts) => courts.isEmpty
                  ? _buildNoCourtsState(context)
                  : _buildSessionView(context, ref, currentSession, courts, checkIns),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
    );
  }

  Widget _buildNoSessionState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_tennis,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No Active Session',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Start a session to see live court activity',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _startNewSession(context),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Session'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCourtsState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No Courts Available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add courts to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _setupSession(context),
            icon: const Icon(Icons.settings),
            label: const Text('Setup Session'),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionView(BuildContext context, WidgetRef ref, Session session, 
                          List<Court> courts, List<dynamic> checkIns) {
    return Column(
      children: [
        // Session Header
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Started: ${_formatTime(session.startTime)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                '${checkIns.length} players checked in',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
        // Courts Grid
        Expanded(
          child: courts.isEmpty
              ? const Center(child: Text('No courts in this session'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: courts.length,
                  itemBuilder: (context, index) {
                    final court = courts[index];
                    return _buildCourtCard(context, ref, court);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCourtCard(BuildContext context, WidgetRef ref, Court court) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _viewCourtDetails(context, court),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    court.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    court.matchInProgress ? Icons.play_circle : Icons.pause_circle,
                    color: court.matchInProgress ? Colors.green : Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${court.teamSize.displayName} • ${court.gameMode.displayName}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              if (court.matchInProgress) ...[
                Text(
                  'Match in Progress',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (court.matchStartTime != null)
                  Text(
                    'Started: ${_formatTime(court.matchStartTime!)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ] else ...[
                Text(
                  'Available',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _startNewSession(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AccordionWalkthroughCoordinator(),
      ),
    );
  }

  void _setupSession(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AccordionWalkthroughCoordinator(),
      ),
    );
  }

  void _viewCourtDetails(BuildContext context, Court court) {
    // TODO: Navigate to court detail/match screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Court details for ${court.name} - Coming soon')),
    );
  }

  void _endSession(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session'),
        content: const Text('Are you sure you want to end the current session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(currentSessionProvider.notifier).endCurrentSession();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }
}