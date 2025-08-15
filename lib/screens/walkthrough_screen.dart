import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';
import '../widgets/common/global_message_widget.dart';
import '../models/court.dart';
import 'facility_setup_screen.dart';
import 'courts_management_screen.dart';
import 'session_setup_screen.dart';
import 'players_management_screen.dart';

class WalkthroughScreen extends ConsumerStatefulWidget {
  const WalkthroughScreen({super.key});

  @override
  ConsumerState<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends ConsumerState<WalkthroughScreen> {
  int get currentStep {
    final facilities = ref.watch(facilitiesProvider);
    final players = ref.watch(enhancedPlayersProvider);
    final currentSession = ref.watch(currentSessionProvider);

    // Get courts for the first facility (if any)
    final firstFacilityId = facilities.isNotEmpty ? facilities.first.id : '';
    final courtsAsync = firstFacilityId.isNotEmpty
        ? ref.watch(facilityCourtsProvider(firstFacilityId))
        : const AsyncValue.data(<Court>[]);

    // Determine current step based on app state
    if (facilities.isEmpty) {
      return 0; // Create facility
    } else if (courtsAsync.when(
      data: (courts) => courts.isEmpty,
      loading: () => true,
      error: (error, stackTrace) => true,
    )) {
      return 1; // Add courts
    } else if (currentSession == null) {
      return 2; // Create session
    } else if (players.length < 2) {
      return 3; // Create players
    } else {
      final checkedInPlayers = ref.watch(sessionCheckedInPlayersProvider);
      if (checkedInPlayers.isEmpty) {
        return 4; // Add players to session
      } else {
        return 5; // Start session queue
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Walkthrough'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Progress indicator
                _buildProgressIndicator(),
                const SizedBox(height: 24),
                
                // Current step content
                Expanded(
                  child: _buildStepContent(context),
                ),
                
                // Navigation buttons
                _buildNavigationButtons(context),
              ],
            ),
          ),
          const GlobalMessageWidget(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Text(
          'Step ${currentStep + 1} of 6',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (currentStep + 1) / 6,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ],
    );
  }

  Widget _buildStepContent(BuildContext context) {
    switch (currentStep) {
      case 0:
        return _buildStep1CreateFacility();
      case 1:
        return _buildStep2AddCourts();
      case 2:
        return _buildStep3CreateSession();
      case 3:
        return _buildStep4CreatePlayers();
      case 4:
        return _buildStep5AddPlayersToSession();
      case 5:
        return _buildStep6StartQueue();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1CreateFacility() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.business,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Create Your First Facility',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'A facility represents a location where you play pickleball. This could be a recreation center, club, or any venue with courts.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Examples:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('• Community Recreation Center'),
                const Text('• Pickleball Club'),
                const Text('• Tennis Center'),
                const Text('• Local Park Courts'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2AddCourts() {
    final facilities = ref.watch(facilitiesProvider);
    final facility = facilities.isNotEmpty ? facilities.first : null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.sports_tennis,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Add Courts to ${facility?.name ?? 'Your Facility'}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Courts are where matches are played. Each court can have different game modes and scoring settings.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Court Settings:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('• Singles or Doubles'),
                const Text('• King of Hill or Round Robin'),
                const Text('• Target Score (7, 11, 15, 21)'),
                const Text('• Win by 2 points'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3CreateSession() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.play_circle_outline,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Create a Session',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'A session represents a play period at your facility. Select which courts will be active and their game modes.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Session Info:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('• Choose active courts'),
                const Text('• Set game modes per court'),
                const Text('• Configure scoring'),
                const Text('• Start/end times tracked'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep4CreatePlayers() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.people,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Add Players',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Add at least 2 players to start playing. You can add more players anytime during the session.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_add,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Player Details:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('• Name and skill level'),
                const Text('• Game mode preferences'),
                const Text('• Match history tracking'),
                const Text('• Check-in/out for sessions'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep5AddPlayersToSession() {
    final players = ref.watch(enhancedPlayersProvider);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.how_to_reg,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Check In Players',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Check in players who are present for this session. Only checked-in players will be added to the queue.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        if (players.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Available Players (${players.length}):',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...players.take(3).map((player) => Text('• ${player.name}')),
                  if (players.length > 3)
                    Text('• ... and ${players.length - 3} more'),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStep6StartQueue() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.queue,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Start Playing!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Everything is set up! Players are in the queue and ready to play. The system will automatically manage matches and rotations.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.celebration,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'You\'re Ready!',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('• Queue management'),
                const Text('• Match tracking'),
                const Text('• Score recording'),
                const Text('• Player rotation'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => _handlePreviousStep(context),
                child: const Text('Previous'),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => _handleNextStep(context),
              child: Text(_getNextButtonText()),
            ),
          ),
        ],
      ),
    );
  }

  String _getNextButtonText() {
    switch (currentStep) {
      case 0:
        return 'Create Facility';
      case 1:
        return 'Add Courts';
      case 2:
        return 'Create Session';
      case 3:
        return 'Add Players';
      case 4:
        return 'Check In Players';
      case 5:
        return 'Start Playing!';
      default:
        return 'Next';
    }
  }

  void _handleNextStep(BuildContext context) {
    switch (currentStep) {
      case 0:
        _navigateToFacilitySetup();
        break;
      case 1:
        _navigateToCourtSetup();
        break;
      case 2:
        _navigateToSessionSetup();
        break;
      case 3:
        _navigateToPlayerSetup();
        break;
      case 4:
        _navigateToPlayerCheckIn();
        break;
      case 5:
        _completeWalkthrough();
        break;
    }
  }

  void _navigateToFacilitySetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FacilitySetupScreen(),
      ),
    ).then((_) => setState(() {}));
  }

  void _navigateToCourtSetup() {
    final facilities = ref.read(facilitiesProvider);
    if (facilities.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CourtsManagementScreen(
            facilityId: facilities.first.id,
            isWalkthrough: true,
          ),
        ),
      ).then((_) => setState(() {}));
    }
  }

  void _navigateToSessionSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SessionSetupScreen(),
      ),
    ).then((_) => setState(() {}));
  }

  void _navigateToPlayerSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlayersManagementScreen(isWalkthrough: true),
      ),
    ).then((_) => setState(() {}));
  }

  void _navigateToPlayerCheckIn() {
    // For now, show a message that they should use the Players tab
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Go to the Players tab to check in players for the session'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 20,
          right: 20,
        ),
      ),
    );
  }

  void _handlePreviousStep(BuildContext context) {
    switch (currentStep) {
      case 1:
        // From Add Courts back to Create Facility - show existing facility for editing
        _navigateToEditFacility();
        break;
      case 2:
        // From Create Session back to Add Courts - show existing courts
        _navigateToCourtSetup();
        break;
      case 3:
        // From Add Players back to Create Session - show existing session
        _navigateToSessionSetup();
        break;
      case 4:
        // From Check In Players back to Add Players - show existing players
        _navigateToPlayerSetup();
        break;
      case 5:
        // From Start Queue back to Check In Players
        _navigateToPlayerCheckIn();
        break;
      default:
        // Should not happen, but just in case
        break;
    }
  }

  void _navigateToEditFacility() {
    final facilities = ref.read(facilitiesProvider);
    if (facilities.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FacilitySetupScreen(facility: facilities.first),
        ),
      ).then((_) => setState(() {}));
    } else {
      // Fallback to create new facility
      _navigateToFacilitySetup();
    }
  }

  void _completeWalkthrough() {
    // Exit walkthrough and go to main app
    Navigator.of(context).pushReplacementNamed('/');
  }
}