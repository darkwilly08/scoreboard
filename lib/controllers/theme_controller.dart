import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/themes/app_theme.dart';
import 'package:flutter/material.dart';

import 'package:anotador/utils/app_data.dart';

class ThemeController extends ChangeNotifier {
  ThemeController() {
    _initFromSharedPreferences();
  }

  late ThemeData _themeData;
  late bool _darkMode;

  bool get isDarkMode => _darkMode;

  ThemeData get themeData => _themeData;

  void _initFromSharedPreferences() {
    bool isDarkMode =
        AppData.sharedPreferences.getBool(PreferenceKeys.darkModeKey) ?? true;

    _themeData = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    _darkMode = isDarkMode;
  }

  Future<void> changeMode(bool darkMode) async {
    _themeData = darkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    _darkMode = darkMode;
    await AppData.sharedPreferences
        .setBool(PreferenceKeys.darkModeKey, darkMode);
    notifyListeners();
  }
}
