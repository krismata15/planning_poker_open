import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planning_poker_open/basic_separation_bloc.dart';
import 'package:planning_poker_open/routes_names.dart';
import 'package:planning_poker_open/styles/basic_styles.dart';

class CreateNewGamePage extends StatefulWidget {
  const CreateNewGamePage({super.key});

  @override
  State<CreateNewGamePage> createState() => _CreateNewGamePageState();
}

class _CreateNewGamePageState extends State<CreateNewGamePage> {
  String gamesName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: BasicStyles.horizontalPadding,
          vertical: BasicStyles.verticalPadding,
        ),
        child: Column(
          children: [
            Row(
              children: const [
                SelectableText(
                  'Create game',
                  style: BasicStyles.barTitleStyle,
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  DropdownButtonHideUnderline(
                    child: DropdownButtonFormField2(
                      decoration: InputDecoration(
                        isDense: true,
                        label: const Text('Voting system'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: Theme.of(context)
                            .inputDecorationTheme
                            .contentPadding,
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        offset: Offset(0, -10),
                        padding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {},
                      items: const [
                        DropdownMenuItem(
                          value: 'fibonacci',
                          child: Text('Fibonacci'),
                        ),
                        DropdownMenuItem(
                          value: 't-shirt',
                          child: Text('T-Shirt'),
                        ),
                      ],
                    ),
                  ),
                  const BasicSeparationSpace.vertical(
                    multiplier: 2,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.7, 50),
                    ),
                    onPressed: () {
                      context.goNamed(RoutesNames.activeGame);
                    },
                    child: const Text('Create game'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
