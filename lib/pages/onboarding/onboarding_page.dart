import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/controllers/owner_controller.dart';
import 'package:anotador/routes/routes.dart';
import 'package:anotador/themes/app_theme.dart';
import 'package:anotador/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class OnBoardingPage extends StatefulWidget {
  static const String routeName = "/onboarding";
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late final OwnerController _ownerController;
  final introKey = GlobalKey<IntroductionScreenState>();
  final TextEditingController _displayNameTextController =
      TextEditingController();

  static const _bodyStyle = TextStyle(fontSize: 19.0, color: Colors.black);

  static const _pageDecoration = PageDecoration(
    titleTextStyle: TextStyle(
        fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.black),
    bodyTextStyle: _bodyStyle,
    pageColor: Colors.white,
    imagePadding: EdgeInsets.zero,
    // titlePadding: EdgeInsets.zero
  );

  @override
  void initState() {
    _ownerController = Provider.of<OwnerController>(context, listen: false);
    super.initState();
  }

  bool _nameValidator(String? val) {
    if (val == null || val.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _onIntroEnd() async {
    String displayName = _displayNameTextController.text;
    if (!_nameValidator(displayName)) {
      final snackBar =
          DangerSnackBar(Text(AppLocalizations.of(context)!.display_name));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    await _ownerController.createOwner(displayName);
    // Redirect is performed automatically
  }

  Widget _buildImage(String assetImage) {
    const double footerPlusDotsContainerHeight = 90;
    return Padding(
      padding: const EdgeInsets.only(
          bottom: footerPlusDotsContainerHeight, left: 4.0, right: 4.0),
      child: Center(
          child: Image.asset(
        assetImage,
      )),
    );
  }

  Widget _buildGlobalFooter() {
    return Container(
      color: AppTheme.secondaryDarkerColor,
      width: double.infinity,
      height: 60,
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.onboarding_quote,
          style: const TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  PageViewModel _buildWelcomeView() {
    return PageViewModel(
      title: AppLocalizations.of(context)!.onboarding_welcome_title,
      body: AppLocalizations.of(context)!.onboarding_welcome_description,
      image: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Image.asset(
          AssetsConstants.onboardingWelcome,
        ),
      ),
      decoration: _pageDecoration.copyWith(bodyFlex: 1),
    );
  }

  PageViewModel _buildLetsGoView() {
    return PageViewModel(
        title: AppLocalizations.of(context)!.onboarding_letsgo_title,
        bodyWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.onboarding_letsgo_description,
                  style: _bodyStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _displayNameTextController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.display_name,
                    labelStyle:
                        const TextStyle(color: AppTheme.secondaryDarkerColor),
                    filled: true,
                    isDense: true,
                    fillColor: Colors.black87,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.secondaryDarkerColor,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: AppTheme.secondaryDarkerColor,
                      ),
                    ),
                  ),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ))
          ],
        ),
        image: _buildImage(AssetsConstants.onboardingDisplayname),
        decoration: _pageDecoration.copyWith(
          bodyFlex: 0,
        ),
        reverse: true);
  }

  DotsDecorator _buildDotsDecorator() {
    const dotSize = Size(10.0, 10.0);
    final activeDot = Size(dotSize.width * 2, dotSize.height);
    return DotsDecorator(
      size: dotSize,
      color: Colors.grey,
      activeColor: AppTheme.secondaryDarkerColor,
      activeSize: activeDot,
      activeShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }

  ShapeDecoration _buildDotsContainer() {
    return const ShapeDecoration(
      color: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalFooter: _buildGlobalFooter(),
      pages: [
        _buildWelcomeView(),
        _buildLetsGoView(),
      ],
      onDone: _onIntroEnd,
      skipOrBackFlex: 0,
      nextFlex: 0,
      isTopSafeArea: true,
      isBottomSafeArea: true,
      showBackButton: true,
      back: const Icon(Icons.arrow_back),
      next: const Icon(Icons.arrow_forward),
      done: Text(AppLocalizations.of(context)!.done,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.all(4),
      dotsDecorator: _buildDotsDecorator(),
      dotsContainerDecorator: _buildDotsContainer(),
    );
  }
}
