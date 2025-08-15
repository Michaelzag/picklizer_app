// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => '라이브 뷰';

  @override
  String get queue => '대기열';

  @override
  String get facilities => '시설';

  @override
  String get players => '플레이어';

  @override
  String get sessions => '세션';

  @override
  String get settings => '설정';

  @override
  String get language => '언어';

  @override
  String get createFacility => '시설 생성';

  @override
  String get addCourt => '코트 추가';

  @override
  String get addPlayer => '플레이어 추가';

  @override
  String get createSession => '세션 생성';

  @override
  String get facilityName => '시설 이름';

  @override
  String get location => '위치';

  @override
  String get playerName => '플레이어 이름';

  @override
  String get skillLevel => '실력 수준';

  @override
  String get beginner => '초급';

  @override
  String get intermediate => '중급';

  @override
  String get advanced => '고급';

  @override
  String get singles => '단식';

  @override
  String get doubles => '복식';

  @override
  String get kingOfHill => '킹 오브 힐';

  @override
  String get roundRobin => '라운드 로빈';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get edit => '편집';

  @override
  String get next => '다음';

  @override
  String get previous => '이전';

  @override
  String get setupWalkthrough => '설정 가이드';

  @override
  String stepXOfY(int step, int total) {
    return '$total 중 $step단계';
  }
}
