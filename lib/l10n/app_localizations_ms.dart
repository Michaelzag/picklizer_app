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
  String get skillLevel => 'Tahap Kemahiran';

  @override
  String get beginner => 'Pemula';

  @override
  String get intermediate => 'Pertengahan';

  @override
  String get advanced => 'Lanjutan';

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
}
