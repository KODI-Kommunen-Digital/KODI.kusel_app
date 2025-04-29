import 'package:flutter/material.dart';

import 'colors.dart';

enum Themes { light, dark }

final lightTheme = ThemeData(
  useMaterial3: false,
  scaffoldBackgroundColor: lightThemeScaffoldColor,
  primaryColor: lightThemePrimaryColor,
  canvasColor: lightThemeWhiteColor,
  indicatorColor: lightThemeSelectedItemColor,
  splashColor: lightThemeShimmerColor,
  colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: lightThemePrimaryColor,
      onPrimary: lightThemeFeedbackCardColor,
      secondary: lightThemeSecondaryColor,
      onSecondary: lightThemeScaffoldBackgroundColor,
      error: lightThemeErrorToastColor,
      onError: lightThemeErrorToastColor,
      surface: lightThemeCalendarIconColor,
      onSurface: lightThemeSuccessToastColor,
      onTertiaryFixed: lightThemeMapMarkerColor),
  textTheme: TextTheme(
      displayMedium: TextStyle(color: lightThemeDisplayMediumTextColor),
      displayLarge: TextStyle(color: lightThemeDisplayLargeTextColor),
      displaySmall: TextStyle(color: lightThemeDisplaySmallTextColor),
      labelLarge: TextStyle(color: lightThemeSecondaryColor),
      labelMedium: TextStyle(color: lightThemeTemperatureColor)),
  cardTheme: CardTheme(
    color: lightThemeCardGreyColor,
  ),
  hintColor: lightThemeHintColor,
  dividerColor: lightThemeDividerColor,
  cardColor: lightThemeContainerColor,
);

final darkTheme =
    ThemeData(useMaterial3: false, scaffoldBackgroundColor: Colors.black);
