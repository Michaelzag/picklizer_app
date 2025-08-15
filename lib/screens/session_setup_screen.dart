import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';
import '../models/facility.dart';
import '../models/court.dart';

class SessionSetupScreen extends ConsumerStatefulWidget {
  const SessionSetupScreen({super.key});

  @override
  ConsumerState<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends ConsumerState<SessionSetupScreen> {
  Facility? selectedFacility;
  List<String> selectedCourtIds = [];

  @override
  Widget build(BuildContext context) {
    final facilities = ref.watch(facilitiesProvider);
    final courtsAsync = ref.watch(facilityCourtsProvider(selectedFacility?.id ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Session'),
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
                      Icons.play_circle_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create New Session',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select a facility and courts for your play session',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Facility selection
            Text(
              'Select Facility',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            
            if (facilities.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 8),
                      const Text('No facilities available'),
                      const Text('Please create a facility first'),
                    ],
                  ),
                ),
              )
            else
              DropdownButtonFormField<Facility>(
                value: selectedFacility,
                decoration: const InputDecoration(
                  labelText: 'Facility',
                  prefixIcon: Icon(Icons.business),
                ),
                items: facilities.map((facility) {
                  return DropdownMenuItem(
                    value: facility,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(facility.name),
                        if (facility.location != null)
                          Text(
                            facility.location!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (facility) {
                  setState(() {
                    selectedFacility = facility;
                    selectedCourtIds.clear(); // Clear court selection when facility changes
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a facility';
                  }
                  return null;
                },
              ),

            const SizedBox(height: 24),

            // Court selection
            if (selectedFacility != null) ...[
              Text(
                'Select Courts',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              
              courtsAsync.when(
                data: (courts) {
                  if (courts.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              Icons.warning_amber,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(height: 8),
                            Text('No courts available at ${selectedFacility!.name}'),
                            const Text('Please add courts to this facility first'),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  return Expanded(
                    child: ListView.builder(
                      itemCount: courts.length,
                      itemBuilder: (context, index) {
                        final court = courts[index];
                        final isSelected = selectedCourtIds.contains(court.id);
                        
                        return Card(
                          child: CheckboxListTile(
                            value: isSelected,
                            onChanged: (selected) {
                              setState(() {
                                if (selected == true) {
                                  selectedCourtIds.add(court.id);
                                } else {
                                  selectedCourtIds.remove(court.id);
                                }
                              });
                            },
                            title: Text(court.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${court.teamSize.displayName} • ${court.gameMode.displayName}'),
                                Text('${court.targetScore} points'),
                              ],
                            ),
                            secondary: Icon(
                              Icons.sports_tennis,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 8),
                        const Text('Error loading courts'),
                        Text(error.toString()),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // Create session button
            if (selectedFacility != null && selectedCourtIds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: _createSession,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Create Session (${selectedCourtIds.length} court${selectedCourtIds.length != 1 ? 's' : ''})',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _createSession() async {
    if (selectedFacility == null || selectedCourtIds.isEmpty) {
      return;
    }

    try {
      await ref.read(currentSessionProvider.notifier).startNewSession(
        facilityId: selectedFacility!.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Session created successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).size.height - 150,
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating session: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).size.height - 150,
            ),
          ),
        );
      }
    }
  }
}