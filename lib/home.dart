import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/routes_names.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('This is de home page'),
          ElevatedButton(
            onPressed: () {
              context.goNamed(RoutesNames.createGame);
            },
            child: const Text('Create new game'),
          ),
        ],
      ),
    ));
  }
}
