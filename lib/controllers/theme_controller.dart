import 'package:anotador/themes/app_theme.dart';
import 'package:anotador/utils/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({required isDarkMode}) : _themeData = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  ThemeData _themeData;

  /// Returns the current theme
  ThemeData get themeData => _themeData;

  void changeMode(bool isDarkMode){
    _themeData = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    UserPreferences.instance.darkMode = isDarkMode;
    notifyListeners();
  }
}