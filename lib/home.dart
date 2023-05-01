import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/basic_separation_bloc.dart';
import 'package:planning_poker_open/routes_names.dart';
import 'package:planning_poker_open/styles/basic_styles.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is de home page',
              style: BasicStyles.titleStyle,
            ),
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
