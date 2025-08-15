// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Pickleizer';

  @override
  String get liveView => 'Visualização ao Vivo';

  @override
  String get queue => 'Fila';

  @override
  String get facilities => 'Instalações';

  @override
  String get players => 'Jogadores';

  @override
  String get sessions => 'Sessões';

  @override
  String get settings => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get createFacility => 'Criar Instalação';

  @override
  String get addCourt => 'Adicionar Quadra';

  @override
  String get addPlayer => 'Adicionar Jogador';

  @override
  String get createSession => 'Criar Sessão';

  @override
  String get facilityName => 'Nome da Instalação';

  @override
  String get location => 'Localização';

  @override
  String get playerName => 'Nome do Jogador';

  @override
  String get skillLevel => 'Nível de Habilidade';

  @override
  String get beginner => 'Iniciante';

  @override
  String get intermediate => 'Intermediário';

  @override
  String get advanced => 'Avançado';

  @override
  String get singles => 'Simples';

  @override
  String get doubles => 'Duplas';

  @override
  String get kingOfHill => 'Rei da Colina';

  @override
  String get roundRobin => 'Todos contra Todos';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get next => 'Próximo';

  @override
  String get previous => 'Anterior';

  @override
  String get setupWalkthrough => 'Configuração Inicial';

  @override
  String stepXOfY(int step, int total) {
    return 'Passo $step de $total';
  }
}
