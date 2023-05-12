import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:planning_poker_open/shared/utils/firebase_collection_names.dart';

class FirebaseAuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> signInAnonymously(String username) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInAnonymously();

      final String userId = userCredential.user!.uid;

      await userCredential.user!.updateDisplayName(username);

      await _db
          .collection(FirebaseCollectionNames.usersCollection)
          .doc(userId)
          .set({
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final Map<String, dynamic> data = {
        'id': userId,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
        'type': 'anonymous',
      };

      await _db
          .collection(FirebaseCollectionNames.usersCollection)
          .doc(userId)
          .set(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
