import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:planning_poker_open/active_game/active_game_repository.dart';
import 'package:planning_poker_open/active_game/player_card_selection.dart';
import 'package:planning_poker_open/active_game/user_player_entity.dart';
import 'package:planning_poker_open/create_game/domain/entities/deck_entity.dart';

part 'active_game_event.dart';
part 'active_game_state.dart';

class ActiveGameBloc extends Bloc<ActiveGameEvent, ActiveGameState> {
  ActiveGameBloc({required this.gameId}) : super(ActiveGameInitial()) {
    on<ActiveGameSelectOption>(_selectOptionCard);
    on<ActiveGameGetInitialData>(
        (ActiveGameGetInitialData event, Emitter<ActiveGameState> emit) async {
      final User? user = FirebaseAuth.instance.currentUser;
      //http://localhost:63744/#/active-game/o532uOJ7DiYHudvjl8Eh
      print('eNTRANDO AQUI EVENTO');
      final listenable = await activeGameRepository.getActiveGame(event.gameId);
      await emit.forEach(listenable,
          onData: (DocumentSnapshot<Map<String, dynamic>> data) {
        print('game listener fired');

        print('data ${data.data()}');
        print(
            'data ${(data.data()!['selections'] as List).map((e) => e).toList()}');

        final List<PlayerCardSelection> selections =
            ((data.data()?['selections'] as List?) ?? [])
                .map<PlayerCardSelection>(
                    (selection) => PlayerCardSelection.fromJson(selection))
                .toList();
        final DeckEntity deckEntity = DeckEntity.fromJson(
          data.data()!['deck'],
        );
        print('selections $selections');

        final List<UserPlayerEntity> players =
            ((data.data()?['players'] as List?) ?? [])
                .cast<Map<String, dynamic>>()
                .map<UserPlayerEntity>(UserPlayerEntity.fromJson)
                .toList();

        final UserPlayerEntity activeUser =
            players.firstWhere((element) => element.id == user!.uid);
        final PlayerCardSelection? selection = selections.firstWhereOrNull(
          (element) => element.playerId == activeUser.id,
        );
        return ActiveGameUpdated(
          gameName: data.data()!['name'],
          playerCardSelections: selections,
          cards: deckEntity,
          players: players,
          activeUser: activeUser,
          selection: selection,
        );
      }, onError: (e, s) {
        print('error $e $s');
        return ActiveGameError(message: 'Error getting game');
      });
    });
  }

  final ActiveGameRepository activeGameRepository = ActiveGameRepository();
  final String gameId;

  Future<void> _selectOptionCard(
      ActiveGameSelectOption event, Emitter<ActiveGameState> emit) async {
    try {
      await activeGameRepository.selectOption(gameId, event.option);
    } catch (e) {
      emit(ActiveGameError(message: 'Error selecting card'));
    }
  }
}
