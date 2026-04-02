part of 'edit_user_data_bloc.dart';

sealed class EditUserDataEvent {}

final class EditUserData extends EditUserDataEvent {
  EditUserData({
    required this.username,
  });

  final String username;
}
