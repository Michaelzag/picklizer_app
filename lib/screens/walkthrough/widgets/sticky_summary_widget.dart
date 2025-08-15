import 'package:flutter/material.dart';

/// Sticky summary widget showing completed step data
/// Following DRY principle for consistent summary display
class StickySummaryWidget extends StatelessWidget {
  final Map<int, Map<String, String>> completedSteps;
  final int currentStepIndex;

  const StickySummaryWidget({
    super.key,
    required this.completedSteps,
    required this.currentStepIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (completedSteps.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: completedSteps.entries.map((entry) {
            return _buildStepSummary(context, entry.key, entry.value);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStepSummary(BuildContext context, int stepIndex, Map<String, String> data) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.check,
              size: 14,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getStepTitle(stepIndex),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              ...data.entries.map((entry) => Text(
                entry.value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return 'Facility';
      case 1:
        return 'Courts';
      case 2:
        return 'Players';
      case 3:
        return 'Session';
      default:
        return 'Step ${stepIndex + 1}';
    }
  }
}