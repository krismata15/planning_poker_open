import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning_poker_open/user_authentication/auth_repository.dart';
import 'package:planning_poker_open/user_authentication/models/user_app.dart';

part 'edit_user_data_event.dart';
part 'edit_user_data_state.dart';

class EditUserDataBloc extends Bloc<EditUserDataEvent, EditUserDataState> {
  EditUserDataBloc() : super(EditUserDataInitial()) {
    on<EditUserData>(_editUserData);
  }

  AuthRepository authRepository = AuthRepository();

  Future<void> _editUserData(
      EditUserData event, Emitter<EditUserDataState> emit) async {
    try {
      emit(EditUserDataLoading());

      final UserApp userApp = await authRepository.editUserData(event.username);

      emit(EditUserDataSuccess(
        userAppNewData: userApp,
      ));
    } catch (e) {
      emit(EditUserDataFailure(message: e.toString()));
    }
  }
}
