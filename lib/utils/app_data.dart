
import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static late SharedPreferences sharedPreferences;
  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}