import 'package:flutter/material.dart';
import '../../../models/facility.dart';
import '../../../models/court.dart';
import '../../../models/player.dart';
import '../widgets/progressive_accordion_widget.dart';

/// Session start step for the accordion walkthrough
class AccordionSessionStep extends AccordionStep {
  final Facility facility;
  final List<Court> courts;
  final List<Player> selectedPlayers;
  final VoidCallback? onStartSession;

  AccordionSessionStep({
    required this.facility,
    required this.courts,
    required this.selectedPlayers,
    this.onStartSession,
  });

  @override
  String get title => 'Start Session';

  @override
  String get description => 'Review everything and start your session';

  @override
  Widget buildCurrentContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Session Summary',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        // Facility summary
        _buildSummaryCard(
          icon: Icons.business,
          title: 'Facility',
          content: [
            facility.name,
            if (facility.location != null) facility.location!,
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Courts summary
        _buildSummaryCard(
          icon: Icons.sports_tennis,
          title: 'Courts',
          content: courts.map((court) => 
            '${court.name} • ${court.teamSize.displayName} • ${court.gameMode.displayName}'
          ).toList(),
        ),
        
        const SizedBox(height: 12),
        
        // Players summary
        _buildSummaryCard(
          icon: Icons.people,
          title: 'Players',
          content: selectedPlayers.map((player) => player.name).toList(),
        ),
        
        const SizedBox(height: 24),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green),
          ),
          child: Column(
            children: [
              const Icon(Icons.play_circle, color: Colors.green, size: 48),
              const SizedBox(height: 8),
              const Text(
                'Ready to Start!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap "Start Session" to begin playing',
                style: TextStyle(color: Colors.green[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required List<String> content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...content.map((item) => Padding(
              padding: const EdgeInsets.only(left: 32, bottom: 2),
              child: Text('• $item'),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildCompletedSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.play_circle, color: Colors.green),
            const SizedBox(width: 8),
            const Text(
              'Session Started!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('${facility.name} • ${courts.length} courts • ${selectedPlayers.length} players'),
      ],
    );
  }

  @override
  String getSummaryText() {
    return 'Session ready to start';
  }

  bool get isValid => courts.isNotEmpty && selectedPlayers.length >= 2;
}