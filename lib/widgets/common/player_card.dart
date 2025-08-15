import 'package:flutter/material.dart';
import '../../models/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool isInQueue;
  final int? queuePosition;

  const PlayerCard({
    super.key,
    required this.player,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onRemove,
    this.isInQueue = false,
    this.queuePosition,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: isInQueue ? 2 : 1,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: isInQueue
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
          child: Text(
            player.name.isNotEmpty ? player.name[0].toUpperCase() : 'P',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          player.name,
          style: TextStyle(
            fontWeight: isInQueue ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: subtitle != null 
            ? Text(subtitle!)
            : player.gamesPlayed > 0
                ? Text('Games: ${player.gamesPlayed} | Wins: ${player.wins}')
                : null,
        trailing: trailing ?? (queuePosition != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '#$queuePosition',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : onRemove != null
                ? IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: onRemove,
                    color: Colors.red,
                  )
                : null),
      ),
    );
  }
}

class SimplePlayerTile extends StatelessWidget {
  final String name;
  final bool isHighlighted;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SimplePlayerTile({
    super.key,
    required this.name,
    this.isHighlighted = false,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ListTile(
      onTap: onTap,
      tileColor: isHighlighted ? theme.colorScheme.primaryContainer : null,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondary,
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'P',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: trailing,
    );
  }
}