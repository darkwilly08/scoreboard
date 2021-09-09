import 'package:anotador/utils/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({required isDarkMode}) : _themeData = isDarkMode ? darkTheme : lightTheme;

  ThemeData _themeData;

  /// Returns the current theme
  ThemeData get themeData => _themeData;

  void changeMode(bool isDarkMode){
    _themeData = isDarkMode ? darkTheme : lightTheme;
    UserPreferences.instance.darkMode = isDarkMode;
    notifyListeners();
  }

  static ThemeData lightTheme = ThemeData.light();
  static ThemeData darkTheme = ThemeData.dark();
}