import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Pickleizer';
  static const String appVersion = '1.0.0';

  // Game Modes
  static const String kingOfHill = 'king_of_hill';
  static const String roundRobin = 'round_robin';

  // Team Sizes
  static const String singles = 'singles';
  static const String doubles = 'doubles';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Cache Keys for SharedPreferences
  static const String cacheKeyDefaultTeamSize = 'default_team_size';
  static const String cacheKeyDefaultGameMode = 'default_game_mode';
  static const String cacheKeyLastSessionDate = 'last_session_date';
  static const String cacheKeySoundEnabled = 'sound_enabled';
  static const String cacheKeyThemeMode = 'theme_mode';

  // Validation
  static const int minPlayerNameLength = 2;
  static const int maxPlayerNameLength = 30;

  // UI Constants
  static const double bottomNavHeight = 60.0;
  static const double fabSize = 56.0;
  static const double minTapTarget = 48.0;
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);

  // Match Settings
  static const int defaultWinningScore = 11;
  static const int winByMargin = 2;
  static const int typicalMatchDurationMinutes = 20;

  // Queue Settings
  static const int minPlayersForMatch = 2; // Singles
  static const int maxPlayersForMatch = 4; // Doubles

  // History Settings
  static const int historyRetentionDays = 30;
}