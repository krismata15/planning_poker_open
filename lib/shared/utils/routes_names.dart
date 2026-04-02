abstract class RoutesNames {
  static const String home = '/';
  static const String login = 'login';
  static const String createGame = 'new-game';
  static const String activeGame = 'active-game';
  static const String myGames = 'my-games';
}

abstract class RoutesPaths {
  static const String home = '/';
  static const String login = '/login';
  static const String createGame = '/new-game';
  static const String activeGame = '/active-game/:gameId';
  static const String myGames = '/my-games';
}

const List<String> guardedPaths = [
  RoutesPaths.createGame,
  RoutesPaths.activeGame,
  RoutesPaths.myGames,
];
