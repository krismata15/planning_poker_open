import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning_poker_open/active_game/data/models/game_model.dart';
import 'package:planning_poker_open/active_game/data/models/game_results_model.dart';
import 'package:planning_poker_open/active_game/data/models/player_card_selection.dart';
import 'package:planning_poker_open/active_game/domain/entities/user_player_entity.dart';
import 'package:planning_poker_open/active_game/domain/repository/active_game_repository.dart';
import 'package:planning_poker_open/create_game/domain/entities/deck_entity.dart';

part 'active_game_event.dart';
part 'active_game_state.dart';

class ActiveGameBloc extends Bloc<ActiveGameEvent, ActiveGameState> {
  ActiveGameBloc({required this.gameId}) : super(ActiveGameInitial()) {
    on<ActiveGameGetInitialData>(_getInitialData);
    on<ActiveGameSelectOption>(_selectOptionCard);
    on<ActiveGameRevealCards>(_revealCards);
    on<ActiveGameReset>(_resetGameSelections);
  }

  final ActiveGameRepository activeGameRepository = ActiveGameRepository();
  final String gameId;

  Future<void> _getInitialData(
    ActiveGameGetInitialData event,
    Emitter<ActiveGameState> emit,
  ) async {
    emit(ActiveGameGettingInitialData());
    final User? user = FirebaseAuth.instance.currentUser;

    final listenable = await activeGameRepository.getActiveGame(event.gameId);
    await emit.forEach(
      listenable,
      onData: (DocumentSnapshot<Map<String, dynamic>> data) {
        final GameStatus gameStatus = gameStatusFromString(
          data.data()!['status'],
        );
        GameResult? gameResult;
        if (gameStatus == GameStatus.revealed) {
          gameResult = GameResult.fromJson(
            data.data()!['game_results'],
          );
        }

        final List<PlayerCardSelectionModel> selections =
            ((data.data()?['selections'] as List?) ?? [])
                .map<PlayerCardSelectionModel>(
                  (selection) => PlayerCardSelectionModel.fromJson(selection),
                )
                .toList();
        final DeckEntity deckEntity = DeckEntity.fromJson(
          data.data()!['deck'],
        );

        final List<UserPlayerEntity> players =
            ((data.data()?['players'] as List?) ?? [])
                .cast<Map<String, dynamic>>()
                .map<UserPlayerEntity>(UserPlayerEntity.fromJson)
                .toList();

        final UserPlayerEntity activeUser =
            players.firstWhere((element) => element.id == user!.uid);
        final PlayerCardSelectionModel? selection = selections.firstWhereOrNull(
          (element) => element.playerId == activeUser.id,
        );

        return ActiveGameUpdated(
          gameName: data.data()!['name'],
          playerCardSelections: selections,
          cards: deckEntity,
          players: players,
          activeUser: activeUser,
          selection: selection,
          gameStatus: gameStatus,
          gameResult: gameResult,
        );
      },
      onError: (e, s) => ActiveGameError(message: 'Error getting game'),
    );
  }

  Future<void> _selectOptionCard(
    ActiveGameSelectOption event,
    Emitter<ActiveGameState> emit,
  ) async {
    final currentState = state;
    if (currentState is ActiveGameUpdated) {
      final optimisticSelection = PlayerCardSelectionModel(
        playerId: currentState.activeUser.id,
        selection: event.option,
      );

      final updatedSelections = List<PlayerCardSelectionModel>.from(
          currentState.playerCardSelections);
      final index = updatedSelections
          .indexWhere((s) => s.playerId == currentState.activeUser.id);
      if (index > -1) {
        updatedSelections[index] = optimisticSelection;
      } else {
        updatedSelections.add(optimisticSelection);
      }

      emit(
        ActiveGameUpdated(
          gameName: currentState.gameName,
          playerCardSelections: updatedSelections,
          cards: currentState.cards,
          players: currentState.players,
          activeUser: currentState.activeUser,
          selection: optimisticSelection,
          gameStatus: GameStatus.selections,
          gameResult: currentState.gameResult,
        ),
      );
    }

    try {
      await activeGameRepository.selectOption(gameId, event.option);
    } catch (e) {
      if (currentState is ActiveGameUpdated) {
        emit(
          ActiveGameUpdated(
            gameName: currentState.gameName,
            playerCardSelections: currentState.playerCardSelections,
            cards: currentState.cards,
            players: currentState.players,
            activeUser: currentState.activeUser,
            selection: currentState.selection,
            gameStatus: currentState.gameStatus,
            gameResult: currentState.gameResult,
          ),
        );
      } else {
        emit(ActiveGameError(message: 'Error selecting card'));
      }
    }
  }

  Future<void> _revealCards(
    ActiveGameRevealCards event,
    Emitter<ActiveGameState> emit,
  ) async {
    try {
      await activeGameRepository.revealCards(gameId);
    } catch (e) {
      emit(ActiveGameError(message: 'Error revealing cards'));
    }
  }

  Future<void> _resetGameSelections(
    ActiveGameReset event,
    Emitter<ActiveGameState> emit,
  ) async {
    try {
      await activeGameRepository.resetGameSelections(gameId);
    } catch (e) {
      emit(ActiveGameError(message: 'Error resetting game'));
    }
  }
}
