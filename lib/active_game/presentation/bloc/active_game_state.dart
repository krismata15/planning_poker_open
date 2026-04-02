part of 'active_game_bloc.dart';

sealed class ActiveGameState {}

final class ActiveGameInitial extends ActiveGameState {}

final class ActiveGameGettingInitialData extends ActiveGameState {}

final class ActiveGameInitialDataLoaded extends ActiveGameState {
  ActiveGameInitialDataLoaded({
    required this.gameName,
    required this.cards,
  });

  final String gameName;
  final List<DeckEntity> cards;
}

final class ActiveGameUpdated extends ActiveGameState {
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

  final List<PlayerCardSelectionModel> playerCardSelections;
  final String gameName;
  final DeckEntity cards;
  final List<UserPlayerEntity> players;
  final UserPlayerEntity activeUser;
  final PlayerCardSelectionModel? selection;
  final GameStatus gameStatus;
  final GameResult? gameResult;
}

final class ActiveGameError extends ActiveGameState {
  ActiveGameError({required this.message});

  final String message;
}
