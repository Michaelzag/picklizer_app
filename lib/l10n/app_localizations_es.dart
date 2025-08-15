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
}
