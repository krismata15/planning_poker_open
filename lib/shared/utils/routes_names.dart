abstract class RoutesNames {
  static const String home = '/';
  static const String login = 'login';
  static const String createGame = 'new-game';
  static const String activeGame = 'active-game';
}

abstract class RoutesPaths {
  static const String home = '/';
  static const String login = '/login';
  static const String createGame = '/new-game';
  static const String activeGame = '/active-game/:gameId';
}

const List<String> guardedPaths = [
  RoutesPaths.createGame,
  RoutesPaths.activeGame,
];
