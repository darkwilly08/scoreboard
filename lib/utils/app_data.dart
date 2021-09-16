import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static late SharedPreferences sharedPreferences;
  static late PackageInfo packageInfo;
  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();
  }
}
