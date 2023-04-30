part of 'create_game_bloc.dart';

@immutable
abstract class CreateGameEvent {}

class GetInitialDataForCreatingGame extends CreateGameEvent {}

class CreateGame extends CreateGameEvent {
  CreateGame({required this.deckId, required this.gameName});

  final String gameName;
  final String deckId;
}
