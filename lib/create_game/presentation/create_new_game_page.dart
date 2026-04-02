import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/create_game/domain/entities/deck_entity.dart';
import 'package:planning_poker_open/create_game/presentation/bloc/create_game_bloc.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_separation_space.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_toolbar.dart';
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
          body: BlocBuilder<CreateGameBloc, CreateGameState>(
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
                final colorScheme = Theme.of(context).colorScheme;
                return Column(
                  children: [
                    const BasicToolBar(
                      title: SelectableText(
                        'Create game',
                        style: BasicStyles.barTitleStyle,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: BasicStyles.horizontalPadding,
                            vertical: BasicStyles.verticalPadding,
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 480),
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Icon(
                                      Icons.style_outlined,
                                      size: 48,
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'New Game',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Choose a name and a voting system for your game.',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                    const SizedBox(height: 32),
                                    TextField(
                                      decoration: const InputDecoration(
                                        label: Text('Game name'),
                                        prefixIcon:
                                            Icon(Icons.edit_outlined),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          gamesName = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    LayoutBuilder(
                                      builder: (BuildContext context,
                                          constraints) {
                                        return DropdownMenu(
                                          width: constraints.maxWidth,
                                          leadingIcon: const Icon(
                                              Icons.category_outlined),
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
                                    const SizedBox(height: 32),
                                    FilledButton.icon(
                                      icon: isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Icon(Icons.play_arrow),
                                      label: const Text('Create game'),
                                      style: FilledButton.styleFrom(
                                        minimumSize:
                                            const Size(double.infinity, 52),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: isLoading
                                          ? null
                                          : createGame
                                              ? () {
                                                  context
                                                      .read<CreateGameBloc>()
                                                      .add(
                                                        CreateGame(
                                                          deckId:
                                                              selectedDeckId!,
                                                          gameName: gamesName,
                                                        ),
                                                      );
                                                }
                                              : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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
    );
  }
}
