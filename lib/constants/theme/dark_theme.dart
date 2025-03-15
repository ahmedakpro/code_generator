import 'package:flutter/material.dart';

import '../colors.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.white,
    secondary: Color(0xFFF3F2F2),
    tertiary: secondryColor,
    scrim: Colors.grey,
  ),
);
