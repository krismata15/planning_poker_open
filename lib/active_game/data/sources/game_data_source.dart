import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:planning_poker_open/active_game/data/models/game_model.dart';
import 'package:planning_poker_open/active_game/data/models/game_results_model.dart';
import 'package:planning_poker_open/active_game/data/models/player_card_selection.dart';
import 'package:planning_poker_open/shared/utils/firebase_collection_names.dart';

class GameDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getActiveGame(
      String gameId) async {
    await checkIfUserExistOrCreateOnGame(gameId);

    final Stream<DocumentSnapshot<Map<String, dynamic>>> gameReference = _db
        .collection(FirebaseCollectionNames.gamesCollection)
        .doc(gameId)
        .snapshots();

    return gameReference;
  }

  Future<void> checkIfUserExistOrCreateOnGame(String gameId) async {
    final User? user = FirebaseAuth.instance.currentUser;

    final DocumentReference<Map<String, dynamic>> gameReference =
        _db.collection(FirebaseCollectionNames.gamesCollection).doc(gameId);

    final documentReference = await gameReference.get();

    final List<dynamic> players = documentReference.data()!['players'];

    final bool userExist = players.any((element) => element['id'] == user!.uid);

    if (!userExist) {
      final Map<String, dynamic> playerData = {
        'id': user!.uid,
        'position': players.length + 1,
        'name': user.displayName,
      };

      await gameReference.update({
        'players': FieldValue.arrayUnion([playerData]),
        'active_players': FieldValue.increment(1),
      });
    }
  }

  Future<void> selectOption(String gameId, String option) async {
    final User? user = FirebaseAuth.instance.currentUser;

    final DocumentReference<Map<String, dynamic>> gameReference =
        _db.collection(FirebaseCollectionNames.gamesCollection).doc(gameId);

    await _db.runTransaction((transaction) async {
      final documentSnapshot = await transaction.get(gameReference);
      final GameStatus actualGameStatus =
          gameStatusFromString(documentSnapshot.data()!['status']);

      if (actualGameStatus != GameStatus.selections &&
          actualGameStatus != GameStatus.initial) {
        return;
      }

      final List<dynamic> selections = documentSnapshot.data()!['selections'];
      final Map<String, dynamic> playerData = {
        'player_id': user!.uid,
        'selection': option,
      };

      final int index =
          selections.indexWhere((element) => element['player_id'] == user.uid);

      if (index > -1) {
        selections[index]['selection'] = option;
      } else {
        selections.add(playerData);
      }

      transaction.update(gameReference, {
        'status': GameStatus.selections.name,
        'selections': selections,
      });
    });
  }

  Future<void> revealCards(String gameId) async {
    final gameReference = await _db.collection('games').doc(gameId).get();

    if (!gameReference.exists) {
      return;
    }

    await gameReference.reference.update({
      'status': GameStatus.revealing.name,
    });

    final Map<String, dynamic> gameDataRaw = gameReference.data()!;

    final GameModel gameModel =
        GameModel.fromJson(gameDataRaw, gameReference.id);

    final List<PlayerCardSelectionModel> playerCardSelections =
        gameModel.playerCardSelections;

    final gameResultsDocumentReference =
        _db.collection(FirebaseCollectionNames.gamesResultsCollection).doc();

    final HistoricGameResult gameResults = HistoricGameResult(
      id: gameResultsDocumentReference.id,
      gameData: gameModel.copyWith(),
      selectionsCount: gameModel.playerCardSelections.length,
      selectionsResultData: playerCardSelections
          .map(
            (playerSelection) => SelectionsResultData.fromPlayerSelections(
              playerCardSelections,
              playerSelection.selection,
            ),
          )
          .toSet()
          .toList(),
    );
    await gameResultsDocumentReference.set(
      gameResults.toJson(),
    );

    await gameReference.reference.update({
      'status': GameStatus.revealed.name,
      'game_results': GameResult(
        selectionsCount: gameResults.selectionsCount,
        selectionsResultData: gameResults.selectionsResultData,
      ).toJson(),
    });
  }

  Future<void> resetGameSelections(String gameId) async {
    final gameSnapshot = await _db.collection('games').doc(gameId).get();

    if (!gameSnapshot.exists) {
      return;
    }

    await gameSnapshot.reference.update({
      'status': GameStatus.initial.name,
      'selections': [],
      'game_results': null,
    });
  }
}
