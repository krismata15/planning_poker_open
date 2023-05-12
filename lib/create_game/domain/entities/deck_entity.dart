import 'package:equatable/equatable.dart';
import 'package:planning_poker_open/create_game/data/models/deck_model.dart';

class DeckEntity extends Equatable {
  const DeckEntity(
      {required this.id, required this.name, required this.options});

  factory DeckEntity.fromJson(Map<String, dynamic> json) => DeckEntity(
        id: json['id'] as String,
        name: json['name'] as String,
        options: (json['options'] as List).map((e) => e as String).toList(),
      );

  factory DeckEntity.fromModel(DeckModel model) => DeckEntity(
        id: model.id!,
        name: model.name!,
        options: model.options!,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['options'] = options;
    return map;
  }

  final String id;
  final String name;
  final List<String> options;

  @override
  List<Object?> get props => [id];
}
