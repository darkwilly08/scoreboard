import 'package:anotador/model/truco/truco_score.dart';

class AppConstants {
  AppConstants._();
  static const isoLang = {"en": "English", "es": "Spanish"};
  static const dbDateTimeFormat = "yyyy-MM-dd HH:mm";
  static const trucoPossibleScores = [
    TrucoScore(points: 9, pointsBySquare: 3),
    TrucoScore(points: 10, pointsBySquare: 5),
    TrucoScore(points: 12, pointsBySquare: 4),
    TrucoScore(points: 15, pointsBySquare: 5),
    TrucoScore(points: 20, pointsBySquare: 5),
    TrucoScore(points: 24, pointsBySquare: 4),
    TrucoScore(points: 30, pointsBySquare: 5),
    TrucoScore(points: 40, pointsBySquare: 5),
  ];
}

class PreferenceKeys {
  PreferenceKeys._();
  static const String languageKey = "lang";
  static const String darkModeKey = "darkMode";
}

class AssetsConstants {
  AssetsConstants._();
  static const scoreboard = 'assets/icons/scoreboard.png';
  static const trucoLine = 'assets/one_line.png';
  static const auxLine = 'assets/one_line_rotated.png';
  static const lighter = 'assets/lighter.png';
}
