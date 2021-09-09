import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  static const String darkModeKey = "darkMode";
  static final UserPreferences _instance = UserPreferences._privateConstructor();
  static UserPreferences get instance => _instance;

  UserPreferences._privateConstructor();

  late SharedPreferences prefs;

  //region darkMode
  bool? _darkMode;


  bool get isDarkMode {
    _darkMode ??= _getModeFromSP();
    return _darkMode!;
  }

  set darkMode(bool darkMode){
    save(darkModeKey, darkMode);
    _darkMode = darkMode;
  }

  bool _getModeFromSP()  {
    bool? dm = prefs.getBool(darkModeKey);
    if(dm != null){
      return dm;
    }
    return true;
  }
  //endregion

 void save(String key, dynamic value){
    if(value is String){
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    }
 }






}