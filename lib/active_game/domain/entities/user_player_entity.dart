import 'package:collection/collection.dart';
import 'package:planning_poker_open/active_game/data/models/player_card_selection.dart';

class UserPlayerEntity {
  UserPlayerEntity({
    required this.id,
    required this.name,
    required this.position,
  });

  factory UserPlayerEntity.fromJson(Map<String, dynamic> json) =>
      UserPlayerEntity(
        id: json['id'] as String,
        name: json['name'] as String,
        position: json['position'] as int,
      );

  final String id;
  final String name;
  final int position;

  String? userSelection(List<PlayerCardSelectionModel> selections) {
    return selections
        .firstWhereOrNull((element) => element.playerId == id)
        ?.selection;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['position'] = position;
    return map;
  }
}
