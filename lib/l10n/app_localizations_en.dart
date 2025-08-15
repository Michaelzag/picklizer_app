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
}
