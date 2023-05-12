import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning_poker_open/active_game/data/models/game_model.dart';
import 'package:planning_poker_open/active_game/data/models/game_results_model.dart';
import 'package:planning_poker_open/active_game/data/models/player_card_selection.dart';
import 'package:planning_poker_open/active_game/domain/entities/user_player_entity.dart';
import 'package:planning_poker_open/active_game/presentation/bloc/active_game_bloc.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_separation_bloc.dart';
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
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BasicStyles.horizontalPadding,
            vertical: BasicStyles.verticalPadding,
          ),
          child: BlocBuilder<ActiveGameBloc, ActiveGameState>(
            builder: (context, state) {
              if (state is ActiveGameGettingInitialData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ActiveGameUpdated) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.gameName,
                          style: BasicStyles.barTitleStyle,
                        ),
                        Text(
                          state.activeUser.name,
                          style: BasicStyles.titleStyle,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Board(
                        players: state.players,
                        selections: state.playerCardSelections,
                        gameStatus: state.gameStatus,
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
                );
              }

              return const Text('Error');
            },
          ),
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

  @override
  Widget build(BuildContext context) {
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
                    child: Text(
                      resultData.selection,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Text(
                  '${resultData.count} Vote',
                ),
              ],
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

class OptionCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final bool isSelected = selection == option;
    return GestureDetector(
      onTap: enableSelection
          ? () {
              context
                  .read<ActiveGameBloc>()
                  .add(ActiveGameSelectOption(option: option));
            }
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: cardHeight,
            width: cardWidth,
            decoration: BoxDecoration(
              color: isSelected && !enableSelection
                  ? Colors.grey
                  : isSelected
                      ? Colors.blue
                      : Colors.white,
              border: Border.all(
                color: !enableSelection ? Colors.grey : Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : !enableSelection
                          ? Colors.grey
                          : Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    final bottomPlayers =
        players.where((element) => element.position.isOdd).toList();
    final topPlayers =
        players.where((element) => element.position.isEven).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: topPlayers
              .map(
                (player) => CardOnBoardElement(
                  player: player,
                  userSelection: player.userSelection(selections),
                  gameStatus: gameStatus,
                ),
              )
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Column(
              children: [
                /* EmptyCardSelection(),
                EmptyCardSelection(),*/
              ],
            ),
            CardTable(
              gameStatus: gameStatus,
            ),
            const Column(
              children: [
                /*EmptyCardSelection(),
                EmptyCardSelection(),*/
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bottomPlayers
              .map(
                (player) => CardOnBoardElement(
                  player: player,
                  userSelection: player.userSelection(selections),
                  gameStatus: gameStatus,
                ),
              )
              .toList(),
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
      width: 300,
      decoration: BoxDecoration(
        color: Colors.blue.shade200.withOpacity(0.8),
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
                  fontSize: 14,
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
                        : const Text('Error loading game status'),
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

const double cardWidth = 40;
const double cardHeight = 68;
