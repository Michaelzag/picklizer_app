// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'लाइव व्यू';

  @override
  String get queue => 'कतार';

  @override
  String get facilities => 'सुविधाएं';

  @override
  String get players => 'खिलाड़ी';

  @override
  String get sessions => 'सत्र';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get createFacility => 'सुविधा बनाएं';

  @override
  String get addCourt => 'कोर्ट जोड़ें';

  @override
  String get addPlayer => 'खिलाड़ी जोड़ें';

  @override
  String get createSession => 'सत्र बनाएं';

  @override
  String get facilityName => 'सुविधा का नाम';

  @override
  String get location => 'स्थान';

  @override
  String get playerName => 'खिलाड़ी का नाम';

  @override
  String get skillLevel => 'कौशल स्तर';

  @override
  String get beginner => 'शुरुआती';

  @override
  String get intermediate => 'मध्यम';

  @override
  String get advanced => 'उन्नत';

  @override
  String get singles => 'एकल';

  @override
  String get doubles => 'युगल';

  @override
  String get kingOfHill => 'पहाड़ी का राजा';

  @override
  String get roundRobin => 'राउंड रॉबिन';

  @override
  String get save => 'सेव करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get next => 'अगला';

  @override
  String get previous => 'पिछला';

  @override
  String get setupWalkthrough => 'सेटअप गाइड';

  @override
  String stepXOfY(int step, int total) {
    return 'चरण $step का $total';
  }
}
