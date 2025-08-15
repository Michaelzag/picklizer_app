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

  @override
  String get noLocation => 'ไม่มีตำแหน่ง';

  @override
  String courtCount(int count) {
    return '$count สนาม';
  }

  @override
  String courtsCount(int count) {
    return '$count สนาม';
  }

  @override
  String playerCount(int count) {
    return '$count ผู้เล่น';
  }

  @override
  String playersCount(int count) {
    return '$count ผู้เล่น';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count เพิ่มเติม';
  }

  @override
  String get sessionActive => 'เซสชันใช้งานอยู่';

  @override
  String startedAt(String time) {
    return 'เริ่มเมื่อ $time';
  }

  @override
  String get createYourFacility => 'สร้างสถานที่ของคุณ';

  @override
  String get facilityDescription => 'สถานที่แสดงถึงสถานที่ที่คุณเล่นพิคเคิลบอล';

  @override
  String get setupCourts => 'ตั้งค่าสนาม';

  @override
  String courtsDescription(String facilityName) {
    return 'เพิ่มอย่างน้อยหนึ่งสนามให้กับ $facilityName';
  }

  @override
  String get addPlayers => 'เพิ่มผู้เล่น';

  @override
  String get playersDescription => 'เพิ่มผู้เล่นอย่างน้อย 2 คนเพื่อเริ่มเล่น';

  @override
  String get startYourSession => 'เริ่มเซสชันของคุณ';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return 'พร้อมที่จะเริ่มเล่นที่ $facilityName กับผู้เล่น $playerCount คนและ $courtCount สนาม$courtPlural';
  }

  @override
  String get startSession => 'เริ่มเซสชัน';

  @override
  String get allSet => 'พร้อมแล้ว!';

  @override
  String get completedDescription =>
      'เซสชันของคุณใช้งานอยู่และพร้อมสำหรับการเล่น ผู้เล่นสามารถเข้าร่วมคิวได้แล้ว';

  @override
  String get goToLiveView => 'ไปที่มุมมองสด';

  @override
  String get errorLoadingCourts => 'เกิดข้อผิดพลาดในการโหลดสนาม';

  @override
  String get needAtLeastTwoPlayers =>
      'ต้องมีผู้เล่นอย่างน้อย 2 คนเพื่อเริ่มเซสชัน';

  @override
  String get sessionStartedSuccessfully => 'เริ่มเซสชันสำเร็จ!';

  @override
  String errorStartingSession(String error) {
    return 'เกิดข้อผิดพลาดในการเริ่มเซสชัน: $error';
  }
}
