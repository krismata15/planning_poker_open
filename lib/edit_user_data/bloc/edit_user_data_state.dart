part of 'edit_user_data_bloc.dart';

sealed class EditUserDataState {}

final class EditUserDataInitial extends EditUserDataState {}

final class EditUserDataLoading extends EditUserDataState {}

final class EditUserDataSuccess extends EditUserDataState {
  EditUserDataSuccess({required this.userAppNewData});

  final UserApp userAppNewData;
}

final class EditUserDataFailure extends EditUserDataState {
  EditUserDataFailure({
    required this.message,
  });

  final String message;
}
