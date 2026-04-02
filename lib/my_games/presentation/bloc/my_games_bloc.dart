import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning_poker_open/active_game/data/models/game_model.dart';
import 'package:planning_poker_open/my_games/data/sources/my_games_data_source.dart';

part 'my_games_event.dart';
part 'my_games_state.dart';

class MyGamesBloc extends Bloc<MyGamesEvent, MyGamesState> {
  MyGamesBloc() : super(MyGamesInitial()) {
    on<LoadMyGames>(_onLoadMyGames);
  }

  final MyGamesDataSource _dataSource = MyGamesDataSource();

  Future<void> _onLoadMyGames(
    LoadMyGames event,
    Emitter<MyGamesState> emit,
  ) async {
    emit(MyGamesLoading());
    try {
      final games = await _dataSource.getMyGames();
      emit(MyGamesLoaded(games: games));
    } catch (e) {
      emit(MyGamesError(message: e.toString()));
    }
  }
}
