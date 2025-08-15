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

  @override
  String get noLocation => 'कोई स्थान नहीं';

  @override
  String courtCount(int count) {
    return '$count कोर्ट';
  }

  @override
  String courtsCount(int count) {
    return '$count कोर्ट';
  }

  @override
  String playerCount(int count) {
    return '$count खिलाड़ी';
  }

  @override
  String playersCount(int count) {
    return '$count खिलाड़ी';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count और';
  }

  @override
  String get sessionActive => 'सत्र सक्रिय';

  @override
  String startedAt(String time) {
    return '$time पर शुरू हुआ';
  }

  @override
  String get createYourFacility => 'अपनी सुविधा बनाएं';

  @override
  String get facilityDescription =>
      'एक सुविधा उस स्थान का प्रतिनिधित्व करती है जहाँ आप पिकलबॉल खेलते हैं।';

  @override
  String get setupCourts => 'कोर्ट सेटअप करें';

  @override
  String courtsDescription(String facilityName) {
    return '$facilityName में कम से कम एक कोर्ट जोड़ें।';
  }

  @override
  String get addPlayers => 'खिलाड़ी जोड़ें';

  @override
  String get playersDescription =>
      'खेलना शुरू करने के लिए कम से कम 2 खिलाड़ी जोड़ें।';

  @override
  String get startYourSession => 'अपना सत्र शुरू करें';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return '$facilityName में $playerCount खिलाड़ियों और $courtCount कोर्ट$courtPlural के साथ खेलना शुरू करने के लिए तैयार।';
  }

  @override
  String get startSession => 'सत्र शुरू करें';

  @override
  String get allSet => 'सब तैयार!';

  @override
  String get completedDescription =>
      'आपका सत्र सक्रिय है और खेलने के लिए तैयार है। खिलाड़ी अब कतार में शामिल हो सकते हैं।';

  @override
  String get goToLiveView => 'लाइव व्यू पर जाएं';

  @override
  String get errorLoadingCourts => 'कोर्ट लोड करने में त्रुटि';

  @override
  String get needAtLeastTwoPlayers =>
      'सत्र शुरू करने के लिए कम से कम 2 खिलाड़ियों की आवश्यकता है';

  @override
  String get sessionStartedSuccessfully => 'सत्र सफलतापूर्वक शुरू हुआ!';

  @override
  String errorStartingSession(String error) {
    return 'सत्र शुरू करने में त्रुटि: $error';
  }
}
