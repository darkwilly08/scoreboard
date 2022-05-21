import 'package:anotador/model/custom_locale.dart';
import 'package:anotador/model/in_game/menu/choice.dart';
import 'package:anotador/model/truco/truco_score.dart';
import 'package:line_icons/line_icons.dart';

class AppConstants {
  AppConstants._();
  static const fontFamily = "Nexa";
  static const languages = [
    CustomLocale(languageCode: "en", languageName: "English"),
    CustomLocale(languageCode: "es", languageName: "Spanish")
  ];
  static const dbDateTimeFormat = "yyyy-MM-dd HH:mm:ss.SSS";
  static const trucoPossibleScores = [
    TrucoScore(points: 9, pointsBySquare: 3, twoHalves: false),
    TrucoScore(points: 10, pointsBySquare: 5, twoHalves: false),
    TrucoScore(points: 12, pointsBySquare: 4, twoHalves: false),
    TrucoScore(points: 15, pointsBySquare: 5, twoHalves: false),
    TrucoScore(points: 20, pointsBySquare: 5, twoHalves: false),
    TrucoScore(points: 18, pointsBySquare: 3, twoHalves: true),
    TrucoScore(points: 24, pointsBySquare: 4, twoHalves: true),
    TrucoScore(points: 30, pointsBySquare: 5, twoHalves: true),
    TrucoScore(points: 40, pointsBySquare: 5, twoHalves: true),
  ];
  static const choices = [
    Choice(
      type: Choice.addTeam,
      title: 'add_team',
      icon: LineIcons.userFriends,
    ),
    Choice(
      type: Choice.restartMatch,
      title: 'restart_match',
      icon: LineIcons.alternateRedo,
    ),
    Choice(
      type: Choice.goToSettings,
      title: 'settings',
      icon: LineIcons.cog,
    ),
    Choice(
      type: Choice.exit,
      title: 'exit',
      icon: LineIcons.alternateSignOut,
    )
  ];
}

class PreferenceKeys {
  PreferenceKeys._();
  static const String languageKey = "lang";
  static const String darkModeKey = "darkMode";
  static const String ownerReadyKey = "ownerReady";
}

class AssetsConstants {
  AssetsConstants._();
  static const _imagesFolder = 'assets/images';
  static const _iconsFolder = 'assets/icons';
  static const _audiosFolder = 'assets/audios';

  //images
  static const onboardingWelcome =
      '$_imagesFolder/onboarding/displayname_step.png';
  static const onboardingDisplayname =
      '$_imagesFolder/onboarding/welcome_step.png';

  //icons
  static const scoreboard = '$_iconsFolder/scoreboard.png';
  static const trucoLine = '$_iconsFolder/one_line.png';
  static const auxLine = '$_iconsFolder/one_line_rotated.png';
  static const lighter = '$_iconsFolder/lighter.png';

  //audios
  static const pointRemoved = '$_audiosFolder/point_removed.mp3';
  static const pointAdded = '$_audiosFolder/point_added.mp3';
  static const specialScore = '$_audiosFolder/special_score.mp3';
}
