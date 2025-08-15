// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'Vista en Vivo';

  @override
  String get queue => 'Cola';

  @override
  String get facilities => 'Instalaciones';

  @override
  String get players => 'Jugadores';

  @override
  String get sessions => 'Sesiones';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get createFacility => 'Crear Instalación';

  @override
  String get addCourt => 'Agregar Cancha';

  @override
  String get addPlayer => 'Agregar Jugador';

  @override
  String get createSession => 'Crear Sesión';

  @override
  String get facilityName => 'Nombre de Instalación';

  @override
  String get location => 'Ubicación';

  @override
  String get playerName => 'Nombre del Jugador';

  @override
  String get skillLevel => 'Nivel de Habilidad';

  @override
  String get beginner => 'Principiante';

  @override
  String get intermediate => 'Intermedio';

  @override
  String get advanced => 'Avanzado';

  @override
  String get singles => 'Individual';

  @override
  String get doubles => 'Dobles';

  @override
  String get kingOfHill => 'Rey de la Colina';

  @override
  String get roundRobin => 'Todos contra Todos';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String get setupWalkthrough => 'Configuración Inicial';

  @override
  String stepXOfY(int step, int total) {
    return 'Paso $step de $total';
  }

  @override
  String get noLocation => 'Sin ubicación';

  @override
  String courtCount(int count) {
    return '$count Cancha';
  }

  @override
  String courtsCount(int count) {
    return '$count Canchas';
  }

  @override
  String playerCount(int count) {
    return '$count Jugador';
  }

  @override
  String playersCount(int count) {
    return '$count Jugadores';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count más';
  }

  @override
  String get sessionActive => 'Sesión Activa';

  @override
  String startedAt(String time) {
    return 'Iniciada a las $time';
  }

  @override
  String get createYourFacility => 'Crear Tu Instalación';

  @override
  String get facilityDescription =>
      'Una instalación representa el lugar donde juegas pickleball.';

  @override
  String get setupCourts => 'Configurar Canchas';

  @override
  String courtsDescription(String facilityName) {
    return 'Agrega al menos una cancha a $facilityName.';
  }

  @override
  String get addPlayers => 'Agregar Jugadores';

  @override
  String get playersDescription =>
      'Agrega al menos 2 jugadores para comenzar a jugar.';

  @override
  String get startYourSession => 'Iniciar Tu Sesión';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return 'Listo para comenzar a jugar en $facilityName con $playerCount jugadores y $courtCount cancha$courtPlural.';
  }

  @override
  String get startSession => 'Iniciar Sesión';

  @override
  String get allSet => '¡Todo Listo!';

  @override
  String get completedDescription =>
      'Tu sesión está activa y lista para jugar. Los jugadores ahora pueden unirse a la cola.';

  @override
  String get goToLiveView => 'Ir a Vista en Vivo';

  @override
  String get errorLoadingCourts => 'Error cargando canchas';

  @override
  String get needAtLeastTwoPlayers =>
      'Se necesitan al menos 2 jugadores para iniciar una sesión';

  @override
  String get sessionStartedSuccessfully => '¡Sesión iniciada exitosamente!';

  @override
  String errorStartingSession(String error) {
    return 'Error iniciando sesión: $error';
  }
}
