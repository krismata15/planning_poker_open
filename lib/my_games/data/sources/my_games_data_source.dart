import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:planning_poker_open/active_game/data/models/game_model.dart';
import 'package:planning_poker_open/shared/utils/firebase_collection_names.dart';

class MyGamesDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<GameModel>> getMyGames() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(FirebaseCollectionNames.gamesCollection)
        .where('player_ids', arrayContains: user.uid)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => GameModel.fromJson(doc.data(), doc.id))
        .toList();
  }
}
