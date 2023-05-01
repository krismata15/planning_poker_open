import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getActiveGame(
      String gameId) async {
    await checkIfUserExistOrCreateOnGame(gameId);

    final Stream<DocumentSnapshot<Map<String, dynamic>>> gameReference =
        _db.collection('games').doc(gameId).snapshots();

    return gameReference;
  }

  Future<void> checkIfUserExistOrCreateOnGame(String gameId) async {
    final User? user = FirebaseAuth.instance.currentUser;

    final DocumentReference<Map<String, dynamic>> gameReference =
        _db.collection('games').doc(gameId);

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
        _db.collection('games').doc(gameId);

    final documentReference = await gameReference.get();

    final List<dynamic> selections = documentReference.data()!['selections'];

    final Map<String, dynamic> playerData = {
      'player_id': user!.uid,
      'selection': option,
    };

    final int index =
        selections.indexWhere((element) => element['player_id'] == user!.uid);

    if (index > -1) {
      selections[index]['selection'] = option;
    } else {
      selections.add(playerData);
    }

    await gameReference.set(
        {
          'selections': selections,
        },
        SetOptions(
          merge: true,
        ));
  }
}
