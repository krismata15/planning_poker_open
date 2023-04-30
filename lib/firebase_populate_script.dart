import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planning_poker_open/firebase_collection_names.dart';

abstract class FirebasePopulateScript {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> populate() async {
    await populateBasicDecks();
  }

  // for mock data
  static Future<void> populateBasicDecks() async {
    final aggregateQuery = await db
        .collection(FirebaseCollectionNames.decksCollection)
        .count()
        .get();

    if (aggregateQuery.count > 0) {
      return;
    }
    for (final deck in standardDecks) {
      await db
          .collection(FirebaseCollectionNames.decksCollection)
          .doc()
          .set(deck);
    }
  }

  static List<Map<String, dynamic>> standardDecks = [
    {
      'name': 'Fibonacci',
      'options': ['0', '1', '2', '3', '5', '8', '13', '21', '34', '55', '89'],
      'type': 'standard',
    },
    {
      'name': 'Modified Fibonacci',
      'options': ['0', '1', '2', '3', '5', '8', '13', '20', '?', '☕️'],
      'type': 'standard',
    },
    {
      'name': 'T-Shirt Sizes',
      'options': ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL', '?', '☕️'],
      'type': 'standard',
    },
    {
      'name': 'Power of 2',
      'options': ['0', '1', '2', '4', '8', '16', '32', '64', '128', '256'],
      'type': 'standard',
    }
  ];
}
