import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning_poker_open/create_game/domain/create_game_repository.dart';
import 'package:planning_poker_open/create_game/domain/entities/deck_entity.dart';

part 'create_game_event.dart';
part 'create_game_state.dart';

class CreateGameBloc extends Bloc<CreateGameEvent, CreateGameState> {
  CreateGameBloc() : super(CreateGameInitial()) {
    on<GetInitialDataForCreatingGame>(_getInitialDataForCreatingGame);
    on<CreateGame>(_createGame);
  }

  final CreateGameRepository _repository = CreateGameRepository();

  Future<void> _getInitialDataForCreatingGame(
      GetInitialDataForCreatingGame event,
      Emitter<CreateGameState> emit) async {
    try {
      emit(CreateGameGettingInitialData());
      final List<DeckEntity> decks =
          await _repository.getInitialDataForCreateGame();
      emit(
        CreateGameGotInitialData(
          decks: decks,
        ),
      );
    } catch (e) {
      emit(CreateGameError());
    }
  }

  Future<void> _createGame(
      CreateGame event, Emitter<CreateGameState> emit) async {
    try {
      emit(CreateGameInProgress());
      final String gameId =
          await _repository.createGame(event.deckId, event.gameName);
      emit(CreateGameSuccess(
        gameId: gameId,
      ));
    } catch (e) {
      emit(CreateGameError());
    }
  }
}
