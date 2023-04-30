import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'create_game_event.dart';
part 'create_game_state.dart';

class CreateGameBloc extends Bloc<CreateGameEvent, CreateGameState> {
  CreateGameBloc() : super(CreateGameInitial()) {
    on<CreateGameEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
