import 'package:flutter/material.dart';

abstract class BasicStyles {
  static const double horizontalPadding = 32;
  static const double verticalPadding = 32;
  static const double standardSeparationVertical = 20;

  static const TextStyle barTitleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 20,
  );

  static const TextStyle simpleTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
}
