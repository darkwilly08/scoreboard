import 'package:anotador/controllers/locale_controller.dart';
import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/controllers/user_controller.dart';
import 'package:anotador/pages/home.dart';
import 'package:anotador/pages/settings_page.dart';
import 'package:anotador/pages/users_page.dart';
import 'package:anotador/routes/routes.dart';
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
              create: (_) => UserController())
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
                home: HomeScreen(),
                routes: {
                  Routes.settings: (context) => SettingsScreen(),
                  Routes.users: (context) => UsersScreen()
                });
          },
        ));
  }
}
