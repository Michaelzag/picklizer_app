// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'Live-Ansicht';

  @override
  String get queue => 'Warteschlange';

  @override
  String get facilities => 'Einrichtungen';

  @override
  String get players => 'Spieler';

  @override
  String get sessions => 'Sitzungen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get createFacility => 'Einrichtung Erstellen';

  @override
  String get addCourt => 'Platz Hinzufügen';

  @override
  String get addPlayer => 'Spieler Hinzufügen';

  @override
  String get createSession => 'Sitzung Erstellen';

  @override
  String get facilityName => 'Einrichtungsname';

  @override
  String get location => 'Standort';

  @override
  String get playerName => 'Spielername';

  @override
  String get skillLevel => 'Fähigkeitsstufe';

  @override
  String get beginner => 'Anfänger';

  @override
  String get intermediate => 'Fortgeschritten';

  @override
  String get advanced => 'Experte';

  @override
  String get singles => 'Einzel';

  @override
  String get doubles => 'Doppel';

  @override
  String get kingOfHill => 'König des Hügels';

  @override
  String get roundRobin => 'Jeder gegen Jeden';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get next => 'Weiter';

  @override
  String get previous => 'Zurück';

  @override
  String get setupWalkthrough => 'Einrichtungsanleitung';

  @override
  String stepXOfY(int step, int total) {
    return 'Schritt $step von $total';
  }
}
