import 'package:planning_poker_open/user_authentication/firebase_authentication_service.dart';

class AuthRepository {
  FirebaseAuthenticationService authenticationService =
      FirebaseAuthenticationService();

  Future<void> signInAnonymously(String username) async {
    return authenticationService.signInAnonymously(username);
  }
}
