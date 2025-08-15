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

  @override
  String get noLocation => 'Sem localização';

  @override
  String courtCount(int count) {
    return '$count Quadra';
  }

  @override
  String courtsCount(int count) {
    return '$count Quadras';
  }

  @override
  String playerCount(int count) {
    return '$count Jogador';
  }

  @override
  String playersCount(int count) {
    return '$count Jogadores';
  }

  @override
  String morePlayersIndicator(int count) {
    return ' +$count mais';
  }

  @override
  String get sessionActive => 'Sessão Ativa';

  @override
  String startedAt(String time) {
    return 'Iniciada às $time';
  }

  @override
  String get createYourFacility => 'Criar Sua Instalação';

  @override
  String get facilityDescription =>
      'Uma instalação representa o local onde você joga pickleball.';

  @override
  String get setupCourts => 'Configurar Quadras';

  @override
  String courtsDescription(String facilityName) {
    return 'Adicione pelo menos uma quadra a $facilityName.';
  }

  @override
  String get addPlayers => 'Adicionar Jogadores';

  @override
  String get playersDescription =>
      'Adicione pelo menos 2 jogadores para começar a jogar.';

  @override
  String get startYourSession => 'Iniciar Sua Sessão';

  @override
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  ) {
    return 'Pronto para começar a jogar em $facilityName com $playerCount jogadores e $courtCount quadra$courtPlural.';
  }

  @override
  String get startSession => 'Iniciar Sessão';

  @override
  String get allSet => 'Tudo Pronto!';

  @override
  String get completedDescription =>
      'Sua sessão está ativa e pronta para jogar. Os jogadores agora podem entrar na fila.';

  @override
  String get goToLiveView => 'Ir para Visualização ao Vivo';

  @override
  String get errorLoadingCourts => 'Erro ao carregar quadras';

  @override
  String get needAtLeastTwoPlayers =>
      'Precisa de pelo menos 2 jogadores para iniciar uma sessão';

  @override
  String get sessionStartedSuccessfully => 'Sessão iniciada com sucesso!';

  @override
  String errorStartingSession(String error) {
    return 'Erro ao iniciar sessão: $error';
  }
}
