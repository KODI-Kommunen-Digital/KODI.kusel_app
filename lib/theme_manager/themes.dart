import 'package:flutter/material.dart';

import 'colors.dart';

enum Themes { light, dark }

final lightTheme = ThemeData(
  useMaterial3: false,
  scaffoldBackgroundColor: lightThemeScaffoldColor,
  cardColor: lightThemePrimaryColor,
  shadowColor: lightThemeShadowColor,
  textTheme: TextTheme(
    displayMedium: TextStyle(
      color: lightThemeTextColor
    )
  ),
  hintColor: lightThemeHintTextColor,
  focusColor: lightThemePrimaryColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: lightThemePrimaryColor)
  )
);

final darkTheme = ThemeData(
  useMaterial3: false,
  scaffoldBackgroundColor: Colors.black
);
