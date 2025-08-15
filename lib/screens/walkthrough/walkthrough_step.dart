import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Strategy Pattern: Abstract base class for walkthrough steps
/// This separates concerns and makes each step independently maintainable
abstract class WalkthroughStep extends ConsumerStatefulWidget {
  final int stepNumber;
  final String stepTitle;
  final String stepDescription;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool isValid;

  const WalkthroughStep({
    super.key,
    required this.stepNumber,
    required this.stepTitle,
    required this.stepDescription,
    this.onNext,
    this.onPrevious,
    this.isValid = false,
  });

  /// Build the step content - each step implements its own UI
  Widget buildStepContent(BuildContext context, WidgetRef ref);

  /// Validate the step data
  bool validateStep();

  /// Called when next button is pressed
  Future<bool> onNextPressed();

  /// Called when previous button is pressed
  Future<void> onPreviousPressed();

  /// Get summary data for sticky header
  Map<String, String> getSummaryData();

  @override
  ConsumerState<WalkthroughStep> createState() => _WalkthroughStepState();
}

class _WalkthroughStepState extends ConsumerState<WalkthroughStep> {
  @override
  Widget build(BuildContext context) {
    return widget.buildStepContent(context, ref);
  }
}

/// Result returned by step navigation
class StepNavigationResult {
  final bool success;
  final String? errorMessage;
  final Map<String, dynamic>? data;

  const StepNavigationResult({
    required this.success,
    this.errorMessage,
    this.data,
  });

  static const succeeded = StepNavigationResult(success: true);
  
  static StepNavigationResult error(String message) => 
      StepNavigationResult(success: false, errorMessage: message);
      
  static StepNavigationResult withData(Map<String, dynamic> data) => 
      StepNavigationResult(success: true, data: data);
}