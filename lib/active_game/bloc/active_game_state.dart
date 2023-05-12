part of 'active_game_bloc.dart';

@immutable
abstract class ActiveGameState {}

class ActiveGameInitial extends ActiveGameState {}

class ActiveGameGettingInitialData extends ActiveGameState {}

class ActiveGameInitialDataLoaded extends ActiveGameState {
  ActiveGameInitialDataLoaded({
    required this.gameName,
    required this.cards,
  });

  final String gameName;
  final List<DeckEntity> cards;
}

class ActiveGameUpdated extends ActiveGameState {
  ActiveGameUpdated({
    required this.gameName,
    required this.players,
    required this.cards,
    required this.playerCardSelections,
    required this.activeUser,
    required this.selection,
    required this.gameStatus,
    this.gameResult,
  });

  final List<PlayerCardSelection> playerCardSelections;
  final String gameName;
  final DeckEntity cards;
  final List<UserPlayerEntity> players;
  final UserPlayerEntity activeUser;
  final PlayerCardSelection? selection;
  final GameStatus gameStatus;
  final GameResult? gameResult;
}

class ActiveGameError extends ActiveGameState {
  ActiveGameError({required this.message});

  final String message;
}
