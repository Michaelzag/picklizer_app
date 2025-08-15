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
}
