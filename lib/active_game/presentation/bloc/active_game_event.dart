part of 'active_game_bloc.dart';

@immutable
abstract class ActiveGameEvent {}

class ActiveGameGetInitialData extends ActiveGameEvent {
  ActiveGameGetInitialData({required this.gameId});

  final String gameId;
}

class ActiveGameSelectOption extends ActiveGameEvent {
  ActiveGameSelectOption({required this.option});

  final String option;
}

class ActiveGameRevealCards extends ActiveGameEvent {}

class ActiveGameReset extends ActiveGameEvent {}
