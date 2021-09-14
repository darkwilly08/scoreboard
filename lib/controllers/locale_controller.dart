
import 'package:anotador/utils/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleController extends ChangeNotifier {
  static const String languageKey = "lang";
  final defaultLang = 'en';
  final _isoLang = {
    "en": "English",
    "es": "Spanish"
  };

  LocaleController(){
    _initFromSharedPreferences();
  }

  late Locale _locale;

  Locale get locale => _locale;

  void _initFromSharedPreferences() {
   String lang = AppData.sharedPreferences.getString(languageKey) ?? defaultLang;
   _locale = _findLocale(lang);
  }

  Locale _findLocale(String language){
    List<Locale> locales = AppLocalizations.supportedLocales;
    return locales.firstWhere((element) => element.languageCode == language);
  }

  Future<void> changeLanguage(String language) async {
    _locale = _findLocale(language);
    await AppData.sharedPreferences.setString(languageKey, _locale.languageCode);
    notifyListeners();
  }

  String getLanguage() {
    return _isoLang[_locale.languageCode]!;
  }
}