import 'player.dart';

class RotationResult {
  final List<Player> team1;
  final List<Player> team2;
  final List<Player> updatedQueue;

  RotationResult({
    required this.team1,
    required this.team2,
    required this.updatedQueue,
  });

  bool get isValid =>
      team1.isNotEmpty &&
      team2.isNotEmpty &&
      team1.length == team2.length;

  int get totalPlayers => team1.length + team2.length;
}