// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'ライブビュー';

  @override
  String get queue => 'キュー';

  @override
  String get facilities => '施設';

  @override
  String get players => 'プレイヤー';

  @override
  String get sessions => 'セッション';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get createFacility => '施設を作成';

  @override
  String get addCourt => 'コートを追加';

  @override
  String get addPlayer => 'プレイヤーを追加';

  @override
  String get createSession => 'セッションを作成';

  @override
  String get facilityName => '施設名';

  @override
  String get location => '場所';

  @override
  String get playerName => 'プレイヤー名';

  @override
  String get singles => 'シングルス';

  @override
  String get doubles => 'ダブルス';

  @override
  String get kingOfHill => 'キングオブヒル';

  @override
  String get roundRobin => 'ラウンドロビン';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get next => '次へ';

  @override
  String get previous => '前へ';

  @override
  String get setupWalkthrough => 'セットアップガイド';

  @override
  String stepXOfY(int step, int total) {
    return 'ステップ $step / $total';
  }

  @override
  String get noLocation => '場所なし';

  @override
  String courtCount(int count) {
    return '$countコート';
  }

  @override
  String courtsCount(int count) {
    return '$countコート';
  }

  @override
  String playerCount(int count) {
    return '$countプレイヤー';
  }

  @override
  String playersCount(int count) {
    return '$countプレイヤー';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count人';
  }

  @override
  String get sessionActive => 'セッション実行中';

  @override
  String startedAt(String time) {
    return '$timeに開始';
  }

  @override
  String get createYourFacility => '施設を作成してください';

  @override
  String get facilityDescription => '施設はピックルボールをプレイする場所を表します。';

  @override
  String get setupCourts => 'コートをセットアップ';

  @override
  String courtsDescription(String facilityName) {
    return '$facilityNameに少なくとも1つのコートを追加してください。';
  }

  @override
  String get addPlayers => 'プレイヤーを追加';

  @override
  String get playersDescription => 'プレイを開始するために少なくとも2人のプレイヤーを追加してください。';

  @override
  String get startYourSession => 'セッションを開始';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return '$facilityNameで$playerCount人のプレイヤーと$courtCountコート$courtPluralでプレイを開始する準備ができました。';
  }

  @override
  String get startSession => 'セッション開始';

  @override
  String get allSet => '準備完了！';

  @override
  String get completedDescription =>
      'セッションがアクティブになり、プレイの準備ができました。プレイヤーはキューに参加できます。';

  @override
  String get goToLiveView => 'ライブビューに移動';

  @override
  String get errorLoadingCourts => 'コートの読み込みエラー';

  @override
  String get needAtLeastTwoPlayers => 'セッションを開始するには少なくとも2人のプレイヤーが必要です';

  @override
  String get sessionStartedSuccessfully => 'セッションが正常に開始されました！';

  @override
  String errorStartingSession(String error) {
    return 'セッション開始エラー: $error';
  }

  @override
  String get getStarted => 'Get Started';

  @override
  String get getStartedTooltip => 'Start setup walkthrough';
}
