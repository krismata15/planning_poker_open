import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planning_poker_open/firebase_collection_names.dart';

class GameFirebaseSource {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> createGame() async {
    // Create a new user with a first and last name
    final user = <String, dynamic>{
      "first": "Ada",
      "last": "Lovelace",
      "born": 1815
    };

    await db.collection(FirebaseCollectionNames.gamesCollection).add(user);
  }
}
