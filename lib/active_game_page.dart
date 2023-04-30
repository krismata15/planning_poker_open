import 'package:flutter/material.dart';

class ActiveGamePage extends StatelessWidget {
  const ActiveGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Game name'),
              Text('Username'),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          Board(),
          UserHandCards(),
        ],
      ),
    );
  }
}

class UserHandCards extends StatelessWidget {
  const UserHandCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OptionCard(),
        OptionCard(),
        OptionCard(),
        OptionCard(),
        OptionCard(),
      ],
    );
  }
}

class OptionCard extends StatelessWidget {
  const OptionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: cardHeight,
          width: cardWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.blue,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: SelectableText('1'),
          ),
        ),
        SelectableText('player name'),
      ],
    );
  }
}

class Board extends StatelessWidget {
  const Board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyCardSelection(),
            EmptyCardSelection(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                EmptyCardSelection(),
                EmptyCardSelection(),
              ],
            ),
            CardTable(),
            Column(
              children: [
                EmptyCardSelection(),
                EmptyCardSelection(),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyCardSelection(),
          ],
        ),
      ],
    );
  }
}

class CardTable extends StatelessWidget {
  const CardTable({Key? key}) : super(key: key);

  final int playersQuantity = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: SelectableText('Pick your cards'),
      ),
    );
  }
}

class EmptyCardSelection extends StatelessWidget {
  const EmptyCardSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: cardHeight,
          width: cardWidth,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SelectableText('player name'),
      ],
    );
  }
}

final double cardWidth = 40;
final double cardHeight = 60;
