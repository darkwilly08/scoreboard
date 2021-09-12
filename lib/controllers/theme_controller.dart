import 'package:anotador/themes/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:anotador/utils/app_data.dart';

class ThemeController extends ChangeNotifier {
  static const String darkModeKey = "darkMode";

  ThemeController() {
    _themeData = _getThemeFromSharedPreferences();
  }

  late ThemeData _themeData;

  ThemeData get themeData => _themeData;

  ThemeData _getThemeFromSharedPreferences() {
    bool? isDarkMode = AppData.sharedPreferences.getBool(darkModeKey);
    ThemeData themeData = AppTheme.darkTheme;
    if(isDarkMode != null) {
      themeData = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    }

    return themeData;
  }

  Future<void> changeMode(bool isDarkMode) async {
    _themeData = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    await AppData.sharedPreferences.setBool(darkModeKey, isDarkMode);
    notifyListeners();
  }
}