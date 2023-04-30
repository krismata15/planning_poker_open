import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning_poker_open/user_authentication/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticateAnonymously>(_authenticateAnonymously);
  }

  AuthRepository authRepository = AuthRepository();

  Future<void> _authenticateAnonymously(
    AuthenticateAnonymously event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationInProgress());

      await authRepository.signInAnonymously(event.username);

      emit(AuthenticationSuccess(username: event.username));
    } catch (e) {
      emit(AuthenticationFailure());
    }
  }
}
