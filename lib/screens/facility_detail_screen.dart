import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';
import '../models/facility.dart';
import '../models/court.dart';
import 'court_setup_screen.dart';

// Provider for courts by facility
final courtsByFacilityProvider = FutureProvider.family<List<Court>, String>((ref, facilityId) async {
  final storage = ref.read(enhancedStorageServiceProvider);
  return await storage.getCourtsByFacility(facilityId);
});

class FacilityDetailScreen extends ConsumerWidget {
  final String facilityId;

  const FacilityDetailScreen({
    super.key,
    required this.facilityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facilityAsync = ref.watch(facilitiesProvider.select((facilities) => 
        facilities.firstWhere((f) => f.id == facilityId)));
    final courtsAsync = ref.watch(courtsByFacilityProvider(facilityId));

    return Scaffold(
      appBar: AppBar(
        title: Text(facilityAsync.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditFacilityDialog(context, ref, facilityAsync),
            tooltip: 'Edit facility',
          ),
        ],
      ),
      body: Column(
        children: [
          // Facility info card
          _buildFacilityInfoCard(context, facilityAsync),
          
          const Divider(),
          
          // Courts section
          Expanded(
            child: courtsAsync.when(
              data: (courts) => _buildCourtsList(context, ref, courts),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading courts: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CourtSetupScreen(facilityId: facilityId),
            ),
          );
        },
        tooltip: 'Add Court',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFacilityInfoCard(BuildContext context, Facility facility) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    facility.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        facility.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (facility.location != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                facility.location!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourtsList(BuildContext context, WidgetRef ref, List<Court> courts) {
    if (courts.isEmpty) {
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
              'No courts configured',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Tap the + button to add your first court'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: courts.length,
      itemBuilder: (context, index) {
        final court = courts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: court.isActive 
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: court.isActive ? null : Colors.grey,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${court.teamSize.name.toUpperCase()} • ${court.gameMode.name.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: court.isActive ? null : Colors.grey,
                  ),
                ),
                Text(
                  'Target: ${court.targetScore} points',
                  style: TextStyle(
                    fontSize: 12,
                    color: court.isActive
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!court.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'INACTIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _editCourt(context, ref, court);
                        break;
                      case 'toggle':
                        _toggleCourtActive(ref, court);
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
                    PopupMenuItem(
                      value: 'toggle',
                      child: ListTile(
                        leading: Icon(court.isActive ? Icons.pause : Icons.play_arrow),
                        title: Text(court.isActive ? 'Deactivate' : 'Activate'),
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
              ],
            ),
            onTap: court.isActive ? () {
              // TODO: Navigate to court detail/history screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Court detail for ${court.name} - Coming soon!')),
              );
            } : null,
          ),
        );
      },
    );
  }

  void _showEditFacilityDialog(BuildContext context, WidgetRef ref, Facility facility) {
    final nameController = TextEditingController(text: facility.name);
    final locationController = TextEditingController(text: facility.location ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Facility'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Facility Name',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location (Optional)',
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final updatedFacility = facility.copyWith(
                  name: name,
                  location: locationController.text.trim().isEmpty
                      ? null
                      : locationController.text.trim(),
                );
                ref.read(facilitiesProvider.notifier).updateFacility(updatedFacility);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editCourt(BuildContext context, WidgetRef ref, Court court) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourtSetupScreen(
          facilityId: facilityId,
          court: court, // Pass existing court for editing
        ),
      ),
    );
  }

  void _toggleCourtActive(WidgetRef ref, Court court) {
    // TODO: Implement court activation/deactivation
    final storage = ref.read(enhancedStorageServiceProvider);
    final updatedCourt = court.copyWith(isActive: !court.isActive);
    storage.updateCourt(updatedCourt);
    ref.invalidate(courtsByFacilityProvider(facilityId));
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
            onPressed: () {
              final storage = ref.read(enhancedStorageServiceProvider);
              storage.deleteCourt(court.id);
              ref.invalidate(courtsByFacilityProvider(facilityId));
              Navigator.pop(context);
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