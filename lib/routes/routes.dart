import 'package:anotador/pages/home.dart';
import 'package:anotador/pages/match_preparation_page.dart';
import 'package:anotador/pages/match_types/normal_match_page.dart';
import 'package:anotador/pages/match_types/truco_match_page.dart';
import 'package:anotador/pages/settings_page.dart';
import 'package:anotador/pages/users_page.dart';

class Routes {
  static const String home = HomeScreen.routeName;
  static const String settings = SettingsScreen.routeName;
  static const String users = UsersScreen.routeName;
  static const String matchPreparation = MatchPreparationScreen.routeName;
  static const String normalMatch = NormalMatchScreen.routeName;
  static const String trucoMatch = TrucoMatchScreen.routeName;
}
