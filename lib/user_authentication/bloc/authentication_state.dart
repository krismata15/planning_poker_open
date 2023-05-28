part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationInProgress extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState
    with EquatableMixin {
  AuthenticationAuthenticated({required this.user});

  final UserApp user;

  @override
  List<Object?> get props => [user];
}

class AuthenticationFailure extends AuthenticationState {}
