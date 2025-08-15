// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'Vista Live';

  @override
  String get queue => 'Coda';

  @override
  String get facilities => 'Strutture';

  @override
  String get players => 'Giocatori';

  @override
  String get sessions => 'Sessioni';

  @override
  String get settings => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String get createFacility => 'Crea Struttura';

  @override
  String get addCourt => 'Aggiungi Campo';

  @override
  String get addPlayer => 'Aggiungi Giocatore';

  @override
  String get createSession => 'Crea Sessione';

  @override
  String get facilityName => 'Nome Struttura';

  @override
  String get location => 'Posizione';

  @override
  String get playerName => 'Nome Giocatore';

  @override
  String get skillLevel => 'Livello Abilità';

  @override
  String get beginner => 'Principiante';

  @override
  String get intermediate => 'Intermedio';

  @override
  String get advanced => 'Avanzato';

  @override
  String get singles => 'Singolo';

  @override
  String get doubles => 'Doppio';

  @override
  String get kingOfHill => 'Re della Collina';

  @override
  String get roundRobin => 'Girone all\'Italiana';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get edit => 'Modifica';

  @override
  String get next => 'Avanti';

  @override
  String get previous => 'Indietro';

  @override
  String get setupWalkthrough => 'Guida Configurazione';

  @override
  String stepXOfY(int step, int total) {
    return 'Passo $step di $total';
  }
}
