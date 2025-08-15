import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/court.dart';
import '../../models/match.dart';

class CourtCard extends StatelessWidget {
  final Court court;
  final Match? activeMatch;
  final VoidCallback? onTap;
  final VoidCallback? onStartMatch;
  final VoidCallback? onEndMatch;
  final bool canStartMatch;

  const CourtCard({
    super.key,
    required this.court,
    this.activeMatch,
    this.onTap,
    this.onStartMatch,
    this.onEndMatch,
    this.canStartMatch = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getBackgroundColor(colorScheme),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getBorderColor(colorScheme),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            if (court.matchInProgress && activeMatch != null)
              _buildMatchInfo(context, activeMatch!)
            else if (court.isAvailable)
              _buildAvailableIndicator(context),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1, 1),
            duration: 300.ms,
            curve: Curves.easeOut,
          ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getHeaderColor(colorScheme),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.sports_tennis,
                color: _getIconColor(colorScheme),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                court.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getTextColor(colorScheme),
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildModeChip(context),
              const SizedBox(width: 8),
              _buildStatusChip(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeChip(BuildContext context) {
    final theme = Theme.of(context);
    final modeText = court.teamSize == TeamSize.singles ? 'Singles' : 'Doubles';
    final gameMode = court.gameMode == GameMode.kingOfHill ? 'KOTH' : 'RR';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$modeText • $gameMode',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final theme = Theme.of(context);
    String label;
    Color backgroundColor;
    Color textColor;

    if (court.isOccupied) {
      label = 'In Play';
      backgroundColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
    } else {
      label = 'Available';
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMatchInfo(BuildContext context, Match match) {
    final theme = Theme.of(context);
    final duration = DateTime.now().difference(match.startTime);
    final minutes = duration.inMinutes;
    final durationText = minutes < 60 ? '${minutes}m' : '${minutes ~/ 60}h ${minutes % 60}m';

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Score',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${match.team1Score}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: match.team1Score > match.team2Score
                      ? theme.colorScheme.primary
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '-',
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              Text(
                '${match.team2Score}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: match.team2Score > match.team1Score
                      ? theme.colorScheme.primary
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Duration: $durationText',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          if (onEndMatch != null)
            ElevatedButton.icon(
              onPressed: onEndMatch,
              icon: const Icon(Icons.stop),
              label: const Text('End Match'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvailableIndicator(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green.shade600,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'Ready for Play',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (canStartMatch && onStartMatch != null) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onStartMatch,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Match'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: 2.seconds,
      color: Colors.green.shade100,
    );
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (court.isOccupied) {
      return Colors.orange.shade50;
    } else {
      return Colors.green.shade50;
    }
  }

  Color _getHeaderColor(ColorScheme colorScheme) {
    if (court.isOccupied) {
      return Colors.orange.shade100;
    } else {
      return Colors.green.shade100;
    }
  }

  Color _getBorderColor(ColorScheme colorScheme) {
    if (court.isOccupied) {
      return Colors.orange.shade300;
    } else {
      return Colors.green.shade400;
    }
  }

  Color _getIconColor(ColorScheme colorScheme) {
    if (court.isOccupied) {
      return Colors.orange.shade700;
    } else {
      return Colors.green.shade700;
    }
  }

  Color _getTextColor(ColorScheme colorScheme) {
    if (court.isOccupied) {
      return Colors.orange.shade900;
    } else {
      return Colors.green.shade900;
    }
  }
}