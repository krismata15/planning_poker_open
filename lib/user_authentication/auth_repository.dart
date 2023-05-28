import 'package:planning_poker_open/user_authentication/firebase_authentication_service.dart';
import 'package:planning_poker_open/user_authentication/models/user_app.dart';

class AuthRepository {
  FirebaseAuthenticationService authenticationService =
      FirebaseAuthenticationService();

  Future<UserApp> getCurrentUser() async {
    final Map<String, dynamic>? userData =
        await authenticationService.checkIfUserIsLoggedIn();

    if (userData == null) {
      throw Exception('User not found');
    }

    return UserApp.fromJson(userData);
  }

  Future<UserApp> signInAnonymously(String username) async {
    final Map<String, dynamic> userData =
        await authenticationService.signInAnonymously(username);

    return UserApp.fromJson(userData);
  }

  Future<UserApp> editUserData(String username) async {
    final Map<String, dynamic> userData =
        await authenticationService.editUserData(username.trim());

    return UserApp.fromJson(userData);
  }
}
