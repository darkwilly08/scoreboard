import 'package:anotador/constants/const_variables.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const lightBackgroundColor = Color(0xFFFFFFFF);
  static const lightSurfaceColor = Color(0xFFFFFFFF);
  static const lightSecondaryColor = Color(0xFF018786);
  static const lightSecondaryDarkerColor = Color(0xFF018786);
  static const lightFontColor = Color(0xFF000000);
  static const backgroundColor = Color(0xFF121212);
  static const surfaceColor = Color(0xFF1E1E1E);
  static const secondaryColor = Color(0xFF63FFDB);
  static const secondaryDarkerColor = Color(0xFF03DAC5);
  static const fontColor = Color(0xFFE5E5E5);

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: lightFontColor),
      iconTheme: IconThemeData(color: lightFontColor),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: secondaryColor),
    textTheme: Typography.blackCupertino.apply(
      fontFamily: AppConstants.fontFamily,
    ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
          bodyColor: lightFontColor,
          fontFamily: AppConstants.fontFamily,
        ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: secondaryColor,
      brightness: Brightness.dark,
    ),
    textTheme: Typography.whiteHelsinki.apply(
      bodyColor: fontColor,
      fontFamily: AppConstants.fontFamily,
    ),
    primaryTextTheme: ThemeData.dark().textTheme.apply(
          fontFamily: AppConstants.fontFamily,
        ),
  );
}
