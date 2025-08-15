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

  @override
  String get noLocation => 'Kein Standort';

  @override
  String courtCount(int count) {
    return '$count Platz';
  }

  @override
  String courtsCount(int count) {
    return '$count Plätze';
  }

  @override
  String playerCount(int count) {
    return '$count Spieler';
  }

  @override
  String playersCount(int count) {
    return '$count Spieler';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count weitere';
  }

  @override
  String get sessionActive => 'Sitzung Aktiv';

  @override
  String startedAt(String time) {
    return 'Gestartet um $time';
  }

  @override
  String get createYourFacility => 'Erstellen Sie Ihre Einrichtung';

  @override
  String get facilityDescription =>
      'Eine Einrichtung repräsentiert den Ort, an dem Sie Pickleball spielen.';

  @override
  String get setupCourts => 'Plätze Einrichten';

  @override
  String courtsDescription(String facilityName) {
    return 'Fügen Sie mindestens einen Platz zu $facilityName hinzu.';
  }

  @override
  String get addPlayers => 'Spieler Hinzufügen';

  @override
  String get playersDescription =>
      'Fügen Sie mindestens 2 Spieler hinzu, um zu spielen.';

  @override
  String get startYourSession => 'Starten Sie Ihre Sitzung';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return 'Bereit zum Spielen in $facilityName mit $playerCount Spielern und $courtCount Platz$courtPlural.';
  }

  @override
  String get startSession => 'Sitzung Starten';

  @override
  String get allSet => 'Alles Bereit!';

  @override
  String get completedDescription =>
      'Ihre Sitzung ist aktiv und bereit zum Spielen. Spieler können jetzt der Warteschlange beitreten.';

  @override
  String get goToLiveView => 'Zur Live-Ansicht';

  @override
  String get errorLoadingCourts => 'Fehler beim Laden der Plätze';

  @override
  String get needAtLeastTwoPlayers =>
      'Mindestens 2 Spieler erforderlich, um eine Sitzung zu starten';

  @override
  String get sessionStartedSuccessfully => 'Sitzung erfolgreich gestartet!';

  @override
  String errorStartingSession(String error) {
    return 'Fehler beim Starten der Sitzung: $error';
  }
}
