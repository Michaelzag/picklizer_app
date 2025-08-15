// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'Vue en Direct';

  @override
  String get queue => 'File d\'Attente';

  @override
  String get facilities => 'Installations';

  @override
  String get players => 'Joueurs';

  @override
  String get sessions => 'Sessions';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get createFacility => 'Créer Installation';

  @override
  String get addCourt => 'Ajouter Terrain';

  @override
  String get addPlayer => 'Ajouter Joueur';

  @override
  String get createSession => 'Créer Session';

  @override
  String get facilityName => 'Nom de l\'Installation';

  @override
  String get location => 'Emplacement';

  @override
  String get playerName => 'Nom du Joueur';

  @override
  String get skillLevel => 'Niveau de Compétence';

  @override
  String get beginner => 'Débutant';

  @override
  String get intermediate => 'Intermédiaire';

  @override
  String get advanced => 'Avancé';

  @override
  String get singles => 'Simple';

  @override
  String get doubles => 'Double';

  @override
  String get kingOfHill => 'Roi de la Colline';

  @override
  String get roundRobin => 'Tournoi à la Ronde';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get next => 'Suivant';

  @override
  String get previous => 'Précédent';

  @override
  String get setupWalkthrough => 'Configuration Initiale';

  @override
  String stepXOfY(int step, int total) {
    return 'Étape $step sur $total';
  }

  @override
  String get noLocation => 'Aucun emplacement';

  @override
  String courtCount(int count) {
    return '$count Terrain';
  }

  @override
  String courtsCount(int count) {
    return '$count Terrains';
  }

  @override
  String playerCount(int count) {
    return '$count Joueur';
  }

  @override
  String playersCount(int count) {
    return '$count Joueurs';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count de plus';
  }

  @override
  String get sessionActive => 'Session Active';

  @override
  String startedAt(String time) {
    return 'Commencée à $time';
  }

  @override
  String get createYourFacility => 'Créer Votre Installation';

  @override
  String get facilityDescription =>
      'Une installation représente l\'endroit où vous jouez au pickleball.';

  @override
  String get setupCourts => 'Configurer les Terrains';

  @override
  String courtsDescription(String facilityName) {
    return 'Ajoutez au moins un terrain à $facilityName.';
  }

  @override
  String get addPlayers => 'Ajouter des Joueurs';

  @override
  String get playersDescription =>
      'Ajoutez au moins 2 joueurs pour commencer à jouer.';

  @override
  String get startYourSession => 'Commencer Votre Session';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return 'Prêt à commencer à jouer à $facilityName avec $playerCount joueurs et $courtCount terrain$courtPlural.';
  }

  @override
  String get startSession => 'Commencer la Session';

  @override
  String get allSet => 'Tout est Prêt !';

  @override
  String get completedDescription =>
      'Votre session est active et prête à jouer. Les joueurs peuvent maintenant rejoindre la file d\'attente.';

  @override
  String get goToLiveView => 'Aller à la Vue en Direct';

  @override
  String get errorLoadingCourts => 'Erreur lors du chargement des terrains';

  @override
  String get needAtLeastTwoPlayers =>
      'Il faut au moins 2 joueurs pour commencer une session';

  @override
  String get sessionStartedSuccessfully => 'Session démarrée avec succès !';

  @override
  String errorStartingSession(String error) {
    return 'Erreur lors du démarrage de la session : $error';
  }
}
