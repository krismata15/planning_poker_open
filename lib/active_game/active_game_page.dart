import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning_poker_open/active_game/bloc/active_game_bloc.dart';
import 'package:planning_poker_open/active_game/player_card_selection.dart';
import 'package:planning_poker_open/active_game/user_player_entity.dart';
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
          child: BlocListener<ActiveGameBloc, ActiveGameState>(
            listener: (context, state) {
              print('Listening states $state');
            },
            child: BlocBuilder<ActiveGameBloc, ActiveGameState>(
              builder: (context, state) {
                if (state is ActiveGameUpdated) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        ),
                      ),
                      UserHandCards(
                        cardOptions: state.cards.options,
                        selection: state.selection,
                      ),
                    ],
                  );
                }

                return const Text('Error');
              },
            ),
          ),
        ),
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
              padding: const EdgeInsets.all(8.0),
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
  const Board({super.key, required this.selections, required this.players});

  final List<PlayerCardSelection> selections;
  final List<UserPlayerEntity> players;

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
                (player) => EmptyCardSelection(
                  player: player,
                  userSelection: player.userSelection(selections),
                ),
              )
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: const [
                /* EmptyCardSelection(),
                EmptyCardSelection(),*/
              ],
            ),
            const CardTable(),
            Column(
              children: const [
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
                (player) => EmptyCardSelection(
                  player: player,
                  userSelection: player.userSelection(selections),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class CardTable extends StatelessWidget {
  const CardTable({super.key});

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
        child: SelectableText(
          'Pick your cards!',
          style: BasicStyles.simpleTitleStyle.copyWith(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class EmptyCardSelection extends StatelessWidget {
  const EmptyCardSelection(
      {super.key, required this.player, this.userSelection});

  final UserPlayerEntity player;
  final String? userSelection;

//#/active-game/o532uOJ7DiYHudvjl8Eh
  @override
  Widget build(BuildContext context) {
    print(userSelection);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          userSelection != null
              ? OptionCard(
                  option: userSelection!,
                  selection: userSelection,
                )
              : Container(
                  height: cardHeight,
                  width: cardWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
          SizedBox(
            height: 4,
          ),
          SelectableText(
            player.name,
            style: TextStyle(
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
