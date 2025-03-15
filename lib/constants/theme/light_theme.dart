import 'package:flutter/material.dart';
import '../colors.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        titleTextStyle: TextStyle(
          color: primaryFontColor,
        )),
    colorScheme: const ColorScheme.light(
      surface: Colors.white,
      primary: primaryColor,
      secondary: secondryColor,
      tertiary: Color(0xFFF3F2F2),
      scrim: scrimColor,
    ));
