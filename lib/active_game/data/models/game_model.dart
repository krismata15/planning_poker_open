import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:planning_poker_open/active_game/data/models/game_results_model.dart';
import 'package:planning_poker_open/active_game/data/models/player_card_selection.dart';
import 'package:planning_poker_open/active_game/domain/entities/user_player_entity.dart';
import 'package:planning_poker_open/create_game/domain/entities/deck_entity.dart';

class GameModel extends Equatable {
  const GameModel({
    required this.id,
    required this.gameName,
    required this.activePlayers,
    required this.createdAt,
    required this.deck,
    required this.players,
    required this.playerCardSelections,
    required this.status,
    this.gameResult,
  });

  factory GameModel.fromJson(Map<String, dynamic> json, String id) => GameModel(
        id: id,
        gameName: json['name'] as String,
        activePlayers: json['active_players'] as int,
        createdAt: json['createdAt'].toString(),
        deck: DeckEntity.fromJson(json['deck'] as Map<String, dynamic>),
        players: (json['players'] as List)
            .map((e) => UserPlayerEntity.fromJson(e as Map<String, dynamic>))
            .toList(),
        playerCardSelections: (json['selections'] as List)
            .map((e) =>
                PlayerCardSelectionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        status: GameStatus.values
                .firstWhereOrNull((element) => element == json['status']) ??
            GameStatus.initial,
        gameResult: json['game_result'] != null
            ? GameResult.fromJson(json['game_result'] as Map<String, dynamic>)
            : null,
      );

  GameModel copyWith({
    String? id,
    String? gameName,
    int? activePlayers,
    String? createdAt,
    DeckEntity? deck,
    List<UserPlayerEntity>? players,
    List<PlayerCardSelectionModel>? playerCardSelections,
    GameStatus? status,
  }) {
    return GameModel(
      id: id ?? this.id,
      gameName: gameName ?? this.gameName,
      activePlayers: activePlayers ?? this.activePlayers,
      createdAt: createdAt ?? this.createdAt,
      deck: deck ?? this.deck,
      players: players ?? this.players,
      playerCardSelections: playerCardSelections ?? this.playerCardSelections,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = gameName;
    map['active_players'] = activePlayers;
    map['createdAt'] = createdAt;
    map['deck'] = deck.toJson();
    map['players'] = players.map((e) => e.toJson()).toList();
    map['selections'] = playerCardSelections.map((e) => e.toJson()).toList();
    map['status'] = status.index;
    map['game_result'] = gameResult?.toJson();
    return map;
  }

  final String id;
  final String gameName;
  final int activePlayers;
  final String createdAt;
  final DeckEntity deck;
  final List<UserPlayerEntity> players;
  final List<PlayerCardSelectionModel> playerCardSelections;
  final GameStatus status;
  final GameResult? gameResult;

  @override
  List<Object?> get props => [
        id,
        gameName,
        activePlayers,
        createdAt,
        deck,
        players,
        playerCardSelections,
        status
      ];

  @override
  bool get stringify {
    return true;
  }
}

enum GameStatus { initial, selections, revealing, revealed, error }

GameStatus gameStatusFromString(String status) {
  switch (status) {
    case 'initial':
      return GameStatus.initial;
    case 'selections':
      return GameStatus.selections;
    case 'revealing':
      return GameStatus.revealing;
    case 'revealed':
      return GameStatus.revealed;
    case 'error':
      return GameStatus.error;
    default:
      return GameStatus.initial;
  }
}
