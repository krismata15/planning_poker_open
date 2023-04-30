part of 'create_game_bloc.dart';

@immutable
abstract class CreateGameState {}

class CreateGameInitial extends CreateGameState {}

class CreateGameInProgress extends CreateGameState {}

class CreateGameSuccess extends CreateGameState {}

class CreateGameError extends CreateGameState {}
