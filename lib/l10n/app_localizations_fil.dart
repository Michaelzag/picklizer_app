// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'Live na Tingin';

  @override
  String get queue => 'Pila';

  @override
  String get facilities => 'Mga Pasilidad';

  @override
  String get players => 'Mga Manlalaro';

  @override
  String get sessions => 'Mga Sesyon';

  @override
  String get settings => 'Mga Setting';

  @override
  String get language => 'Wika';

  @override
  String get createFacility => 'Gumawa ng Pasilidad';

  @override
  String get addCourt => 'Magdagdag ng Court';

  @override
  String get addPlayer => 'Magdagdag ng Manlalaro';

  @override
  String get createSession => 'Gumawa ng Sesyon';

  @override
  String get facilityName => 'Pangalan ng Pasilidad';

  @override
  String get location => 'Lokasyon';

  @override
  String get playerName => 'Pangalan ng Manlalaro';

  @override
  String get singles => 'Singles';

  @override
  String get doubles => 'Doubles';

  @override
  String get kingOfHill => 'Hari ng Burol';

  @override
  String get roundRobin => 'Round Robin';

  @override
  String get save => 'I-save';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get delete => 'Tanggalin';

  @override
  String get edit => 'I-edit';

  @override
  String get next => 'Susunod';

  @override
  String get previous => 'Nakaraan';

  @override
  String get setupWalkthrough => 'Gabay sa Pag-setup';

  @override
  String stepXOfY(int step, int total) {
    return 'Hakbang $step ng $total';
  }

  @override
  String get noLocation => 'Walang lokasyon';

  @override
  String courtCount(int count) {
    return '$count Court';
  }

  @override
  String courtsCount(int count) {
    return '$count mga Court';
  }

  @override
  String playerCount(int count) {
    return '$count Manlalaro';
  }

  @override
  String playersCount(int count) {
    return '$count mga Manlalaro';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count pa';
  }

  @override
  String get sessionActive => 'Aktibong Sesyon';

  @override
  String startedAt(String time) {
    return 'Nagsimula sa $time';
  }

  @override
  String get createYourFacility => 'Gumawa ng Inyong Pasilidad';

  @override
  String get facilityDescription =>
      'Ang pasilidad ay kumakatawan sa lugar kung saan kayo naglalaro ng pickleball.';

  @override
  String get setupCourts => 'I-setup ang mga Court';

  @override
  String courtsDescription(String facilityName) {
    return 'Magdagdag ng hindi bababa sa isang court sa $facilityName.';
  }

  @override
  String get addPlayers => 'Magdagdag ng mga Manlalaro';

  @override
  String get playersDescription =>
      'Magdagdag ng hindi bababa sa 2 manlalaro para magsimula ng laro.';

  @override
  String get startYourSession => 'Simulan ang Inyong Sesyon';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return 'Handa na para magsimula ng laro sa $facilityName na may $playerCount manlalaro at $courtCount court$courtPlural.';
  }

  @override
  String get startSession => 'Simulan ang Sesyon';

  @override
  String get allSet => 'Handa na Lahat!';

  @override
  String get completedDescription =>
      'Ang inyong sesyon ay aktibo na at handa para sa laro. Maaari na ngayong sumali ang mga manlalaro sa pila.';

  @override
  String get goToLiveView => 'Pumunta sa Live na Tingin';

  @override
  String get errorLoadingCourts => 'May error sa pag-load ng mga court';

  @override
  String get needAtLeastTwoPlayers =>
      'Kailangan ng hindi bababa sa 2 manlalaro para magsimula ng sesyon';

  @override
  String get sessionStartedSuccessfully =>
      'Matagumpay na nagsimula ang sesyon!';

  @override
  String errorStartingSession(String error) {
    return 'May error sa pagsisimula ng sesyon: $error';
  }

  @override
  String get getStarted => 'Get Started';

  @override
  String get getStartedTooltip => 'Start setup walkthrough';
}
