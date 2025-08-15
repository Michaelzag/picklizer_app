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
  String get skillLevel => 'مستوى المهارة';

  @override
  String get beginner => 'مبتدئ';

  @override
  String get intermediate => 'متوسط';

  @override
  String get advanced => 'متقدم';

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
}
