class Game {
  int? id;
  String name;
  int targetScore;
  bool targetScoreWins;
  late GameType type;
  int won = 0;
  int lost = 0;

  Game(
      {this.id,
      required this.name,
      required this.targetScore,
      required this.targetScoreWins}) {
    this.type = GameType(GameType.NORMAL);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type_id': type.id,
      'target_score': targetScore,
      'target_score_wins': targetScoreWins ? 1 : 0,
    };
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      targetScore: json['target_score'],
      targetScoreWins: json['target_score_wins'] > 0,
    );
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
    this.type = GameType(GameType.TRUCO);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type_id': type.id,
      'target_score': targetScore,
      'target_score_wins': targetScoreWins ? 1 : 0,
      'two_halves': twoHalves ? 1 : 0
    };
  }

  factory TrucoGame.fromJson(Map<String, dynamic> json) {
    return TrucoGame(
        id: json['id'],
        name: json['name'],
        targetScore: json['target_score'],
        targetScoreWins: json['target_score_wins'] > 0,
        twoHalves: json['two_halves'] > 0);
  }
}

class GameType {
  static const int NORMAL = 1;
  static const int TRUCO = 2;

  int id;
  GameType(int this.id);
}
