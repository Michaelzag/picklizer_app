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
  String get skillLevel => 'スキルレベル';

  @override
  String get beginner => '初心者';

  @override
  String get intermediate => '中級者';

  @override
  String get advanced => '上級者';

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
}
