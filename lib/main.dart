import 'package:anotador/controllers/game_controller.dart';
import 'package:anotador/controllers/locale_controller.dart';
import 'package:anotador/controllers/match_controller.dart';
import 'package:anotador/controllers/owner_controller.dart';
import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/controllers/user_controller.dart';
import 'package:anotador/model/game.dart';
import 'package:anotador/pages/game_settings.dart';
import 'package:anotador/pages/match_preparation_page.dart';
import 'package:anotador/pages/match_types/game_match_page.dart';
import 'package:anotador/pages/onboarding/onboarding_page.dart';
import 'package:anotador/pages/settings_page.dart';
import 'package:anotador/pages/users_page.dart';
import 'package:anotador/routes/routes.dart';
import 'package:anotador/splashes/splash.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppData.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeController>(
              create: (_) => ThemeController()),
          ChangeNotifierProvider<LocaleController>(
              create: (_) => LocaleController()),
          ChangeNotifierProvider<UserController>(
              create: (_) => UserController()),
          ChangeNotifierProvider<GameController>(
              create: (_) => GameController()),
          ChangeNotifierProxyProvider<GameController, MatchController>(
            update: (context, gameController, matchController) =>
                matchController!.update(gameController),
            create: (BuildContext context) => MatchController(),
          ),
          ChangeNotifierProvider<OwnerController>(
              create: (_) => OwnerController()),
        ],
        child: Consumer2<ThemeController, LocaleController>(
          builder: (_, themeController, localeController, __) {
            return MaterialApp(
              locale: localeController.locale,
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.title,
              theme: themeController.themeData,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const SplashLauncher(),
              onGenerateRoute: (RouteSettings routeSettings) {
                var routes = <String, WidgetBuilder>{
                  Routes.onboarding: (context) => const OnBoardingPage(),
                  Routes.settings: (context) => const SettingsScreen(),
                  Routes.users: (context) => const UsersScreen(),
                  Routes.matchPreparation: (context) => MatchPreparationScreen(
                      selectedGame: routeSettings.arguments as Game),
                  Routes.matchBoard: (context) => const GameMatchScreen(),
                  Routes.gameSettings: (context) => const GameSettings(),
                };
                WidgetBuilder builder = routes[routeSettings.name]!;
                return MaterialPageRoute(builder: (ctx) => builder(ctx));
              },
            );
          },
        ));
  }
}
