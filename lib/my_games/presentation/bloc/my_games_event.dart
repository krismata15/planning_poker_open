part of 'my_games_bloc.dart';

abstract class MyGamesEvent extends Equatable {
  const MyGamesEvent();

  @override
  List<Object> get props => [];
}

class LoadMyGames extends MyGamesEvent {}
