// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => '实时视图';

  @override
  String get queue => '队列';

  @override
  String get facilities => '场馆';

  @override
  String get players => '球员';

  @override
  String get sessions => '会话';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get createFacility => '创建场馆';

  @override
  String get addCourt => '添加球场';

  @override
  String get addPlayer => '添加球员';

  @override
  String get createSession => '创建会话';

  @override
  String get facilityName => '场馆名称';

  @override
  String get location => '位置';

  @override
  String get playerName => '球员姓名';

  @override
  String get skillLevel => '技能水平';

  @override
  String get beginner => '初学者';

  @override
  String get intermediate => '中级';

  @override
  String get advanced => '高级';

  @override
  String get singles => '单打';

  @override
  String get doubles => '双打';

  @override
  String get kingOfHill => '山丘之王';

  @override
  String get roundRobin => '循环赛';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get next => '下一步';

  @override
  String get previous => '上一步';

  @override
  String get setupWalkthrough => '设置向导';

  @override
  String stepXOfY(int step, int total) {
    return '第 $step 步，共 $total 步';
  }

  @override
  String get noLocation => '无位置';

  @override
  String courtCount(int count) {
    return '$count 个球场';
  }

  @override
  String courtsCount(int count) {
    return '$count 个球场';
  }

  @override
  String playerCount(int count) {
    return '$count 名球员';
  }

  @override
  String playersCount(int count) {
    return '$count 名球员';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count 更多';
  }

  @override
  String get sessionActive => '会话活跃';

  @override
  String startedAt(String time) {
    return '开始于 $time';
  }

  @override
  String get createYourFacility => '创建您的场馆';

  @override
  String get facilityDescription => '场馆代表您打匹克球的地点。';

  @override
  String get setupCourts => '设置球场';

  @override
  String courtsDescription(String facilityName) {
    return '为 $facilityName 添加至少一个球场。';
  }

  @override
  String get addPlayers => '添加球员';

  @override
  String get playersDescription => '添加至少 2 名球员开始游戏。';

  @override
  String get startYourSession => '开始您的会话';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return '准备在 $facilityName 开始游戏，有 $playerCount 名球员和 $courtCount 个球场$courtPlural。';
  }

  @override
  String get startSession => '开始会话';

  @override
  String get allSet => '全部设置完成！';

  @override
  String get completedDescription => '您的会话已激活并准备游戏。球员现在可以加入队列。';

  @override
  String get goToLiveView => '转到实时视图';

  @override
  String get errorLoadingCourts => '加载球场时出错';

  @override
  String get needAtLeastTwoPlayers => '需要至少 2 名球员才能开始会话';

  @override
  String get sessionStartedSuccessfully => '会话启动成功！';

  @override
  String errorStartingSession(String error) {
    return '启动会话时出错：$error';
  }
}
