import 'package:anotador/controllers/owner_controller.dart';
import 'package:anotador/pages/home.dart';
import 'package:anotador/pages/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OwnerController>(builder: (context, ownerController, _) {
      if (!ownerController.isOnboardingCompleted) {
        return const OnBoardingPage();
      }
      return const HomeScreen();
    });
  }
}
