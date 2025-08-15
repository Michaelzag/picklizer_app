// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'Xem Trực Tiếp';

  @override
  String get queue => 'Hàng Đợi';

  @override
  String get facilities => 'Cơ Sở';

  @override
  String get players => 'Người Chơi';

  @override
  String get sessions => 'Phiên';

  @override
  String get settings => 'Cài Đặt';

  @override
  String get language => 'Ngôn Ngữ';

  @override
  String get createFacility => 'Tạo Cơ Sở';

  @override
  String get addCourt => 'Thêm Sân';

  @override
  String get addPlayer => 'Thêm Người Chơi';

  @override
  String get createSession => 'Tạo Phiên';

  @override
  String get facilityName => 'Tên Cơ Sở';

  @override
  String get location => 'Vị Trí';

  @override
  String get playerName => 'Tên Người Chơi';

  @override
  String get skillLevel => 'Trình Độ';

  @override
  String get beginner => 'Mới Bắt Đầu';

  @override
  String get intermediate => 'Trung Bình';

  @override
  String get advanced => 'Nâng Cao';

  @override
  String get singles => 'Đơn';

  @override
  String get doubles => 'Đôi';

  @override
  String get kingOfHill => 'Vua Đồi';

  @override
  String get roundRobin => 'Vòng Tròn';

  @override
  String get save => 'Lưu';

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get edit => 'Chỉnh Sửa';

  @override
  String get next => 'Tiếp Theo';

  @override
  String get previous => 'Trước';

  @override
  String get setupWalkthrough => 'Hướng Dẫn Thiết Lập';

  @override
  String stepXOfY(int step, int total) {
    return 'Bước $step của $total';
  }
}
