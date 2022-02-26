import 'dart:io';

import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/model/custom_locale.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  LocaleController() {
    _initFromSharedPreferences();
  }

  late CustomLocale _locale;

  CustomLocale get customLocale => _locale;
  Locale get locale => Locale(_locale.languageCode);

  CustomLocale _findLocale(String languageCode) {
    return AppConstants.languages.firstWhere(
        (l) => l.languageCode == languageCode,
        orElse: () => AppConstants.languages.first);
  }

  CustomLocale _getDefaultLang() {
    String platformLang = Platform.localeName.length >= 2
        ? Platform.localeName.substring(0, 2)
        : 'en';

    return _findLocale(platformLang);
  }

  void _initFromSharedPreferences() {
    String lang =
        AppData.sharedPreferences.getString(PreferenceKeys.languageKey) ??
            _getDefaultLang().languageCode;

    _locale = _findLocale(lang);
  }

  Future<void> changeLanguage(String language) async {
    _locale = _findLocale(language);
    await AppData.sharedPreferences
        .setString(PreferenceKeys.languageKey, _locale.languageCode);
    notifyListeners();
  }
}
