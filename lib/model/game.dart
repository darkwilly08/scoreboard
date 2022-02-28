import 'package:anotador/model/game_type.dart';
import 'package:anotador/model/truco_game.dart';
import 'package:anotador/repositories/tables.dart';

class Game {
  int? id;
  String name;
  int targetScore;
  bool targetScoreWins;
  bool isNegativeAllowed;
  late GameType type;
  int won = 0;
  int lost = 0;
  int? npMinVal;
  int? npMaxVal;
  int? npStep;

  static Game createCopy(Game game) {
    return Game(
        name: game.name,
        targetScore: game.targetScore,
        targetScoreWins: game.targetScoreWins,
        isNegativeAllowed: game.isNegativeAllowed,
        npMaxVal: game.npMaxVal,
        npMinVal: game.npMinVal,
        npStep: game.npStep);
  }

  Game(
      {this.id,
      required this.name,
      required this.targetScore,
      required this.targetScoreWins,
      required this.isNegativeAllowed,
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
      '${Tables.game}_is_negative_allowed': isNegativeAllowed ? 1 : 0,
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
            isNegativeAllowed: json['${Tables.game}_is_negative_allowed'] > 0,
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
