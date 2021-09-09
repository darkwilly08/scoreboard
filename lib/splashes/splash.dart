import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import '../main.dart';

class SplashLauncher extends StatelessWidget {
  const SplashLauncher({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: const MyHomePage(title: ''),
      duration: 3000,
      // imageSize: 130,
      // imageSrc: "logo.png",
      text: "Splash Screen",
      textType: TextType.NormalText,
      textStyle: const TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.white,
    );
  }
}