import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:planning_poker_open/shared/utils/firebase_collection_names.dart';

class FirebaseAuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges();
  }

  Future<Map<String, dynamic>?> checkIfUserIsLoggedIn() async {
    final User? user = _firebaseAuth.currentUser;
    print('User initial status ${user != null ? 'logged in' : 'logged out'}');
    if (user != null) {
      await user.reload();
      return (await _db
              .collection(FirebaseCollectionNames.usersCollection)
              .doc(user.uid)
              .get())
          .data()!;
    }
    return null;
  }

  Future<Map<String, dynamic>> editUserData(String username) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(username);
      await _db
          .collection(FirebaseCollectionNames.usersCollection)
          .doc(user.uid)
          .update({
        'username': username,
      });
      return (await _db
              .collection(FirebaseCollectionNames.usersCollection)
              .doc(user.uid)
              .get())
          .data()!;
    }
    throw Exception('User not found');
  }

  Future<Map<String, dynamic>> signInAnonymously(String username) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInAnonymously();

      final String userId = userCredential.user!.uid;

      await userCredential.user!.updateDisplayName(username);

      await _db
          .collection(FirebaseCollectionNames.usersCollection)
          .doc(userId)
          .set({
        'id': userId,
        'username': username,
        'type': 'anonymous',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return (await _db
              .collection(FirebaseCollectionNames.usersCollection)
              .doc(userId)
              .get())
          .data()!;
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
