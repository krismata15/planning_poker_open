import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning_poker_open/active_game/data/models/game_model.dart';
import 'package:planning_poker_open/active_game/data/models/game_results_model.dart';
import 'package:planning_poker_open/active_game/data/models/player_card_selection.dart';
import 'package:planning_poker_open/active_game/domain/entities/user_player_entity.dart';
import 'package:planning_poker_open/active_game/presentation/bloc/active_game_bloc.dart';
import 'package:planning_poker_open/shared/presentation/widgets/active_game_toolbar.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_separation_space.dart';
import 'package:planning_poker_open/shared/styles/basic_styles.dart';

class ActiveGamePage extends StatelessWidget {
  const ActiveGamePage({super.key, this.gameId});

  final String? gameId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActiveGameBloc(
        gameId: gameId!,
      )..add(ActiveGameGetInitialData(gameId: gameId!)),
      child: Scaffold(
        body: BlocBuilder<ActiveGameBloc, ActiveGameState>(
          builder: (context, state) {
            if (state is ActiveGameGettingInitialData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ActiveGameUpdated) {
              return Column(
                children: [
                  ActiveGameToolBar(
                    title: Text(
                      state.gameName,
                      style: BasicStyles.barTitleStyle,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        BasicStyles.horizontalPadding,
                        BasicStyles.verticalPadding,
                        BasicStyles.horizontalPadding,
                        12,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 40,
                              ),
                              child: Board(
                                players: state.players,
                                selections: state.playerCardSelections,
                                gameStatus: state.gameStatus,
                              ),
                            ),
                          ),
                          if (state.gameStatus != GameStatus.revealed)
                            UserHandCards(
                              cardOptions: state.cards.options,
                              selection: state.selection,
                              gameStatus: state.gameStatus,
                            ),
                          if (state.gameStatus == GameStatus.revealed &&
                              state.gameResult != null)
                            SelectionsResultView(
                              gameResult: state.gameResult!,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SelectableText('Error');
          },
        ),
      ),
    );
  }
}

class SelectionsResultView extends StatelessWidget {
  const SelectionsResultView({
    super.key,
    required this.gameResult,
  });

  final GameResult gameResult;

  ({double? average, double agreement}) _computeStats() {
    final data = gameResult.selectionsResultData;
    if (data.isEmpty) return (average: null, agreement: 0);

    double totalNumeric = 0;
    int numericCount = 0;
    for (final result in data) {
      final value = double.tryParse(result.selection);
      if (value != null) {
        totalNumeric += value * result.count;
        numericCount += result.count;
      }
    }

    final average = numericCount > 0 ? totalNumeric / numericCount : null;

    final maxPercentage = data
        .map((d) => d.totalPercentage)
        .reduce((a, b) => a > b ? a : b);

    return (average: average, agreement: maxPercentage);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final stats = _computeStats();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...gameResult.selectionsResultData.map(
            (resultData) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: cardHeight,
                  width: 6,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: resultData.totalPercentage,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: cardHeight,
                  width: cardWidth,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: SelectableText(
                      resultData.selection,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SelectableText(
                  '${resultData.count} Vote',
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          _VoteSummaryCard(
            average: stats.average,
            agreement: stats.agreement,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

class _VoteSummaryCard extends StatelessWidget {
  const _VoteSummaryCard({
    required this.average,
    required this.agreement,
    required this.colorScheme,
  });

  final double? average;
  final double agreement;
  final ColorScheme colorScheme;

  String _formatAverage(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  String _agreementLabel(double value) {
    if (value >= 1.0) return 'Full consensus';
    if (value >= 0.7) return 'High agreement';
    if (value >= 0.5) return 'Moderate';
    return 'Low agreement';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (average != null) ...[
            Text(
              _formatAverage(average!),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Average',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ] else
            Text(
              'N/A',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: agreement >= 0.7
                  ? Colors.green.withOpacity(0.1)
                  : agreement >= 0.5
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _agreementLabel(agreement),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: agreement >= 0.7
                    ? Colors.green.shade700
                    : agreement >= 0.5
                        ? Colors.orange.shade700
                        : Colors.red.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserHandCards extends StatelessWidget {
  const UserHandCards({
    super.key,
    required this.cardOptions,
    required this.gameStatus,
    this.selection,
  });

  final List<String> cardOptions;
  final PlayerCardSelectionModel? selection;
  final GameStatus gameStatus;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        primary: true,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cardOptions
                .map(
                  (option) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: OptionCard(
                      option: option,
                      selection: selection?.selection,
                      enableSelection: gameStatus == GameStatus.selections ||
                          gameStatus == GameStatus.initial,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class OptionCardHidden extends StatelessWidget {
  const OptionCardHidden({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class OptionCard extends StatefulWidget {
  const OptionCard({
    super.key,
    required this.option,
    required this.enableSelection,
    this.selection,
  });

  final String option;
  final String? selection;
  final bool enableSelection;

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {
  bool isHover = false;
  String? localSelection;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.selection == widget.option;
    return MouseRegion(
      cursor: widget.enableSelection
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        if (widget.enableSelection) {
          setState(() {
            isHover = true;
          });
        }
      },
      onExit: (_) {
        if (widget.enableSelection) {
          setState(() {
            isHover = false;
          });
        }
      },
      child: GestureDetector(
        onTap: widget.enableSelection
            ? () {
                context
                    .read<ActiveGameBloc>()
                    .add(ActiveGameSelectOption(option: widget.option));
              }
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: cardHeight,
              width: cardWidth,
              decoration: BoxDecoration(
                color: isSelected && !widget.enableSelection
                    ? Colors.grey
                    : isSelected
                        ? Colors.blue
                        : isHover
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.white,
                border: Border.all(
                  color: !widget.enableSelection ? Colors.grey : Colors.blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  widget.option,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? Colors.white
                        : !widget.enableSelection
                            ? Colors.grey
                            : Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef TableDistribution = ({
  List<UserPlayerEntity> top,
  List<UserPlayerEntity> bottom,
  List<UserPlayerEntity> left,
  List<UserPlayerEntity> right,
});

class Board extends StatelessWidget {
  const Board({
    super.key,
    required this.selections,
    required this.players,
    required this.gameStatus,
  });

  final List<PlayerCardSelectionModel> selections;
  final List<UserPlayerEntity> players;
  final GameStatus gameStatus;

  static TableDistribution distributePlayers(List<UserPlayerEntity> players) {
    final sorted = List<UserPlayerEntity>.from(players)
      ..sort((a, b) => a.position.compareTo(b.position));
    final n = sorted.length;

    int leftCount = 0;
    int rightCount = 0;
    if (n > 4) leftCount = 1;
    if (n > 5) rightCount = 1;
    if (n > 8) leftCount = 2;
    if (n > 9) rightCount = 2;

    final remaining = n - leftCount - rightCount;
    final bottomCount = (remaining + 1) ~/ 2;
    final topCount = remaining - bottomCount;

    int i = 0;
    final bottom = sorted.sublist(i, i + bottomCount);
    i += bottomCount;
    final top = sorted.sublist(i, i + topCount);
    i += topCount;
    final left = sorted.sublist(i, i + leftCount);
    i += leftCount;
    final right = sorted.sublist(i, min(i + rightCount, n));

    return (top: top, bottom: bottom, left: left, right: right);
  }

  Widget _buildCard(UserPlayerEntity player) {
    return CardOnBoardElement(
      player: player,
      userSelection: player.userSelection(selections),
      gameStatus: gameStatus,
    );
  }

  static const double _sideSlotWidth = 90;

  @override
  Widget build(BuildContext context) {
    final dist = distributePlayers(players);
    final bool hasSides =
        dist.left.isNotEmpty || dist.right.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dist.top.map(_buildCard).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasSides)
              SizedBox(
                width: _sideSlotWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dist.left.map(_buildCard).toList(),
                ),
              ),
            CardTable(gameStatus: gameStatus),
            if (hasSides)
              SizedBox(
                width: _sideSlotWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dist.right.map(_buildCard).toList(),
                ),
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dist.bottom.map(_buildCard).toList(),
        ),
      ],
    );
  }
}

class CardTable extends StatelessWidget {
  const CardTable({super.key, required this.gameStatus});

  final GameStatus gameStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 320,
      decoration: BoxDecoration(
        color: Colors.blue.shade100.withOpacity(0.8),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: gameStatus == GameStatus.initial
            ? SelectableText(
                'Pick your cards!',
                style: BasicStyles.simpleTitleStyle.copyWith(
                  fontSize: 16,
                ),
              )
            : gameStatus == GameStatus.selections
                ? ElevatedButton(
                    onPressed: () {
                      context
                          .read<ActiveGameBloc>()
                          .add(ActiveGameRevealCards());
                    },
                    child: const Text('Reveal Cards'),
                  )
                : gameStatus == GameStatus.revealing
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : gameStatus == GameStatus.revealed
                        ? ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ActiveGameBloc>()
                                  .add(ActiveGameReset());
                            },
                            child: const Text('Start New Voting'),
                          )
                        : const SelectableText('Error loading game status'),
      ),
    );
  }
}

class CardOnBoardElement extends StatelessWidget {
  const CardOnBoardElement({
    super.key,
    required this.player,
    required this.gameStatus,
    this.userSelection,
  });

  final UserPlayerEntity player;
  final String? userSelection;
  final GameStatus gameStatus;

//#/active-game/o532uOJ7DiYHudvjl8Eh
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (gameStatus == GameStatus.revealed && userSelection != null)
            OptionCard(
              option: userSelection!,
              selection: userSelection,
              enableSelection: true,
            )
          else
            userSelection == null
                ? Container(
                    height: cardHeight,
                    width: cardWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                : const OptionCardHidden(),
          const BasicSeparationSpace.vertical(
            multiplier: 0.5,
          ),
          SelectableText(
            player.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

const double cardWidth = 46;
const double cardHeight = 80;
