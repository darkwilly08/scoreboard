import 'package:anotador/model/custom_locale.dart';
import 'package:anotador/model/truco/truco_score.dart';

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
}

class PreferenceKeys {
  PreferenceKeys._();
  static const String languageKey = "lang";
  static const String darkModeKey = "darkMode";
}

class AssetsConstants {
  AssetsConstants._();
  static const _iconsFolder = 'assets/icons';
  static const _audiosFolder = 'assets/audios';
  static const scoreboard = '$_iconsFolder/scoreboard.png';
  static const trucoLine = '$_iconsFolder/one_line.png';
  static const auxLine = '$_iconsFolder/one_line_rotated.png';
  static const lighter = '$_iconsFolder/lighter.png';

  //audios
  static const pointRemoved = '$_audiosFolder/point_removed.mp3';
  static const pointAdded = '$_audiosFolder/point_added.mp3';
  static const specialScore = '$_audiosFolder/special_score.mp3';
}
