part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {}

final class AuthenticationInitialCheck extends AuthenticationEvent {}

final class AuthenticateAnonymously extends AuthenticationEvent {
  AuthenticateAnonymously({required this.username});

  final String username;
}

final class AuthenticationUpdateUserData extends AuthenticationEvent {
  AuthenticationUpdateUserData({required this.userAppNewData});

  final UserApp userAppNewData;
}
