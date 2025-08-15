import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../walkthrough_step.dart';
import '../widgets/step_header_widget.dart';

/// Facility creation step following Strategy Pattern
/// Single Responsibility: Only handles facility creation
class FacilityStep extends WalkthroughStep {
  final TextEditingController facilityNameController;
  final TextEditingController facilityLocationController;

  const FacilityStep({
    super.key,
    required this.facilityNameController,
    required this.facilityLocationController,
    super.onNext,
    super.onPrevious,
  }) : super(
          stepNumber: 1,
          stepTitle: 'Create Facility',
          stepDescription: 'Add a facility where your courts will be located',
        );

  @override
  bool get isValid => facilityNameController.text.trim().isNotEmpty;

  @override
  Widget buildStepContent(BuildContext context, WidgetRef ref) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepHeaderWidget(
          stepNumber: stepNumber,
          title: stepTitle,
          description: stepDescription,
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Facility Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: facilityNameController,
                  decoration: const InputDecoration(
                    labelText: 'Facility Name *',
                    hintText: 'e.g., Central Park Courts',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _notifyValidationChange(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: facilityLocationController,
                  decoration: const InputDecoration(
                    labelText: 'Location (Optional)',
                    hintText: 'e.g., 123 Main St, City, State',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'A facility groups multiple courts together at one location',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool validateStep() {
    return facilityNameController.text.trim().isNotEmpty;
  }

  @override
  Future<bool> onNextPressed() async {
    if (!validateStep()) {
      return false;
    }
    // Facility creation is handled by the coordinator
    return true;
  }

  @override
  Future<void> onPreviousPressed() async {
    // No previous step, this is the first step
  }

  @override
  Map<String, String> getSummaryData() {
    return {
      'facility': facilityNameController.text.trim(),
      if (facilityLocationController.text.trim().isNotEmpty)
        'location': facilityLocationController.text.trim(),
    };
  }

  void _notifyValidationChange() {
    // Validation state change will be handled by the coordinator
  }

  @override
  ConsumerState<FacilityStep> createState() => _FacilityStepState();
}

class _FacilityStepState extends ConsumerState<FacilityStep> {
  @override
  Widget build(BuildContext context) {
    return widget.buildStepContent(context, ref);
  }
}