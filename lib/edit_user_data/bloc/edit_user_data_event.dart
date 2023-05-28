part of 'edit_user_data_bloc.dart';

@immutable
abstract class EditUserDataEvent {}

class EditUserData extends EditUserDataEvent {
  EditUserData({
    required this.username,
  });

  final String username;
}
