part of 'create_game_bloc.dart';

@immutable
abstract class CreateGameState {}

class CreateGameInitial extends CreateGameState {}

class CreateGameGettingInitialData extends CreateGameState {}

class CreateGameGotInitialData extends CreateGameState {
  CreateGameGotInitialData({required this.decks});

  final List<DeckEntity> decks;
}

class CreateGameInProgress extends CreateGameState {}

class CreateGameSuccess extends CreateGameState {
  CreateGameSuccess({required this.gameId});

  final String gameId;
}

class CreateGameError extends CreateGameState {}
