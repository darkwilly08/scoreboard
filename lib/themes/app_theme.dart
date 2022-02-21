import 'package:anotador/constants/const_variables.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const lightBackgroundColor = Color(0xFFFFFFFF);
  static const lightSurfaceColor = Color(0xFFFFFFFF);
  static const lightSecondaryColor = Color(0xFF018786 /*0xFF03DAC6*/);
  static const lightSecondaryDarkerColor = Color(0xFF018786);
  static const lightFontColor = Color(0xFF000000);
  static const backgroundColor = Color(0xFF121212);
  static const surfaceColor = Color(0xFF1E1E1E);
  static const secondaryColor = Color(0xFF63FFDB);
  static const secondaryDarkerColor = Color(0xFF03DAC5);
  static const fontColor = Color(0xFFE5E5E5);
  static final ThemeData lightTheme = ThemeData.light().copyWith(
      backgroundColor: lightBackgroundColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      canvasColor: lightSurfaceColor,
      cardColor: lightSurfaceColor,
      dialogBackgroundColor: lightSurfaceColor,
      toggleableActiveColor: lightSecondaryColor,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(foregroundColor: lightBackgroundColor),
      colorScheme: ColorScheme.light().copyWith(
        primary: lightSurfaceColor,
        primaryVariant: lightBackgroundColor,
        secondary: lightSecondaryColor,
        secondaryVariant: lightSecondaryDarkerColor,
      ),
      textTheme:
          Typography.blackCupertino.apply(fontFamily: AppConstants.fontFamily),
      primaryTextTheme: ThemeData.light().textTheme.apply(
            fontFamily: AppConstants.fontFamily,
          ));
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      backgroundColor: backgroundColor,
      scaffoldBackgroundColor: backgroundColor,
      canvasColor: surfaceColor,
      cardColor: surfaceColor,
      dialogBackgroundColor: surfaceColor,
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(foregroundColor: backgroundColor),
      colorScheme: const ColorScheme.dark().copyWith(
          primary: secondaryDarkerColor,
          primaryVariant: surfaceColor,
          secondary: secondaryDarkerColor,
          secondaryVariant: secondaryDarkerColor),
      textTheme: Typography.whiteHelsinki
          .apply(bodyColor: fontColor, fontFamily: AppConstants.fontFamily),
      primaryTextTheme: ThemeData.light().textTheme.apply(
            fontFamily: AppConstants.fontFamily,
          ),
      iconTheme: const IconThemeData().copyWith(color: fontColor));
}
