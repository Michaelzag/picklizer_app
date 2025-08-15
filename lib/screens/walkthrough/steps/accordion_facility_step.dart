import 'package:flutter/material.dart';
import '../widgets/progressive_accordion_widget.dart';

/// Facility step for the accordion walkthrough
class AccordionFacilityStep extends AccordionStep {
  final TextEditingController nameController;
  final TextEditingController locationController;
  final VoidCallback? onChanged;

  AccordionFacilityStep({
    required this.nameController,
    required this.locationController,
    this.onChanged,
  });

  @override
  String get title => 'Create Facility';

  @override
  String get description => 'Set up a facility where your courts will be located';

  @override
  Widget buildCurrentContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Facility Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Facility Name *',
            hintText: 'e.g., Central Park Courts',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => onChanged?.call(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: locationController,
          decoration: const InputDecoration(
            labelText: 'Location (Optional)',
            hintText: 'e.g., 123 Main St, City, State',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.blue,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'A facility groups multiple courts together at one location',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget buildCompletedSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.business, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                nameController.text.trim(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        if (locationController.text.trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  locationController.text.trim(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  String getSummaryText() {
    final name = nameController.text.trim();
    final location = locationController.text.trim();
    
    if (name.isEmpty) return 'No facility created';
    
    if (location.isNotEmpty) {
      return '$name • $location';
    } else {
      return name;
    }
  }

  bool get isValid => nameController.text.trim().isNotEmpty;
}