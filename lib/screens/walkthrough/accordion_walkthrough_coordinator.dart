import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/enhanced_providers.dart';
import '../../providers/message_provider.dart';
import '../../l10n/app_localizations.dart';
import 'steps/accordion_facility_step.dart';
import 'steps/accordion_courts_step.dart';
import 'steps/accordion_players_step.dart';
import 'steps/accordion_session_step.dart';
import 'widgets/progressive_accordion_widget.dart';
import 'widgets/navigation_controls_widget.dart';
import '../../models/facility.dart';
import '../../models/court.dart';
import '../../models/player.dart';

/// Accordion-based walkthrough coordinator
/// Implements the progressive disclosure pattern with "receipt" summary
class AccordionWalkthroughCoordinator extends ConsumerStatefulWidget {
  const AccordionWalkthroughCoordinator({super.key});

  @override
  ConsumerState<AccordionWalkthroughCoordinator> createState() => _AccordionWalkthroughCoordinatorState();
}

class _AccordionWalkthroughCoordinatorState extends ConsumerState<AccordionWalkthroughCoordinator> {
  int _currentStepIndex = 0;
  bool _isProcessing = false;
  String? _successMessage;
  
  // Form controllers
  final _facilityNameController = TextEditingController();
  final _facilityLocationController = TextEditingController();
  
  // State data
  Facility? _selectedFacility;
  final List<Court> _existingCourts = [];
  final List<Court> _newCourts = [];
  final List<Player> _allPlayers = [];
  final Set<String> _selectedPlayerIds = {};
  
  // Accordion steps
  late List<AccordionStep> _accordionSteps;

  @override
  void initState() {
    super.initState();
    _initializeSteps();
  }

  void _initializeSteps() {
    _accordionSteps = [
      AccordionFacilityStep(
        nameController: _facilityNameController,
        locationController: _facilityLocationController,
        onChanged: _onStepChanged,
      ),
      AccordionCourtsStep(
        facilityId: _selectedFacility?.id ?? '',
        existingCourts: _existingCourts,
        newCourts: _newCourts,
        onChanged: _onStepChanged,
        onAddCourt: _addCourt,
        onRemoveCourt: _removeCourt,
      ),
      AccordionPlayersStep(
        allPlayers: _allPlayers,
        selectedPlayerIds: _selectedPlayerIds,
        onChanged: _onStepChanged,
        onAddPlayer: _addPlayer,
        onTogglePlayer: _togglePlayer,
      ),
      AccordionSessionStep(
        facility: _selectedFacility ?? Facility(name: 'Unknown'),
        courts: [..._existingCourts, ..._newCourts],
        selectedPlayers: _allPlayers.where((p) => _selectedPlayerIds.contains(p.id)).toList(),
        onStartSession: _startSession,
      ),
    ];
  }

  @override
  void dispose() {
    _facilityNameController.dispose();
    _facilityLocationController.dispose();
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
          // Progressive accordion (main content)
          Expanded(
            child: ProgressiveAccordionWidget(
              steps: _accordionSteps,
              currentStepIndex: _currentStepIndex,
              successMessage: _successMessage,
            ),
          ),
          
          // Navigation controls at bottom
          NavigationControlsWidget(
            currentStepIndex: _currentStepIndex,
            totalSteps: _accordionSteps.length,
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

  bool _canGoNext() {
    if (_currentStepIndex >= _accordionSteps.length) return false;
    
    switch (_currentStepIndex) {
      case 0: // Facility step
        final facilityStep = _accordionSteps[0] as AccordionFacilityStep;
        return facilityStep.isValid;
      case 1: // Courts step
        final courtsStep = _accordionSteps[1] as AccordionCourtsStep;
        return courtsStep.isValid;
      case 2: // Players step
        final playersStep = _accordionSteps[2] as AccordionPlayersStep;
        return playersStep.isValid;
      case 3: // Session step
        final sessionStep = _accordionSteps[3] as AccordionSessionStep;
        return sessionStep.isValid;
      default:
        return false;
    }
  }

  bool _canGoPrevious() => _currentStepIndex > 0;

  void _onStepChanged() {
    setState(() {}); // Refresh validation state
  }

  void _addCourt(String name, TeamSize teamSize, GameMode gameMode) {
    final court = Court(
      facilityId: _selectedFacility?.id ?? '',
      name: name,
      teamSize: teamSize,
      gameMode: gameMode,
    );
    setState(() {
      _newCourts.add(court);
    });
  }

  void _removeCourt(Court court) {
    setState(() {
      _newCourts.remove(court);
    });
  }

  void _addPlayer(String name) {
    final player = Player(
      name: name,
      addedAt: DateTime.now(),
    );
    setState(() {
      _allPlayers.add(player);
    });
  }

  void _togglePlayer(String playerId) {
    setState(() {
      if (_selectedPlayerIds.contains(playerId)) {
        _selectedPlayerIds.remove(playerId);
      } else {
        _selectedPlayerIds.add(playerId);
      }
    });
  }

  void _startSession() {
    // This would start the actual session
    // For now, just show success
    ref.read(messageProvider.notifier).showSuccess('Session started successfully!');
  }

  Future<void> _handleNext() async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    try {
      bool success = await _processCurrentStep();
      
      if (success) {
        // Show success message
        setState(() {
          _successMessage = _getSuccessMessage(_currentStepIndex);
        });
        
        // Clear success message after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => _successMessage = null);
          }
        });
        
        // Move to next step
        if (_currentStepIndex < _accordionSteps.length - 1) {
          setState(() => _currentStepIndex++);
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
    }
  }

  Future<bool> _processCurrentStep() async {
    switch (_currentStepIndex) {
      case 0: // Facility step
        return await _processFacilityStep();
      case 1: // Courts step
        return await _processCourtsStep();
      case 2: // Players step
        return await _processPlayersStep();
      case 3: // Session step
        return await _processSessionStep();
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
      
      // Update selected facility
      final facilities = ref.read(facilitiesProvider);
      _selectedFacility = facilities.last; // Get the newly created facility
      
      // Refresh steps with new facility
      _initializeSteps();
      
      return true;
    } catch (e) {
      ref.read(messageProvider.notifier).showError('Failed to create facility: $e');
      return false;
    }
  }

  Future<bool> _processCourtsStep() async {
    if (_existingCourts.isEmpty && _newCourts.isEmpty) {
      ref.read(messageProvider.notifier).showError('At least one court is required');
      return false;
    }

    try {
      // Save new courts to storage
      for (final court in _newCourts) {
        // In a real app, we'd save to storage here
        // For now, just move to existing courts
        _existingCourts.add(court);
      }
      _newCourts.clear();
      
      return true;
    } catch (e) {
      ref.read(messageProvider.notifier).showError('Failed to save courts: $e');
      return false;
    }
  }

  Future<bool> _processPlayersStep() async {
    if (_selectedPlayerIds.length < 2) {
      ref.read(messageProvider.notifier).showError('At least 2 players are required');
      return false;
    }

    try {
      // Save players to storage
      for (final player in _allPlayers) {
        // In a real app, we'd save to storage here
        await ref.read(enhancedPlayersProvider.notifier).addPlayer(
          name: player.name,
        );
      }
      
      return true;
    } catch (e) {
      ref.read(messageProvider.notifier).showError('Failed to save players: $e');
      return false;
    }
  }

  Future<bool> _processSessionStep() async {
    try {
      // Start the actual session
      if (_selectedFacility != null) {
        await ref.read(currentSessionProvider.notifier).startNewSession(
          facilityId: _selectedFacility!.id,
        );
        
        // Check in selected players
        for (final playerId in _selectedPlayerIds) {
          await ref.read(sessionCheckInsProvider.notifier).checkInPlayer(
            playerId: playerId,
          );
        }
      }
      
      return true;
    } catch (e) {
      ref.read(messageProvider.notifier).showError('Failed to start session: $e');
      return false;
    }
  }

  String _getSuccessMessage(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return '✓ Facility "${_facilityNameController.text.trim()}" created successfully!';
      case 1:
        final totalCourts = _existingCourts.length + _newCourts.length;
        return '✓ $totalCourts court${totalCourts == 1 ? '' : 's'} configured!';
      case 2:
        return '✓ ${_selectedPlayerIds.length} player${_selectedPlayerIds.length == 1 ? '' : 's'} selected!';
      case 3:
        return '✓ Session started successfully!';
      default:
        return '✓ Step completed successfully!';
    }
  }

  Future<void> _completeWalkthrough() async {
    // TODO: Complete the walkthrough process
    ref.read(messageProvider.notifier).showSuccess('Setup complete!');
    Navigator.of(context).pop();
  }
}