// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'Paparan Langsung';

  @override
  String get queue => 'Barisan';

  @override
  String get facilities => 'Kemudahan';

  @override
  String get players => 'Pemain';

  @override
  String get sessions => 'Sesi';

  @override
  String get settings => 'Tetapan';

  @override
  String get language => 'Bahasa';

  @override
  String get createFacility => 'Cipta Kemudahan';

  @override
  String get addCourt => 'Tambah Gelanggang';

  @override
  String get addPlayer => 'Tambah Pemain';

  @override
  String get createSession => 'Cipta Sesi';

  @override
  String get facilityName => 'Nama Kemudahan';

  @override
  String get location => 'Lokasi';

  @override
  String get playerName => 'Nama Pemain';

  @override
  String get singles => 'Perseorangan';

  @override
  String get doubles => 'Beregu';

  @override
  String get kingOfHill => 'Raja Bukit';

  @override
  String get roundRobin => 'Pusingan Robin';

  @override
  String get save => 'Simpan';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Padam';

  @override
  String get edit => 'Edit';

  @override
  String get next => 'Seterusnya';

  @override
  String get previous => 'Sebelumnya';

  @override
  String get setupWalkthrough => 'Panduan Persediaan';

  @override
  String stepXOfY(int step, int total) {
    return 'Langkah $step daripada $total';
  }

  @override
  String get noLocation => 'Tiada lokasi';

  @override
  String courtCount(int count) {
    return '$count Gelanggang';
  }

  @override
  String courtsCount(int count) {
    return '$count Gelanggang';
  }

  @override
  String playerCount(int count) {
    return '$count Pemain';
  }

  @override
  String playersCount(int count) {
    return '$count Pemain';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count lagi';
  }

  @override
  String get sessionActive => 'Sesi Aktif';

  @override
  String startedAt(String time) {
    return 'Dimulakan pada $time';
  }

  @override
  String get createYourFacility => 'Cipta Kemudahan Anda';

  @override
  String get facilityDescription =>
      'Kemudahan mewakili lokasi di mana anda bermain pickleball.';

  @override
  String get setupCourts => 'Sediakan Gelanggang';

  @override
  String courtsDescription(String facilityName) {
    return 'Tambah sekurang-kurangnya satu gelanggang ke $facilityName.';
  }

  @override
  String get addPlayers => 'Tambah Pemain';

  @override
  String get playersDescription =>
      'Tambah sekurang-kurangnya 2 pemain untuk mula bermain.';

  @override
  String get startYourSession => 'Mulakan Sesi Anda';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return 'Bersedia untuk mula bermain di $facilityName dengan $playerCount pemain dan $courtCount gelanggang$courtPlural.';
  }

  @override
  String get startSession => 'Mulakan Sesi';

  @override
  String get allSet => 'Semua Sedia!';

  @override
  String get completedDescription =>
      'Sesi anda aktif dan sedia untuk bermain. Pemain kini boleh menyertai barisan.';

  @override
  String get goToLiveView => 'Pergi ke Paparan Langsung';

  @override
  String get errorLoadingCourts => 'Ralat memuatkan gelanggang';

  @override
  String get needAtLeastTwoPlayers =>
      'Memerlukan sekurang-kurangnya 2 pemain untuk memulakan sesi';

  @override
  String get sessionStartedSuccessfully => 'Sesi dimulakan dengan jayanya!';

  @override
  String errorStartingSession(String error) {
    return 'Ralat memulakan sesi: $error';
  }

  @override
  String get getStarted => 'Get Started';

  @override
  String get getStartedTooltip => 'Start setup walkthrough';
}
