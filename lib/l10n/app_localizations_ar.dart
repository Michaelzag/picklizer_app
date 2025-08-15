// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'العرض المباشر';

  @override
  String get queue => 'الطابور';

  @override
  String get facilities => 'المرافق';

  @override
  String get players => 'اللاعبون';

  @override
  String get sessions => 'الجلسات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get createFacility => 'إنشاء مرفق';

  @override
  String get addCourt => 'إضافة ملعب';

  @override
  String get addPlayer => 'إضافة لاعب';

  @override
  String get createSession => 'إنشاء جلسة';

  @override
  String get facilityName => 'اسم المرفق';

  @override
  String get location => 'الموقع';

  @override
  String get playerName => 'اسم اللاعب';

  @override
  String get singles => 'فردي';

  @override
  String get doubles => 'زوجي';

  @override
  String get kingOfHill => 'ملك التل';

  @override
  String get roundRobin => 'الدوري الدائري';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get next => 'التالي';

  @override
  String get previous => 'السابق';

  @override
  String get setupWalkthrough => 'دليل الإعداد';

  @override
  String stepXOfY(int step, int total) {
    return 'الخطوة $step من $total';
  }

  @override
  String get noLocation => 'لا يوجد موقع';

  @override
  String courtCount(int count) {
    return '$count ملعب';
  }

  @override
  String courtsCount(int count) {
    return '$count ملاعب';
  }

  @override
  String playerCount(int count) {
    return '$count لاعب';
  }

  @override
  String playersCount(int count) {
    return '$count لاعبين';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count آخرين';
  }

  @override
  String get sessionActive => 'الجلسة نشطة';

  @override
  String startedAt(String time) {
    return 'بدأت في $time';
  }

  @override
  String get createYourFacility => 'أنشئ مرفقك';

  @override
  String get facilityDescription =>
      'المرفق يمثل المكان الذي تلعب فيه البيكل بول.';

  @override
  String get setupCourts => 'إعداد الملاعب';

  @override
  String courtsDescription(String facilityName) {
    return 'أضف ملعباً واحداً على الأقل إلى $facilityName.';
  }

  @override
  String get addPlayers => 'إضافة اللاعبين';

  @override
  String get playersDescription => 'أضف لاعبين على الأقل لبدء اللعب.';

  @override
  String get startYourSession => 'ابدأ جلستك';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return 'جاهز لبدء اللعب في $facilityName مع $playerCount لاعبين و $courtCount ملعب$courtPlural.';
  }

  @override
  String get startSession => 'بدء الجلسة';

  @override
  String get allSet => 'كل شيء جاهز!';

  @override
  String get completedDescription =>
      'جلستك نشطة وجاهزة للعب. يمكن للاعبين الآن الانضمام إلى الطابور.';

  @override
  String get goToLiveView => 'الذهاب إلى العرض المباشر';

  @override
  String get errorLoadingCourts => 'خطأ في تحميل الملاعب';

  @override
  String get needAtLeastTwoPlayers => 'يحتاج إلى لاعبين على الأقل لبدء الجلسة';

  @override
  String get sessionStartedSuccessfully => 'تم بدء الجلسة بنجاح!';

  @override
  String errorStartingSession(String error) {
    return 'خطأ في بدء الجلسة: $error';
  }

  @override
  String get getStarted => 'Get Started';

  @override
  String get getStartedTooltip => 'Start setup walkthrough';
}
