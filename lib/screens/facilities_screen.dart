import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';
import '../models/facility.dart';
import 'facility_detail_screen.dart';
import 'facility_setup_screen.dart';

class FacilitiesScreen extends ConsumerWidget {
  const FacilitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facilities = ref.watch(facilitiesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facilities'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddFacility(context),
            tooltip: 'Add Facility',
          ),
        ],
      ),
      body: facilities.isEmpty
          ? _buildEmptyState(context)
          : _buildFacilitiesList(context, ref, facilities),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "facilities_fab",
        onPressed: () => _navigateToAddFacility(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Facility'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
            'No Facilities Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first facility to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddFacility(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Facility'),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesList(BuildContext context, WidgetRef ref, List<Facility> facilities) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: facilities.length,
      itemBuilder: (context, index) {
        final facility = facilities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.business,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            title: Text(
              facility.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: facility.location != null
                ? Text(facility.location!)
                : const Text('No location set'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editFacility(context, ref, facility),
                  tooltip: 'Edit Facility',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteFacility(context, ref, facility),
                  tooltip: 'Delete Facility',
                ),
              ],
            ),
            onTap: () => _navigateToFacilityDetail(context, facility.id),
          ),
        );
      },
    );
  }

  void _navigateToAddFacility(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FacilitySetupScreen(),
      ),
    );
  }

  void _navigateToFacilityDetail(BuildContext context, String facilityId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FacilityDetailScreen(facilityId: facilityId),
      ),
    );
  }

  void _editFacility(BuildContext context, WidgetRef ref, Facility facility) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FacilitySetupScreen(facility: facility),
      ),
    );
  }

  void _deleteFacility(BuildContext context, WidgetRef ref, Facility facility) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Facility'),
        content: Text('Are you sure you want to delete "${facility.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(facilitiesProvider.notifier).removeFacility(facility.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${facility.name} deleted')),
              );
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