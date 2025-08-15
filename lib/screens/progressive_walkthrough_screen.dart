import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/enhanced_providers.dart';
import '../providers/message_provider.dart';
import '../widgets/common/global_message_widget.dart';
import '../models/facility.dart';
import '../models/court.dart';
import '../models/player.dart';
import '../models/session.dart';
import 'facility_setup_screen.dart';
import 'courts_management_screen.dart';
import 'players_management_screen.dart';

class ProgressiveWalkthroughScreen extends ConsumerStatefulWidget {
  const ProgressiveWalkthroughScreen({super.key});

  @override
  ConsumerState<ProgressiveWalkthroughScreen> createState() => _ProgressiveWalkthroughScreenState();
}

class _ProgressiveWalkthroughScreenState extends ConsumerState<ProgressiveWalkthroughScreen> {
  int _currentStep = 0;
  
  @override
  Widget build(BuildContext context) {
    final facilities = ref.watch(facilitiesProvider);
    final players = ref.watch(enhancedPlayersProvider);
    
    // Auto-determine current step based on completion
    _currentStep = _determineCurrentStep(facilities, players);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Sticky accordion header with completed steps
              _buildStickyHeader(),
              
              // Current step content
              Expanded(
                child: _buildCurrentStepContent(),
              ),
            ],
          ),
          // Success message at the very top (can cover app header)
          const GlobalMessageWidget(),
        ],
      ),
    );
  }

  int _determineCurrentStep(List<Facility> facilities, List<Player> players) {
    if (facilities.isEmpty) {
      return 0; // Need facility
    }
    
    final facility = facilities.first;
    final courtsAsync = ref.watch(facilityCourtsProvider(facility.id));
    final courts = courtsAsync.when(
      data: (courts) => courts,
      loading: () => <Court>[],
      error: (error, stackTrace) => <Court>[],
    );
    
    if (courts.isEmpty) {
      return 1; // Need courts
    }
    
    if (players.length < 2) {
      return 2; // Need players
    }
    
    final currentSession = ref.watch(currentSessionProvider);
    if (currentSession == null) {
      return 3; // Need to start session
    }
    
    return 4; // All done
  }

  Widget _buildStickyHeader() {
    final facilities = ref.watch(facilitiesProvider);
    final players = ref.watch(enhancedPlayersProvider);
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Step 1: Facility (completed)
          if (_currentStep > 0 && facilities.isNotEmpty)
            _buildCompletedStepHeader(
              icon: Icons.business,
              title: facilities.first.name,
              subtitle: facilities.first.location ?? AppLocalizations.of(context)!.noLocation,
              onTap: () => _editStep(0),
            ),
          
          // Step 2: Courts (completed)
          if (_currentStep > 1)
            Consumer(
              builder: (context, ref, child) {
                final facility = facilities.first;
                final courtsAsync = ref.watch(facilityCourtsProvider(facility.id));
                return courtsAsync.when(
                  data: (courts) => _buildCompletedStepHeader(
                    icon: Icons.sports_tennis,
                    title: courts.length == 1
                        ? AppLocalizations.of(context)!.courtCount(courts.length)
                        : AppLocalizations.of(context)!.courtsCount(courts.length),
                    subtitle: courts.map((c) => c.name).join(', '),
                    onTap: () => _editStep(1),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
            ),
          
          // Step 3: Players (completed)
          if (_currentStep > 2 && players.length >= 2)
            _buildCompletedStepHeader(
              icon: Icons.people,
              title: players.length == 1
                  ? AppLocalizations.of(context)!.playerCount(players.length)
                  : AppLocalizations.of(context)!.playersCount(players.length),
              subtitle: players.take(3).map((p) => p.name).join(', ') +
                       (players.length > 3 ? AppLocalizations.of(context)!.morePlayersIndicator(players.length - 3) : ''),
              onTap: () => _editStep(2),
            ),
          
          // Step 4: Session (completed)
          if (_currentStep > 3)
            Consumer(
              builder: (context, ref, child) {
                final session = ref.watch(currentSessionProvider);
                if (session == null) return const SizedBox.shrink();
                
                final timeStr = '${session.startTime.hour.toString().padLeft(2, '0')}:${session.startTime.minute.toString().padLeft(2, '0')}';
                
                return _buildCompletedStepHeader(
                  icon: Icons.play_circle,
                  title: AppLocalizations.of(context)!.sessionActive,
                  subtitle: AppLocalizations.of(context)!.startedAt(timeStr),
                  onTap: null, // Can't edit active session
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCompletedStepHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.green.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.edit,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildFacilityStep();
      case 1:
        return _buildCourtsStep();
      case 2:
        return _buildPlayersStep();
      case 3:
        return _buildSessionStep();
      case 4:
        return _buildCompletedStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildFacilityStep() {
    return _buildStepCard(
      icon: Icons.business,
      title: AppLocalizations.of(context)!.createYourFacility,
      description: AppLocalizations.of(context)!.facilityDescription,
      buttonText: AppLocalizations.of(context)!.createFacility,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FacilitySetupScreen(),
          ),
        );
      },
    );
  }

  Widget _buildCourtsStep() {
    final facilities = ref.watch(facilitiesProvider);
    if (facilities.isEmpty) return const SizedBox();
    
    return _buildStepCard(
      icon: Icons.sports_tennis,
      title: AppLocalizations.of(context)!.setupCourts,
      description: AppLocalizations.of(context)!.courtsDescription(facilities.first.name),
      buttonText: AppLocalizations.of(context)!.setupCourts,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourtsManagementScreen(
              facilityId: facilities.first.id,
              isWalkthrough: true,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayersStep() {
    return _buildStepCard(
      icon: Icons.people,
      title: AppLocalizations.of(context)!.addPlayers,
      description: AppLocalizations.of(context)!.playersDescription,
      buttonText: AppLocalizations.of(context)!.addPlayers,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PlayersManagementScreen(isWalkthrough: true),
          ),
        );
      },
    );
  }

  Widget _buildSessionStep() {
    final facilities = ref.watch(facilitiesProvider);
    final players = ref.watch(enhancedPlayersProvider);
    
    if (facilities.isEmpty || players.length < 2) {
      return const SizedBox();
    }
    
    final facility = facilities.first;
    final courtsAsync = ref.watch(facilityCourtsProvider(facility.id));
    
    return courtsAsync.when(
      data: (courts) => _buildStepCard(
        icon: Icons.play_circle,
        title: AppLocalizations.of(context)!.startYourSession,
        description: AppLocalizations.of(context)!.sessionDescription(
          facility.name,
          players.length,
          courts.length,
          courts.length != 1 ? 's' : ''
        ),
        buttonText: AppLocalizations.of(context)!.startSession,
        onPressed: () => _startSession(facility, courts, players),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(AppLocalizations.of(context)!.errorLoadingCourts)),
    );
  }

  Widget _buildCompletedStep() {
    return _buildStepCard(
      icon: Icons.celebration,
      title: AppLocalizations.of(context)!.allSet,
      description: AppLocalizations.of(context)!.completedDescription,
      buttonText: AppLocalizations.of(context)!.goToLiveView,
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/');
      },
    );
  }

  Widget _buildStepCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  void _startSession(Facility facility, List<Court> courts, List<Player> players) async {
    try {
      final storage = ref.read(enhancedStorageServiceProvider);
      final messageNotifier = ref.read(messageProvider.notifier);
      
      // Validation: Ensure we have players
      if (players.length < 2) {
        messageNotifier.showError(AppLocalizations.of(context)!.needAtLeastTwoPlayers);
        return;
      }
      
      // Create session
      final session = Session(
        facilityId: facility.id,
        sessionDate: DateTime.now(),
        startTime: DateTime.now(),
        courtsAllocated: courts.length,
      );
      
      await storage.saveSession(session);
      
      // Initialize queue with all players
      // This would typically be done through a queue management system
      // For now, we'll just show success
      
      if (mounted) {
        messageNotifier.showSuccess(AppLocalizations.of(context)!.sessionStartedSuccessfully);
        setState(() {
          _currentStep = 4;
        });
      }
    } catch (e) {
      if (mounted) {
        ref.read(messageProvider.notifier).showError(AppLocalizations.of(context)!.errorStartingSession(e.toString()));
      }
    }
  }
}