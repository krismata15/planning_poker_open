import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning_poker_open/active_game/bloc/active_game_bloc.dart';
import 'package:planning_poker_open/active_game/game_model.dart';
import 'package:planning_poker_open/active_game/game_results_model.dart';
import 'package:planning_poker_open/active_game/player_card_selection.dart';
import 'package:planning_poker_open/active_game/user_player_entity.dart';
import 'package:planning_poker_open/basic_separation_bloc.dart';
import 'package:planning_poker_open/styles/basic_styles.dart';

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
    this.selection,
  });

  final List<String> cardOptions;
  final PlayerCardSelection? selection;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cardOptions
          .map(
            (option) => Padding(
              padding: const EdgeInsets.all(8),
              child: OptionCard(
                option: option,
                selection: selection?.selection,
              ),
            ),
          )
          .toList(),
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
  const OptionCard({super.key, required this.option, this.selection});

  final String option;
  final String? selection;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selection == option;
    return GestureDetector(
      onTap: () {
        context
            .read<ActiveGameBloc>()
            .add(ActiveGameSelectOption(option: option));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: cardHeight,
            width: cardWidth,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.white,
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.blue,
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
  const Board(
      {super.key,
      required this.selections,
      required this.players,
      required this.gameStatus});

  final List<PlayerCardSelection> selections;
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
    print('Game status $gameStatus');
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
                    ? const Text('Loading')
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

final double cardWidth = 40;
final double cardHeight = 68;
