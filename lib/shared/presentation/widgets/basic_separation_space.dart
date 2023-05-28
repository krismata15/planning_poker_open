import 'package:flutter/material.dart';
import 'package:planning_poker_open/shared/styles/basic_styles.dart';

class BasicSeparationSpace extends StatelessWidget {
  const BasicSeparationSpace.vertical({
    super.key,
    this.separationType = SeparationType.vertical,
    this.multiplier = 1,
  });

  const BasicSeparationSpace.horizontal({
    super.key,
    this.separationType = SeparationType.horizontal,
    this.multiplier = 1,
  });

  final SeparationType separationType;
  final double multiplier;

  @override
  Widget build(BuildContext context) {
    const double separation = BasicStyles.standardSeparationVertical;
    return separationType == SeparationType.vertical
        ? SizedBox(
            height: separation * multiplier,
          )
        : SizedBox(
            width: separation * multiplier,
          );
  }
}

enum SeparationType {
  vertical,
  horizontal,
}
