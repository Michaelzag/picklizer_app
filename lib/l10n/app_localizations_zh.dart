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
}
