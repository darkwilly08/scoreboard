import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/model/game.dart';
import 'package:anotador/model/game_type.dart';
import 'package:anotador/model/truco/truco_score.dart';
import 'package:anotador/repositories/tables.dart';

class TrucoGame extends Game {
  bool twoHalves;
  TrucoGame(
      {int? id,
      required String name,
      required int targetScore,
      required bool targetScoreWins,
      required this.twoHalves})
      : super(
            id: id,
            name: name,
            targetScore: targetScore,
            targetScoreWins: targetScoreWins,
            isNegativeAllowed: false) {
    type = GameType(GameType.TRUCO);
  }

  TrucoScore get scoreInfo {
    return AppConstants.trucoPossibleScores
        .firstWhere((element) => element.points == targetScore);
  }

  @override
  Map<String, dynamic> toMap() {
    final def = super.toMap();
    def.putIfAbsent('${Tables.game}_two_halves', () => twoHalves ? 1 : 0);
    return def;
  }

  factory TrucoGame.fromJson(Map<String, dynamic> json) {
    return TrucoGame(
        id: json['${Tables.game}_id'],
        name: json['${Tables.game}_name'],
        targetScore: json['${Tables.game}_target_score'],
        targetScoreWins: json['${Tables.game}_target_score_wins'] > 0,
        twoHalves: json['${Tables.game}_two_halves'] > 0);
  }
}
