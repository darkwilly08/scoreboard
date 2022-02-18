import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/model/truco/truco_score.dart';
import 'package:anotador/repositories/tables.dart';

class Game {
  int? id;
  String name;
  int targetScore;
  bool targetScoreWins;
  late GameType type;
  int won = 0;
  int lost = 0;
  int? npMinVal;
  int? npMaxVal;
  int? npStep;

  Game(
      {this.id,
      required this.name,
      required this.targetScore,
      required this.targetScoreWins,
      this.npMaxVal,
      this.npMinVal,
      this.npStep}) {
    type = GameType(GameType.NORMAL);
  }

  Map<String, dynamic> toMap() {
    return {
      '${Tables.game}_id': id,
      '${Tables.game}_name': name,
      '${Tables.game}_type_id': type.id,
      '${Tables.game}_target_score': targetScore,
      '${Tables.game}_target_score_wins': targetScoreWins ? 1 : 0,
      '${Tables.game}_np_min_val': npMinVal,
      '${Tables.game}_np_max_val': npMaxVal,
      '${Tables.game}_np_step': npStep,
    };
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    int typeId = json['${Tables.game}_type_id'];
    switch (typeId) {
      case GameType.NORMAL:
        return Game(
            id: json['${Tables.game}_id'],
            name: json['${Tables.game}_name'],
            targetScore: json['${Tables.game}_target_score'],
            targetScoreWins: json['${Tables.game}_target_score_wins'] > 0,
            npMinVal: json['${Tables.game}_np_min_val'],
            npMaxVal: json['${Tables.game}_np_max_val'],
            npStep: json['${Tables.game}_np_step']);
      case GameType.TRUCO:
        return TrucoGame.fromJson(json);
      default:
        throw Exception("game type not valid");
    }
  }
}

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
            targetScoreWins: targetScoreWins) {
    type = GameType(GameType.TRUCO);
  }

  TrucoScore get scoreInfo {
    return AppConstants.trucoPossibleScores
        .firstWhere((element) => element.points == targetScore);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      '${Tables.game}_id': id,
      '${Tables.game}_name': name,
      '${Tables.game}_type_id': type.id,
      '${Tables.game}_target_score': targetScore,
      '${Tables.game}_target_score_wins': targetScoreWins ? 1 : 0,
      '${Tables.game}_two_halves': twoHalves ? 1 : 0
    };
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

class GameType {
  static const int NORMAL = 1;
  static const int TRUCO = 2;

  int id;
  GameType(this.id);
}
