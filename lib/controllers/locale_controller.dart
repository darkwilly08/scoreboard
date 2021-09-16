import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleController extends ChangeNotifier {
  static const _defaultLang = 'en';

  LocaleController() {
    _initFromSharedPreferences();
  }

  late Locale _locale;

  Locale get locale => _locale;

  void _initFromSharedPreferences() {
    String lang =
        AppData.sharedPreferences.getString(PreferenceKeys.languageKey) ??
            _defaultLang;
    _locale = _findLocale(lang);
  }

  Locale _findLocale(String language) {
    List<Locale> locales = AppLocalizations.supportedLocales;
    return locales.firstWhere((element) => element.languageCode == language);
  }

  Future<void> changeLanguage(String language) async {
    _locale = _findLocale(language);
    await AppData.sharedPreferences
        .setString(PreferenceKeys.languageKey, _locale.languageCode);
    notifyListeners();
  }

  String getLanguage() {
    return AppConstants.isoLang[_locale.languageCode]!;
  }
}
