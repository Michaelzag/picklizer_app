// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'ดูสด';

  @override
  String get queue => 'คิว';

  @override
  String get facilities => 'สิ่งอำนวยความสะดวก';

  @override
  String get players => 'ผู้เล่น';

  @override
  String get sessions => 'เซสชัน';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get language => 'ภาษา';

  @override
  String get createFacility => 'สร้างสถานที่';

  @override
  String get addCourt => 'เพิ่มสนาม';

  @override
  String get addPlayer => 'เพิ่มผู้เล่น';

  @override
  String get createSession => 'สร้างเซสชัน';

  @override
  String get facilityName => 'ชื่อสถานที่';

  @override
  String get location => 'ตำแหน่ง';

  @override
  String get playerName => 'ชื่อผู้เล่น';

  @override
  String get skillLevel => 'ระดับทักษะ';

  @override
  String get beginner => 'เริ่มต้น';

  @override
  String get intermediate => 'ปานกลาง';

  @override
  String get advanced => 'ขั้นสูง';

  @override
  String get singles => 'เดี่ยว';

  @override
  String get doubles => 'คู่';

  @override
  String get kingOfHill => 'ราชาแห่งเนิน';

  @override
  String get roundRobin => 'รอบโรบิน';

  @override
  String get save => 'บันทึก';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get delete => 'ลบ';

  @override
  String get edit => 'แก้ไข';

  @override
  String get next => 'ถัดไป';

  @override
  String get previous => 'ก่อนหน้า';

  @override
  String get setupWalkthrough => 'คู่มือการตั้งค่า';

  @override
  String stepXOfY(int step, int total) {
    return 'ขั้นตอน $step จาก $total';
  }
}
