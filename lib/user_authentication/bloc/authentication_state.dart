part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationInProgress extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState with EquatableMixin {
  AuthenticationSuccess({required this.username});

  final String username;

  @override
  List<Object?> get props => [username];
}

class AuthenticationFailure extends AuthenticationState {}
