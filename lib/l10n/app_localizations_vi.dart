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

  @override
  String get noLocation => 'Không có vị trí';

  @override
  String courtCount(int count) {
    return '$count Sân';
  }

  @override
  String courtsCount(int count) {
    return '$count Sân';
  }

  @override
  String playerCount(int count) {
    return '$count Người Chơi';
  }

  @override
  String playersCount(int count) {
    return '$count Người Chơi';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count thêm';
  }

  @override
  String get sessionActive => 'Phiên Đang Hoạt Động';

  @override
  String startedAt(String time) {
    return 'Bắt đầu lúc $time';
  }

  @override
  String get createYourFacility => 'Tạo Cơ Sở Của Bạn';

  @override
  String get facilityDescription =>
      'Cơ sở đại diện cho nơi bạn chơi pickleball.';

  @override
  String get setupCourts => 'Thiết Lập Sân';

  @override
  String courtsDescription(String facilityName) {
    return 'Thêm ít nhất một sân vào $facilityName.';
  }

  @override
  String get addPlayers => 'Thêm Người Chơi';

  @override
  String get playersDescription => 'Thêm ít nhất 2 người chơi để bắt đầu chơi.';

  @override
  String get startYourSession => 'Bắt Đầu Phiên Của Bạn';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return 'Sẵn sàng bắt đầu chơi tại $facilityName với $playerCount người chơi và $courtCount sân$courtPlural.';
  }

  @override
  String get startSession => 'Bắt Đầu Phiên';

  @override
  String get allSet => 'Đã Sẵn Sàng!';

  @override
  String get completedDescription =>
      'Phiên của bạn đang hoạt động và sẵn sàng để chơi. Người chơi giờ có thể tham gia hàng đợi.';

  @override
  String get goToLiveView => 'Đi Đến Xem Trực Tiếp';

  @override
  String get errorLoadingCourts => 'Lỗi tải sân';

  @override
  String get needAtLeastTwoPlayers =>
      'Cần ít nhất 2 người chơi để bắt đầu phiên';

  @override
  String get sessionStartedSuccessfully => 'Phiên đã bắt đầu thành công!';

  @override
  String errorStartingSession(String error) {
    return 'Lỗi bắt đầu phiên: $error';
  }

  @override
  String get getStarted => 'Get Started';

  @override
  String get getStartedTooltip => 'Start setup walkthrough';
}
