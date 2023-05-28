import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning_poker_open/user_authentication/auth_repository.dart';
import 'package:planning_poker_open/user_authentication/models/user_app.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticateAnonymously>(_authenticateAnonymously);
    on<AuthenticationInitialCheck>(_checkIfUserAlreadyAuthenticated);
    on<AuthenticationUpdateUserData>(_updateUserData);
  }

  AuthRepository authRepository = AuthRepository();

  Future<void> _checkIfUserAlreadyAuthenticated(
    AuthenticationInitialCheck event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final UserApp userApp = await authRepository.getCurrentUser();

      emit(AuthenticationAuthenticated(user: userApp));
    } catch (e) {
      emit(AuthenticationFailure());
    }
  }

  Future<void> _authenticateAnonymously(
    AuthenticateAnonymously event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationInProgress());

      final UserApp userApp =
          await authRepository.signInAnonymously(event.username);

      emit(AuthenticationAuthenticated(user: userApp));
    } catch (e) {
      emit(AuthenticationFailure());
    }
  }

  Future<void> _updateUserData(
    AuthenticationUpdateUserData event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(
      AuthenticationAuthenticated(
        user: event.userAppNewData,
      ),
    );
  }
}
