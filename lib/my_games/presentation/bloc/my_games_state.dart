part of 'my_games_bloc.dart';

abstract class MyGamesState extends Equatable {
  const MyGamesState();

  @override
  List<Object> get props => [];
}

class MyGamesInitial extends MyGamesState {}

class MyGamesLoading extends MyGamesState {}

class MyGamesLoaded extends MyGamesState {
  const MyGamesLoaded({required this.games});

  final List<GameModel> games;

  @override
  List<Object> get props => [games];
}

class MyGamesError extends MyGamesState {
  const MyGamesError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
