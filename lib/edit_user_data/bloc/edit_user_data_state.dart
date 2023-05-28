part of 'edit_user_data_bloc.dart';

@immutable
abstract class EditUserDataState {}

class EditUserDataInitial extends EditUserDataState {}

class EditUserDataLoading extends EditUserDataState {}

class EditUserDataSuccess extends EditUserDataState {
  EditUserDataSuccess({required this.userAppNewData});

  final UserApp userAppNewData;
}

class EditUserDataFailure extends EditUserDataState {
  EditUserDataFailure({
    required this.message,
  });

  final String message;
}
