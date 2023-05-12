import 'package:equatable/equatable.dart';

class PlayerCardSelectionModel extends Equatable {
  const PlayerCardSelectionModel({
    required this.playerId,
    required this.selection,
  });

  factory PlayerCardSelectionModel.fromJson(Map<String, dynamic> json) =>
      PlayerCardSelectionModel(
        playerId: json['player_id'] as String,
        selection: json['selection'] as String,
      );
//koRw9IQylqhb99LK5ZPirbUvPXsy
  final String playerId;
  final String selection;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['player_id'] = playerId;
    map['selection'] = selection;
    return map;
  }

  @override
  List<Object?> get props => [playerId, selection];
}
