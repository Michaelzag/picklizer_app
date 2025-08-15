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

  @override
  String get noLocation => 'Nessuna posizione';

  @override
  String courtCount(int count) {
    return '$count Campo';
  }

  @override
  String courtsCount(int count) {
    return '$count Campi';
  }

  @override
  String playerCount(int count) {
    return '$count Giocatore';
  }

  @override
  String playersCount(int count) {
    return '$count Giocatori';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count altri';
  }

  @override
  String get sessionActive => 'Sessione Attiva';

  @override
  String startedAt(String time) {
    return 'Iniziata alle $time';
  }

  @override
  String get createYourFacility => 'Crea la Tua Struttura';

  @override
  String get facilityDescription =>
      'Una struttura rappresenta il luogo dove giochi a pickleball.';

  @override
  String get setupCourts => 'Configura Campi';

  @override
  String courtsDescription(String facilityName) {
    return 'Aggiungi almeno un campo a $facilityName.';
  }

  @override
  String get addPlayers => 'Aggiungi Giocatori';

  @override
  String get playersDescription =>
      'Aggiungi almeno 2 giocatori per iniziare a giocare.';

  @override
  String get startYourSession => 'Inizia la Tua Sessione';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return 'Pronto per iniziare a giocare a $facilityName con $playerCount giocatori e $courtCount campo$courtPlural.';
  }

  @override
  String get startSession => 'Inizia Sessione';

  @override
  String get allSet => 'Tutto Pronto!';

  @override
  String get completedDescription =>
      'La tua sessione è attiva e pronta per giocare. I giocatori ora possono unirsi alla coda.';

  @override
  String get goToLiveView => 'Vai alla Vista Live';

  @override
  String get errorLoadingCourts => 'Errore nel caricamento dei campi';

  @override
  String get needAtLeastTwoPlayers =>
      'Servono almeno 2 giocatori per iniziare una sessione';

  @override
  String get sessionStartedSuccessfully => 'Sessione iniziata con successo!';

  @override
  String errorStartingSession(String error) {
    return 'Errore nell\'avvio della sessione: $error';
  }
}
