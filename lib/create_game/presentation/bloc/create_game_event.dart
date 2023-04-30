part of 'create_game_bloc.dart';

@immutable
abstract class CreateGameEvent {}

class CreateGame extends CreateGameEvent {
  CreateGame({this.gameName, this.votingSystemId});

  final String? gameName;
  final String? votingSystemId;
}
