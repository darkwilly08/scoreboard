import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'landing.dart';

class SplashLauncher extends StatelessWidget {
  const SplashLauncher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: const LandingScreen(),
      duration: 2000,
      imageSrc: AssetsConstants.scoreboard,
      text: AppData.packageInfo.appName,
      textType: TextType.NormalText,
      textStyle: const TextStyle(
        fontSize: 30.0,
      ),
    );
  }
}
