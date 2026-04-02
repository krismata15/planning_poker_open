part of 'create_game_bloc.dart';

sealed class CreateGameState {}

final class CreateGameInitial extends CreateGameState {}

final class CreateGameGettingInitialData extends CreateGameState {}

final class CreateGameGotInitialData extends CreateGameState {
  CreateGameGotInitialData({required this.decks});

  final List<DeckEntity> decks;
}

final class CreateGameInProgress extends CreateGameState {}

final class CreateGameSuccess extends CreateGameState {
  CreateGameSuccess({required this.gameId});

  final String gameId;
}

final class CreateGameError extends CreateGameState {}
