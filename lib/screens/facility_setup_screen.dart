import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/facility.dart';
import '../providers/enhanced_providers.dart';

class FacilitySetupScreen extends ConsumerStatefulWidget {
  final Facility? facility; // For editing existing facility

  const FacilitySetupScreen({
    super.key,
    this.facility,
  });

  @override
  ConsumerState<FacilitySetupScreen> createState() => _FacilitySetupScreenState();
}

class _FacilitySetupScreenState extends ConsumerState<FacilitySetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  bool get isEditing => widget.facility != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final facility = widget.facility!;
      _nameController.text = facility.name;
      _locationController.text = facility.location ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Facility' : 'Create Facility'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
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
                        Icons.business,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEditing ? 'Update Facility Details' : 'Create Your First Facility',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A facility represents a location where you play pickleball',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Form fields
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Facility Name *',
                  hintText: 'e.g., Community Recreation Center',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a facility name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'e.g., 123 Main St, City, State',
                  prefixIcon: Icon(Icons.location_on),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 24),

              // Info card
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'What\'s Next?',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('After creating your facility, you\'ll be able to:'),
                      const SizedBox(height: 4),
                      const Text('• Add courts with different game modes'),
                      const Text('• Create sessions for play periods'),
                      const Text('• Manage players and queues'),
                      const Text('• Track match history'),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Save button
              ElevatedButton(
                onPressed: _saveFacility,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isEditing ? 'Save Changes' : 'Create Facility',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveFacility() async {
    if (_formKey.currentState!.validate()) {
      final storage = ref.read(enhancedStorageServiceProvider);
      
      try {
        if (isEditing) {
          // Update existing facility
          final updatedFacility = widget.facility!.copyWith(
            name: _nameController.text.trim(),
            location: _locationController.text.trim().isEmpty
                ? null
                : _locationController.text.trim(),
          );
          await storage.updateFacility(updatedFacility);
        } else {
          // Create new facility
          final facility = Facility(
            name: _nameController.text.trim(),
            location: _locationController.text.trim().isEmpty
                ? null
                : _locationController.text.trim(),
          );
          await storage.saveFacility(facility);
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing
                    ? 'Facility updated successfully!'
                    : 'Facility created successfully!',
              ),
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
              content: Text('Error saving facility: $e'),
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
}