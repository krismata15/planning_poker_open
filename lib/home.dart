import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_separation_space.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_toolbar.dart';
import 'package:planning_poker_open/shared/styles/basic_styles.dart';
import 'package:planning_poker_open/shared/utils/routes_names.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const BasicToolBar(
              showCreateNewGameButton: true,
            ),
            const Text(
              'Free Scrum Poker for agile development teams',
              style: BasicStyles.titleStyle,
            ),
            const Text('Use it for free or deploy your own version'),
            const BasicSeparationSpace.horizontal(),
            ElevatedButton(
              onPressed: () {
                context.goNamed(RoutesNames.createGame);
              },
              child: const Text('Create new game'),
            ),
          ],
        ),
      ),
    );
  }
}
