import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/create_game/domain/entities/deck_entity.dart';
import 'package:planning_poker_open/create_game/presentation/bloc/create_game_bloc.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_separation_bloc.dart';
import 'package:planning_poker_open/shared/styles/basic_styles.dart';
import 'package:planning_poker_open/shared/utils/routes_names.dart';

class CreateNewGamePage extends StatefulWidget {
  const CreateNewGamePage({super.key});

  @override
  State<CreateNewGamePage> createState() => _CreateNewGamePageState();
}

class _CreateNewGamePageState extends State<CreateNewGamePage> {
  String gamesName = '';
  List<DeckEntity>? decks;
  String? selectedDeckId;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool createGame = gamesName.isNotEmpty && selectedDeckId != null;
    return BlocProvider(
      create: (context) =>
          CreateGameBloc()..add(GetInitialDataForCreatingGame()),
      child: BlocListener<CreateGameBloc, CreateGameState>(
        listener: (context, state) {
          if (state is CreateGameGotInitialData) {
            setState(() {
              decks = state.decks;
              selectedDeckId ??= decks!.last.id;
            });
          }

          if (state is CreateGameInProgress) {
            setState(() {
              isLoading = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }

          if (state is CreateGameSuccess) {
            context.goNamed(
              RoutesNames.activeGame,
              pathParameters: {
                'gameId': state.gameId,
              },
            );
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: BasicStyles.horizontalPadding,
              vertical: BasicStyles.verticalPadding,
            ),
            child: BlocBuilder<CreateGameBloc, CreateGameState>(
              buildWhen: (previous, current) {
                return current is! CreateGameInProgress;
              },
              builder: (context, state) {
                if (state is CreateGameGettingInitialData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is CreateGameGotInitialData) {
                  return Column(
                    children: [
                      const Row(
                        children: [
                          SelectableText(
                            'Create game',
                            style: BasicStyles.barTitleStyle,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SelectableText(
                              'Choose a name and a voting system for your game.',
                              textAlign: TextAlign.center,
                              style: BasicStyles.simpleTitleStyle,
                            ),
                            const BasicSeparationSpace.vertical(
                              multiplier: 2,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                label: Text('Game name'),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  gamesName = value;
                                });
                              },
                            ),
                            const BasicSeparationSpace.vertical(
                              multiplier: 1.5,
                            ),
                            LayoutBuilder(
                              builder: (BuildContext context, constraints) {
                                return DropdownMenu(
                                  width: constraints.maxWidth,
                                  onSelected: (String? value) {
                                    setState(() {
                                      selectedDeckId = value;
                                    });
                                  },
                                  initialSelection: selectedDeckId,
                                  label: const Text('Voting system'),
                                  dropdownMenuEntries: decks!
                                      .map(
                                        (deck) => DropdownMenuEntry(
                                          value: deck.id,
                                          label:
                                              '${deck.name} ( ${deck.options.join(', ')} )',
                                        ),
                                      )
                                      .toList(),
                                );
                              },
                            ),
                            const BasicSeparationSpace.vertical(
                              multiplier: 2,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.7,
                                  50,
                                ),
                              ),
                              onPressed: isLoading
                                  ? () {}
                                  : createGame
                                      ? () {
                                          context.read<CreateGameBloc>().add(
                                                CreateGame(
                                                  deckId: selectedDeckId!,
                                                  gameName: gamesName,
                                                ),
                                              );
                                        }
                                      : null,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Create game'),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }

                if (state is CreateGameSuccess) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return const Center(
                  child: Text('Error in creating game'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
