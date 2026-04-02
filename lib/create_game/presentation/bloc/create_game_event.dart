part of 'create_game_bloc.dart';

sealed class CreateGameEvent {}

final class GetInitialDataForCreatingGame extends CreateGameEvent {}

final class CreateGame extends CreateGameEvent {
  CreateGame({required this.deckId, required this.gameName});

  final String gameName;
  final String deckId;
}
