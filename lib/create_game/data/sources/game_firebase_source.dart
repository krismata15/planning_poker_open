import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:planning_poker_open/active_game/data/models/game_model.dart';
import 'package:planning_poker_open/create_game/data/models/deck_model.dart';
import 'package:planning_poker_open/shared/utils/firebase_collection_names.dart';

class GameFirebaseSource {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> createGame(String deckId, String? name) async {
    print('Llamando esta deck $deckId');
    final DocumentSnapshot<DeckModel> deck = await db
        .collection(FirebaseCollectionNames.decksCollection)
        .doc(deckId)
        .withConverter<DeckModel>(
          fromFirestore: (snapshot, _) =>
              DeckModel.fromJsonFirebase(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson(),
        )
        .get();

    final User? user = FirebaseAuth.instance.currentUser;

    final gameData = <String, dynamic>{
      'name': name ?? 'Planning Poker Game',
      'players': [
        {
          'id': user!.uid,
          'position': 1,
          'name': user.displayName,
        },
      ],
      'deck': {
        'id': deck.id,
        'name': deck.data()!.name,
        'options': deck.data()!.options,
      },
      'selections': [],
      'active_players': 1,
      'createdAt': FieldValue.serverTimestamp(),
      'status': GameStatus.initial.name,
    };

    final DocumentReference<Map<String, dynamic>> result = await db
        .collection(FirebaseCollectionNames.gamesCollection)
        .add(gameData);

    return result.id;
  }

  Future<List<DeckModel>> getUserDecks() async {
    final QuerySnapshot<DeckModel> querySnapshot = await db
        .collection(FirebaseCollectionNames.decksCollection)
        .withConverter<DeckModel>(
          fromFirestore: (snapshot, _) =>
              DeckModel.fromJsonFirebase(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson(),
        )
        .get();

    return querySnapshot.docs.map((e) => e.data()).toList();
  }
}
