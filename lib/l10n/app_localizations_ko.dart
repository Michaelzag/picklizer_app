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

  @override
  String get noLocation => '위치 없음';

  @override
  String courtCount(int count) {
    return '$count개 코트';
  }

  @override
  String courtsCount(int count) {
    return '$count개 코트';
  }

  @override
  String playerCount(int count) {
    return '$count명 플레이어';
  }

  @override
  String playersCount(int count) {
    return '$count명 플레이어';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count명 더';
  }

  @override
  String get sessionActive => '세션 활성';

  @override
  String startedAt(String time) {
    return '$time에 시작됨';
  }

  @override
  String get createYourFacility => '시설 만들기';

  @override
  String get facilityDescription => '시설은 피클볼을 플레이하는 장소를 나타냅니다.';

  @override
  String get setupCourts => '코트 설정';

  @override
  String courtsDescription(String facilityName) {
    return '$facilityName에 최소 하나의 코트를 추가하세요.';
  }

  @override
  String get addPlayers => '플레이어 추가';

  @override
  String get playersDescription => '플레이를 시작하려면 최소 2명의 플레이어를 추가하세요.';

  @override
  String get startYourSession => '세션 시작';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return '$facilityName에서 $playerCount명의 플레이어와 $courtCount개의 코트$courtPlural로 플레이할 준비가 되었습니다.';
  }

  @override
  String get startSession => '세션 시작';

  @override
  String get allSet => '모든 준비 완료!';

  @override
  String get completedDescription =>
      '세션이 활성화되어 플레이할 준비가 되었습니다. 플레이어들이 이제 대기열에 참여할 수 있습니다.';

  @override
  String get goToLiveView => '라이브 뷰로 이동';

  @override
  String get errorLoadingCourts => '코트 로딩 오류';

  @override
  String get needAtLeastTwoPlayers => '세션을 시작하려면 최소 2명의 플레이어가 필요합니다';

  @override
  String get sessionStartedSuccessfully => '세션이 성공적으로 시작되었습니다!';

  @override
  String errorStartingSession(String error) {
    return '세션 시작 오류: $error';
  }
}
