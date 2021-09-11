import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/splashes/splash.dart';
import 'package:anotador/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  UserPreferences.instance.prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ThemeController(isDarkMode: UserPreferences.instance.isDarkMode),
      child: Consumer<ThemeController>(
        builder: (_, manager, __) {
          return MaterialApp(
            onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.title,
            theme: manager.themeData,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SplashLauncher(),
          );
        },
      ),
    );
  }
}
