import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/court.dart';
import '../providers/enhanced_providers.dart';
import '../providers/message_provider.dart';

class CourtSetupScreen extends ConsumerStatefulWidget {
  final String facilityId;
  final Court? court; // For editing existing court

  const CourtSetupScreen({
    super.key,
    required this.facilityId,
    this.court,
  });

  @override
  ConsumerState<CourtSetupScreen> createState() => _CourtSetupScreenState();
}

class _CourtSetupScreenState extends ConsumerState<CourtSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  TeamSize _selectedTeamSize = TeamSize.singles;
  GameMode _selectedGameMode = GameMode.roundRobin;
  int _targetScore = 11;

  bool get isEditing => widget.court != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final court = widget.court!;
      _nameController.text = court.name;
      _selectedTeamSize = court.teamSize;
      _selectedGameMode = court.gameMode;
      _targetScore = court.targetScore;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Court' : 'Add Court'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Court Name',
                  hintText: 'e.g., Court 1',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a court name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              Text(
                'Team Size',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<TeamSize>(
                segments: const [
                  ButtonSegment(
                    value: TeamSize.singles,
                    label: Text('Singles'),
                    icon: Icon(Icons.person),
                  ),
                  ButtonSegment(
                    value: TeamSize.doubles,
                    label: Text('Doubles'),
                    icon: Icon(Icons.people),
                  ),
                ],
                selected: {_selectedTeamSize},
                onSelectionChanged: (Set<TeamSize> newSelection) {
                  setState(() {
                    _selectedTeamSize = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              Text(
                'Game Mode',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<GameMode>(
                segments: const [
                  ButtonSegment(
                    value: GameMode.kingOfHill,
                    label: Text('King of Hill'),
                    tooltip: 'Winners stay, losers rotate',
                  ),
                  ButtonSegment(
                    value: GameMode.roundRobin,
                    label: Text('Round Robin'),
                    tooltip: 'Everyone rotates',
                  ),
                ],
                selected: {_selectedGameMode},
                onSelectionChanged: (Set<GameMode> newSelection) {
                  setState(() {
                    _selectedGameMode = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              // Scoring Configuration
              Text(
                'Scoring',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _targetScore,
                decoration: const InputDecoration(
                  labelText: 'Target Score',
                ),
                items: [7, 11, 15, 21].map((score) {
                  return DropdownMenuItem(
                    value: score,
                    child: Text('$score points'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _targetScore = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Info cards
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedTeamSize == TeamSize.singles
                                ? 'Singles: 1v1 (2 players per match)'
                                : 'Doubles: 2v2 (4 players per match)',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedGameMode == GameMode.kingOfHill
                            ? 'King of the Hill: Winners stay on court, losers go to the back of the queue'
                            : 'Round Robin: All players rotate off court after each match',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Games played to $_targetScore points (win by 2 is standard pickleball rule)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              
              ElevatedButton(
                onPressed: _saveCourt,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(isEditing ? 'Save Changes' : 'Add Court'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCourt() async {
    if (_formKey.currentState!.validate()) {
      try {
        final storage = ref.read(enhancedStorageServiceProvider);
        final messageNotifier = ref.read(messageProvider.notifier);
        final courtName = _nameController.text.trim();
        
        // Check for duplicate court names within the same facility
        final existingCourts = await storage.getCourtsByFacility(widget.facilityId);
        final duplicateExists = existingCourts.any((court) =>
          court.name.toLowerCase() == courtName.toLowerCase() &&
          (!isEditing || court.id != widget.court!.id)
        );
        
        if (duplicateExists) {
          if (mounted) {
            messageNotifier.showError('A court named "$courtName" already exists in this facility');
          }
          return;
        }
        
        if (isEditing) {
          // Update existing court
          final updatedCourt = widget.court!.copyWith(
            name: courtName,
            teamSize: _selectedTeamSize,
            gameMode: _selectedGameMode,
            targetScore: _targetScore,
          );
          await storage.updateCourt(updatedCourt);
          
          if (mounted) {
            messageNotifier.showSuccess('Court "$courtName" updated successfully!');
            Navigator.pop(context);
          }
        } else {
          // Create new court
          final court = Court(
            facilityId: widget.facilityId,
            name: courtName,
            teamSize: _selectedTeamSize,
            gameMode: _selectedGameMode,
            targetScore: _targetScore,
          );
          await storage.saveCourt(court);
          
          if (mounted) {
            messageNotifier.showSuccess('Court "$courtName" added successfully!');
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ref.read(messageProvider.notifier).showError('Error saving court: ${e.toString()}');
        }
      }
    }
  }
}