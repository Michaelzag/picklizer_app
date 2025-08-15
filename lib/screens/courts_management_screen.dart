import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';
import '../providers/message_provider.dart';
import '../models/court.dart';
import 'court_setup_screen.dart';

class CourtsManagementScreen extends ConsumerWidget {
  final String facilityId;
  final bool isWalkthrough;

  const CourtsManagementScreen({
    super.key,
    required this.facilityId,
    this.isWalkthrough = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courtsAsync = ref.watch(facilityCourtsProvider(facilityId));

    return Scaffold(
      appBar: AppBar(
        title: Text(isWalkthrough ? 'Setup Courts' : 'Manage Courts'),
        centerTitle: true,
      ),
      body: courtsAsync.when(
        data: (courts) => _buildContent(context, ref, courts),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading courts: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(facilityCourtsProvider(facilityId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<Court> courts) {
    return Column(
      children: [
        // Header section
        _buildHeader(context, courts.length),
        
        // Courts list or empty state
        Expanded(
          child: courts.isEmpty 
              ? _buildEmptyState(context)
              : _buildCourtsList(context, ref, courts),
        ),
        
        // Bottom action buttons
        _buildBottomActions(context, ref, courts),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, int courtCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.sports_tennis,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                isWalkthrough ? 'Setup Your Courts' : 'Manage Courts',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                courtCount == 0
                    ? 'Add at least one court to continue'
                    : '$courtCount court${courtCount != 1 ? 's' : ''} configured',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (courtCount > 0) ...[
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
            Icons.sports_tennis_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 24),
          Text(
            'No Courts Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add your first court to get started.\nYou can add more courts later.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddCourt(context),
            icon: const Icon(Icons.add),
            label: const Text('Add First Court'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourtsList(BuildContext context, WidgetRef ref, List<Court> courts) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: courts.length,
      itemBuilder: (context, index) {
        final court = courts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                court.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              court.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${court.teamSize.displayName} • ${court.gameMode.displayName}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Target: ${court.targetScore} points',
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
                    _navigateToEditCourt(context, court);
                    break;
                  case 'delete':
                    _confirmDeleteCourt(context, ref, court);
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

  Widget _buildBottomActions(BuildContext context, WidgetRef ref, List<Court> courts) {
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
            // Add Court button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _navigateToAddCourt(context),
                icon: const Icon(Icons.add),
                label: Text(courts.isEmpty ? 'Add First Court' : 'Add Another Court'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            
            // Continue button (only show if we have courts and this is walkthrough)
            if (courts.isNotEmpty && isWalkthrough) ...[
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
                  child: Text('Continue with ${courts.length} Court${courts.length != 1 ? 's' : ''}'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToAddCourt(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourtSetupScreen(facilityId: facilityId),
      ),
    );
  }

  void _navigateToEditCourt(BuildContext context, Court court) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourtSetupScreen(
          facilityId: facilityId,
          court: court,
        ),
      ),
    );
  }

  void _confirmDeleteCourt(BuildContext context, WidgetRef ref, Court court) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Court'),
        content: Text('Are you sure you want to delete "${court.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final storage = ref.read(enhancedStorageServiceProvider);
                await storage.deleteCourt(court.id);
                ref.invalidate(facilityCourtsProvider(facilityId));
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ref.read(messageProvider.notifier).showSuccess('Court "${court.name}" deleted');
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ref.read(messageProvider.notifier).showError('Error deleting court: $e');
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