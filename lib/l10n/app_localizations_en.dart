// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'Live View';

  @override
  String get queue => 'Queue';

  @override
  String get facilities => 'Facilities';

  @override
  String get players => 'Players';

  @override
  String get sessions => 'Sessions';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get createFacility => 'Create Facility';

  @override
  String get addCourt => 'Add Court';

  @override
  String get addPlayer => 'Add Player';

  @override
  String get createSession => 'Create Session';

  @override
  String get facilityName => 'Facility Name';

  @override
  String get location => 'Location';

  @override
  String get playerName => 'Player Name';

  @override
  String get skillLevel => 'Skill Level';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get singles => 'Singles';

  @override
  String get doubles => 'Doubles';

  @override
  String get kingOfHill => 'King of Hill';

  @override
  String get roundRobin => 'Round Robin';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get setupWalkthrough => 'Setup Walkthrough';

  @override
  String stepXOfY(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get noLocation => 'No location';

  @override
  String courtCount(int count) {
    return '$count Court';
  }

  @override
  String courtsCount(int count) {
    return '$count Courts';
  }

  @override
  String playerCount(int count) {
    return '$count Player';
  }

  @override
  String playersCount(int count) {
    return '$count Players';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count more';
  }

  @override
  String get sessionActive => 'Session Active';

  @override
  String startedAt(String time) {
    return 'Started at $time';
  }

  @override
  String get createYourFacility => 'Create Your Facility';

  @override
  String get facilityDescription =>
      'A facility represents the location where you play pickleball.';

  @override
  String get setupCourts => 'Setup Courts';

  @override
  String courtsDescription(String facilityName) {
    return 'Add at least one court to $facilityName.';
  }

  @override
  String get addPlayers => 'Add Players';

  @override
  String get playersDescription => 'Add at least 2 players to start playing.';

  @override
  String get startYourSession => 'Start Your Session';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return 'Ready to start playing at $facilityName with $playerCount players and $courtCount court$courtPlural.';
  }

  @override
  String get startSession => 'Start Session';

  @override
  String get allSet => 'All Set!';

  @override
  String get completedDescription =>
      'Your session is active and ready for play. Players can now join the queue.';

  @override
  String get goToLiveView => 'Go to Live View';

  @override
  String get errorLoadingCourts => 'Error loading courts';

  @override
  String get needAtLeastTwoPlayers =>
      'Need at least 2 players to start a session';

  @override
  String get sessionStartedSuccessfully => 'Session started successfully!';

  @override
  String errorStartingSession(String error) {
    return 'Error starting session: $error';
  }
}
