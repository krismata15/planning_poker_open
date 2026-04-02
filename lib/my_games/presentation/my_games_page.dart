import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/my_games/presentation/bloc/my_games_bloc.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_toolbar.dart';
import 'package:planning_poker_open/shared/styles/basic_styles.dart';
import 'package:planning_poker_open/shared/utils/routes_names.dart';

class MyGamesPage extends StatelessWidget {
  const MyGamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => MyGamesBloc()..add(LoadMyGames()),
      child: Scaffold(
        body: Column(
          children: [
            const BasicToolBar(
              title: SelectableText(
                'My games',
                style: BasicStyles.barTitleStyle,
              ),
              showCreateNewGameButton: true,
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BasicStyles.horizontalPadding,
                    vertical: BasicStyles.verticalPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: BlocBuilder<MyGamesBloc, MyGamesState>(
                      builder: (context, state) {
                        if (state is MyGamesLoading ||
                            state is MyGamesInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is MyGamesError) {
                          return Center(
                            child: SelectableText(
                              'Error loading games: ${state.message}',
                            ),
                          );
                        }

                        if (state is MyGamesLoaded) {
                          if (state.games.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.videogame_asset_off_outlined,
                                    size: 64,
                                    color: colorScheme.outlineVariant,
                                  ),
                                  const SizedBox(height: 16),
                                  SelectableText(
                                    'No previous games found.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  SelectableText(
                                    'Create a new game to get started!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.games.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final game = state.games[index];
                              return Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: colorScheme.outlineVariant,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    context.goNamed(
                                      RoutesNames.activeGame,
                                      pathParameters: {'gameId': game.id},
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: colorScheme.primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.style_outlined,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                game.gameName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Status: ${game.status.name} • Active players: ${game.activePlayers}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Icon(
                                          Icons.chevron_right,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
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
