import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';
import 'walkthrough/walkthrough_coordinator.dart';

/// Simplified dashboard that works with enhanced providers
/// Shows current session status and provides navigation to main features
class SimpleDashboardScreen extends ConsumerWidget {
  const SimpleDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSession = ref.watch(currentSessionProvider);
    final checkIns = ref.watch(sessionCheckInsProvider);
    final facilities = ref.watch(facilitiesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickleizer Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (currentSession == null) ...[
                      const Text('No active session'),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () => _startNewSession(context),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Session'),
                      ),
                    ] else ...[
                      Text('Active session started at ${_formatTime(currentSession.startTime)}'),
                      Text('${checkIns.length} players checked in'),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () => _endSession(context, ref),
                        icon: const Icon(Icons.stop),
                        label: const Text('End Session'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Quick Stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Stats',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            context,
                            'Facilities',
                            facilities.length.toString(),
                            Icons.business,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            'Players',
                            checkIns.length.toString(),
                            Icons.people,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _buildActionCard(
                    context,
                    'Live View',
                    'See active courts',
                    Icons.live_tv,
                    () => _navigateToTab(context, 0),
                  ),
                  _buildActionCard(
                    context,
                    'Queue',
                    'Manage player queue',
                    Icons.queue,
                    () => _navigateToTab(context, 1),
                  ),
                  _buildActionCard(
                    context,
                    'Facilities',
                    'Manage facilities',
                    Icons.business,
                    () => _navigateToTab(context, 2),
                  ),
                  _buildActionCard(
                    context,
                    'Players',
                    'Manage players',
                    Icons.people,
                    () => _navigateToTab(context, 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
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
        builder: (context) => const WalkthroughCoordinator(),
      ),
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

  void _navigateToTab(BuildContext context, int tabIndex) {
    // This would navigate to the main navigation with specific tab
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigate to tab $tabIndex - Feature coming soon')),
    );
  }
}