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
  String get skillLevel => 'Antas ng Kasanayan';

  @override
  String get beginner => 'Nagsisimula';

  @override
  String get intermediate => 'Katamtaman';

  @override
  String get advanced => 'Eksperto';

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
}
