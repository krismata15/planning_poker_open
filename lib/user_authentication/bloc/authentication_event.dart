part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticateAnonymously extends AuthenticationEvent {
  AuthenticateAnonymously({required this.username});

  final String username;
}
