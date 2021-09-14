
import 'package:anotador/utils/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleController extends ChangeNotifier {
  static const String languageKey = "lang";
  final _isoLang = {
    "en": "English",
    "es": "Spanish"
  };

  LocaleController(){
    _locale = _getLocaleFromSharedPreferences();
  }

  late Locale _locale;

  Locale get locale => _locale;

  Locale _getLocaleFromSharedPreferences() {
   String? lang = AppData.sharedPreferences.getString(languageKey);
   Locale locale;
   if(lang == null){
     locale = const Locale("en");
   } else {
     locale = _findLocale(lang);
   }
   return locale;
  }

  Locale _findLocale(String language){
    List<Locale> locales = AppLocalizations.supportedLocales;
    return locales.firstWhere((element) => element.languageCode == language, orElse: () => const Locale('en'));
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