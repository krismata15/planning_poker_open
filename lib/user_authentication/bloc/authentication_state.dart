part of 'authentication_bloc.dart';

sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationInProgress extends AuthenticationState {}

final class AuthenticationAuthenticated extends AuthenticationState
    with EquatableMixin {
  AuthenticationAuthenticated({required this.user});

  final UserApp user;

  @override
  List<Object?> get props => [user];
}

final class AuthenticationFailure extends AuthenticationState {}
