import 'package:flutter/material.dart';

/// Navigation controls widget for walkthrough steps
/// Single Responsibility: Handle step navigation UI
class NavigationControlsWidget extends StatelessWidget {
  final int currentStepIndex;
  final int totalSteps;
  final bool canGoNext;
  final bool canGoPrevious;
  final bool isProcessing;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const NavigationControlsWidget({
    super.key,
    required this.currentStepIndex,
    required this.totalSteps,
    required this.canGoNext,
    required this.canGoPrevious,
    required this.isProcessing,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Previous button
            if (canGoPrevious) ...[
              OutlinedButton.icon(
                onPressed: isProcessing ? null : onPrevious,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
              ),
              const SizedBox(width: 16),
            ],
            
            // Step indicator
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Step ${currentStepIndex + 1} of $totalSteps',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: (currentStepIndex + 1) / totalSteps,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Next button
            ElevatedButton.icon(
              onPressed: (canGoNext && !isProcessing) ? onNext : null,
              icon: isProcessing 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(currentStepIndex == totalSteps - 1 ? Icons.check : Icons.arrow_forward),
              label: Text(currentStepIndex == totalSteps - 1 ? 'Complete' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }
}