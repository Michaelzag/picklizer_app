import 'package:flutter/material.dart';
import '../../../models/court.dart';
import '../widgets/progressive_accordion_widget.dart';

/// Courts step for the accordion walkthrough
class AccordionCourtsStep extends AccordionStep {
  final String facilityId;
  final List<Court> existingCourts;
  final List<Court> newCourts;
  final VoidCallback? onChanged;
  final Function(String name, TeamSize teamSize, GameMode gameMode)? onAddCourt;
  final Function(Court court)? onRemoveCourt;

  AccordionCourtsStep({
    required this.facilityId,
    required this.existingCourts,
    required this.newCourts,
    this.onChanged,
    this.onAddCourt,
    this.onRemoveCourt,
  });

  @override
  String get title => 'Setup Courts';

  @override
  String get description => 'Add courts to your facility or review existing ones';

  @override
  Widget buildCurrentContent() {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (existingCourts.isNotEmpty) ...[
          const Text(
            'Existing Courts',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...existingCourts.map((court) => _buildExistingCourtCard(court)),
          const SizedBox(height: 16),
        ],
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'New Courts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddCourtDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add Court'),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        if (newCourts.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Center(
              child: Text(
                'No new courts added yet',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ...newCourts.map((court) => _buildNewCourtCard(court)),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            const Icon(Icons.info_outline, size: 16, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'You need at least 1 court to start a session',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExistingCourtCard(Court court) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.sports_tennis, color: Colors.white, size: 16),
        ),
        title: Text(court.name),
        subtitle: Text('${court.teamSize.displayName} • ${court.gameMode.displayName}'),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }

  Widget _buildNewCourtCard(Court court) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.blue[50],
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.sports_tennis, color: Colors.white, size: 16),
        ),
        title: Text(court.name),
        subtitle: Text('${court.teamSize.displayName} • ${court.gameMode.displayName}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => onRemoveCourt?.call(court),
        ),
      ),
    );
  }

  void _showAddCourtDialog() {
    // This would show a dialog to add a new court
    // For now, we'll add a default court
    onAddCourt?.call(
      'Court ${existingCourts.length + newCourts.length + 1}',
      TeamSize.doubles,
      GameMode.roundRobin,
    );
  }

  @override
  Widget buildCompletedSummary() {
    final totalCourts = existingCourts.length + newCourts.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.sports_tennis, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              '$totalCourts court${totalCourts == 1 ? '' : 's'} configured',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (newCourts.isNotEmpty) ...[
          const Text('New courts added:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...newCourts.map((court) => Padding(
            padding: const EdgeInsets.only(left: 16, top: 2),
            child: Text('• ${court.name}'),
          )),
        ],
        if (existingCourts.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text('${existingCourts.length} existing court${existingCourts.length == 1 ? '' : 's'} available'),
        ],
      ],
    );
  }

  @override
  String getSummaryText() {
    final totalCourts = existingCourts.length + newCourts.length;
    if (totalCourts == 0) return 'No courts configured';
    return '$totalCourts court${totalCourts == 1 ? '' : 's'} ready';
  }

  bool get isValid => existingCourts.isNotEmpty || newCourts.isNotEmpty;
}