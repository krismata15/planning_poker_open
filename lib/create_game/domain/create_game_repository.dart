import 'package:planning_poker_open/create_game/data/sources/game_firebase_source.dart';
import 'package:planning_poker_open/create_game/domain/entities/deck_entity.dart';

class CreateGameRepository {
  final GameFirebaseSource gameFirebaseSource = GameFirebaseSource();

  Future<String> createGame(String deckId, String gameName) async {
    return gameFirebaseSource.createGame(deckId, gameName);
  }

  Future<List<DeckEntity>> getInitialDataForCreateGame() async {
    return (await gameFirebaseSource.getUserDecks())
        .map(DeckEntity.fromModel)
        .toList();
  }
}
