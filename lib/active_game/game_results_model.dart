import 'package:planning_poker_open/active_game/game_model.dart';
import 'package:planning_poker_open/active_game/player_card_selection.dart';

class HistoricGameResult {
  HistoricGameResult(
      {required this.id,
      required this.gameData,
      required this.selectionsCount,
      required this.selectionsResultData});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['game_data'] = gameData.toJson();
    map['selections_count'] = selectionsCount;
    map['selections_result_data'] =
        selectionsResultData.map((e) => e.toJson()).toList();
    return map;
  }

  final String id;
  final GameModel gameData;
  final int selectionsCount;
  final List<SelectionsResultData> selectionsResultData;
}

class SelectionsResultData {
  SelectionsResultData({
    required this.selection,
    required this.count,
    required this.totalPercentage,
  });

  factory SelectionsResultData.fromPlayerSelections(
      List<PlayerCardSelection> playerCardSelections, String selection) {
    final count = playerCardSelections
        .where((element) => element.selection == selection)
        .length;
    final totalPercentage = count / playerCardSelections.length;
    return SelectionsResultData(
        selection: selection, count: count, totalPercentage: totalPercentage);
  }

  factory SelectionsResultData.fromJson(Map<String, dynamic> json) =>
      SelectionsResultData(
        selection: json['selection'] as String,
        count: json['count'] as int,
        totalPercentage: json['total_percentage'] as double,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['selection'] = selection;
    map['count'] = count;
    map['total_percentage'] = totalPercentage;
    return map;
  }

  final String selection;
  final int count;
  final double totalPercentage;
}

class GameResult {
  GameResult(
      {required this.selectionsCount, required this.selectionsResultData});

  factory GameResult.fromJson(Map<String, dynamic> json) => GameResult(
        selectionsCount: json['selections_count'] as int,
        selectionsResultData: (json['selections_result_data'] as List)
            .map(
                (e) => SelectionsResultData.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['selections_count'] = selectionsCount;
    map['selections_result_data'] =
        selectionsResultData.map((e) => e.toJson()).toList();
    return map;
  }

  final int selectionsCount;
  final List<SelectionsResultData> selectionsResultData;
}
