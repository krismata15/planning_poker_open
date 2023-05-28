part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationInitialCheck extends AuthenticationEvent {}

class AuthenticateAnonymously extends AuthenticationEvent {
  AuthenticateAnonymously({required this.username});

  final String username;
}

class AuthenticationUpdateUserData extends AuthenticationEvent {
  AuthenticationUpdateUserData({required this.userAppNewData});

  final UserApp userAppNewData;
}
