part of 'active_game_bloc.dart';

sealed class ActiveGameEvent {}

final class ActiveGameGetInitialData extends ActiveGameEvent {
  ActiveGameGetInitialData({required this.gameId});

  final String gameId;
}

final class ActiveGameSelectOption extends ActiveGameEvent {
  ActiveGameSelectOption({required this.option});

  final String option;
}

final class ActiveGameRevealCards extends ActiveGameEvent {}

final class ActiveGameReset extends ActiveGameEvent {}
