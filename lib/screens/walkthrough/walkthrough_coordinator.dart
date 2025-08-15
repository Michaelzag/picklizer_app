import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/enhanced_providers.dart';
import '../../providers/message_provider.dart';
import '../../l10n/app_localizations.dart';
import 'steps/facility_step.dart';
import 'widgets/sticky_summary_widget.dart';
import 'widgets/navigation_controls_widget.dart';

/// Coordinator Pattern: Manages walkthrough flow and step coordination
/// Single Responsibility: Orchestrates step navigation and data flow
class WalkthroughCoordinator extends ConsumerStatefulWidget {
  const WalkthroughCoordinator({super.key});

  @override
  ConsumerState<WalkthroughCoordinator> createState() => _WalkthroughCoordinatorState();
}

class _WalkthroughCoordinatorState extends ConsumerState<WalkthroughCoordinator> {
  int _currentStepIndex = 0;
  final PageController _pageController = PageController();

  // Form controllers for all steps
  final _facilityNameController = TextEditingController();
  final _facilityLocationController = TextEditingController();

  // State tracking
  final Map<int, Map<String, String>> _completedSteps = {};
  bool _isProcessing = false;

  @override
  void dispose() {
    _facilityNameController.dispose();
    _facilityLocationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.getStarted),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Sticky summary of completed steps
          StickySummaryWidget(
            completedSteps: _completedSteps,
            currentStepIndex: _currentStepIndex,
          ),
          
          // Current step content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _buildSteps(),
            ),
          ),
          
          // Navigation controls
          NavigationControlsWidget(
            currentStepIndex: _currentStepIndex,
            totalSteps: _getTotalSteps(),
            canGoNext: _canGoNext(),
            canGoPrevious: _canGoPrevious(),
            isProcessing: _isProcessing,
            onNext: _handleNext,
            onPrevious: _handlePrevious,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSteps() {
    return [
      FacilityStep(
        facilityNameController: _facilityNameController,
        facilityLocationController: _facilityLocationController,
      ),
      // TODO: Add other steps (CourtStep, PlayerStep, SessionStep)
    ];
  }

  int _getTotalSteps() => 4; // Facility, Courts, Players, Session

  bool _canGoNext() {
    switch (_currentStepIndex) {
      case 0: // Facility step
        return _facilityNameController.text.trim().isNotEmpty;
      default:
        return false;
    }
  }

  bool _canGoPrevious() => _currentStepIndex > 0;

  Future<void> _handleNext() async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    try {
      bool success = await _processCurrentStep();
      
      if (success) {
        // Save completed step data
        _completedSteps[_currentStepIndex] = _getCurrentStepSummary();
        
        // Move to next step
        if (_currentStepIndex < _getTotalSteps() - 1) {
          setState(() => _currentStepIndex++);
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          // Final step completed
          await _completeWalkthrough();
        }
      }
    } catch (e) {
      ref.read(messageProvider.notifier).showError('Error: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _handlePrevious() async {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<bool> _processCurrentStep() async {
    switch (_currentStepIndex) {
      case 0: // Facility step
        return await _processFacilityStep();
      default:
        return false;
    }
  }

  Future<bool> _processFacilityStep() async {
    if (_facilityNameController.text.trim().isEmpty) {
      ref.read(messageProvider.notifier).showError('Facility name is required');
      return false;
    }

    try {
      await ref.read(facilitiesProvider.notifier).addFacility(
        name: _facilityNameController.text.trim(),
        location: _facilityLocationController.text.trim().isEmpty 
            ? null 
            : _facilityLocationController.text.trim(),
      );
      
      ref.read(messageProvider.notifier).showSuccess('Facility created successfully!');
      return true;
    } catch (e) {
      ref.read(messageProvider.notifier).showError('Failed to create facility: $e');
      return false;
    }
  }

  Map<String, String> _getCurrentStepSummary() {
    switch (_currentStepIndex) {
      case 0: // Facility step
        return {
          'facility': _facilityNameController.text.trim(),
          if (_facilityLocationController.text.trim().isNotEmpty)
            'location': _facilityLocationController.text.trim(),
        };
      default:
        return {};
    }
  }

  Future<void> _completeWalkthrough() async {
    // TODO: Complete the walkthrough process
    ref.read(messageProvider.notifier).showSuccess('Setup complete!');
    Navigator.of(context).pop();
  }
}