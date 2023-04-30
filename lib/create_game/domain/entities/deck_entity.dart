import 'package:equatable/equatable.dart';
import 'package:planning_poker_open/create_game/data/models/deck_model.dart';

class DeckEntity extends Equatable {
  const DeckEntity(
      {required this.id, required this.name, required this.options});

  factory DeckEntity.fromModel(DeckModel model) => DeckEntity(
        id: model.id!,
        name: model.name!,
        options: model.options!,
      );

  final String id;
  final String name;
  final List<String> options;

  @override
  List<Object?> get props => [id];
}
