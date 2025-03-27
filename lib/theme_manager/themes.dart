import 'package:flutter/material.dart';

import 'colors.dart';

enum Themes { light, dark }

final lightTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: lightThemeScaffoldColor,
    textTheme: TextTheme(
        displayMedium: TextStyle(color: lightThemeDisplayMediumTextColor),
        displayLarge: TextStyle(color: lightThemeDisplayLargeTextColor),
        displaySmall: TextStyle(color: lightThemeDisplaySmallTextColor)),
    cardColor: lightThemeContainerColor);

final darkTheme =
    ThemeData(useMaterial3: false, scaffoldBackgroundColor: Colors.black);
