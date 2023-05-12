import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planning_poker_open/active_game/data/sources/game_data_source.dart';

class ActiveGameRepository {
  final GameDataSource _gameDataSource = GameDataSource();

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getActiveGame(
    String gameId,
  ) async {
    return _gameDataSource.getActiveGame(gameId);
  }

  Future<void> selectOption(String gameId, String option) async {
    await _gameDataSource.selectOption(gameId, option);
  }

  Future<void> revealCards(String gameId) async {
    await _gameDataSource.revealCards(gameId);
  }

  Future<void> resetGameSelections(String gameId) async {
    await _gameDataSource.resetGameSelections(gameId);
  }
}
