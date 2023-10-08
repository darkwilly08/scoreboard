import 'package:anotador/pages/board/raw_table_page.dart';
import 'package:anotador/pages/game_settings.dart';
import 'package:anotador/pages/home.dart';
import 'package:anotador/pages/match_preparation_page.dart';
import 'package:anotador/pages/match_types/game_match_page.dart';
import 'package:anotador/pages/onboarding/onboarding_page.dart';
import 'package:anotador/pages/settings_page.dart';
import 'package:anotador/pages/users_page.dart';

class Routes {
  static const String onboarding = OnBoardingPage.routeName;
  static const String home = HomeScreen.routeName;
  static const String settings = SettingsScreen.routeName;
  static const String users = UsersScreen.routeName;
  static const String matchPreparation = MatchPreparationScreen.routeName;
  static const String matchBoard = GameMatchScreen.routeName;
  static const String gameSettings = GameSettings.routeName;
  static const String boardTable = RawTablePage.routeName;
}
