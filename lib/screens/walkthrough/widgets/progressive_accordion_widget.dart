import 'package:flutter/material.dart';

/// Progressive accordion widget that shows completed steps as collapsed summaries
/// and current step as expanded content - following the "receipt" pattern
class ProgressiveAccordionWidget extends StatelessWidget {
  final List<AccordionStep> steps;
  final int currentStepIndex;
  final String? successMessage;

  const ProgressiveAccordionWidget({
    super.key,
    required this.steps,
    required this.currentStepIndex,
    this.successMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Success message at very top (can cover app header)
        if (successMessage != null)
          Container(
            width: double.infinity,
            color: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              bottom: false,
              child: Text(
                successMessage!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        
        // Accordion sections
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Completed steps (collapsed)
                ...steps.asMap().entries.where((entry) => entry.key < currentStepIndex).map((entry) {
                  return _buildCompletedStep(context, entry.key, entry.value);
                }),
                
                // Current step (expanded)
                if (currentStepIndex < steps.length)
                  _buildCurrentStep(context, currentStepIndex, steps[currentStepIndex]),
                
                // Future steps (minimal preview)
                ...steps.asMap().entries.where((entry) => entry.key > currentStepIndex).map((entry) {
                  return _buildFutureStep(context, entry.key, entry.value);
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedStep(BuildContext context, int stepIndex, AccordionStep step) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 1,
        child: ExpansionTile(
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.green,
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          title: Text(
            step.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(
            step.getSummaryText(),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          initiallyExpanded: false,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: step.buildCompletedSummary(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context, int stepIndex, AccordionStep step) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 3,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      '${stepIndex + 1}',
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
                          step.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          step.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              step.buildCurrentContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFutureStep(BuildContext context, int stepIndex, AccordionStep step) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Card(
        color: Colors.grey[100],
        child: ListTile(
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[400],
            child: Text(
              '${stepIndex + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            step.title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            'Not started',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

/// Abstract class for accordion steps
abstract class AccordionStep {
  String get title;
  String get description;
  
  /// Build the content for when this step is current
  Widget buildCurrentContent();
  
  /// Build the summary for when this step is completed
  Widget buildCompletedSummary();
  
  /// Get a short text summary for the collapsed view
  String getSummaryText();
}