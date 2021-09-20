class Game {
  int? id;
  String name;
  int targetScore;
  bool targetScoreWins;
  late GameType type;

  Game(
      {this.id,
      required this.name,
      required this.targetScore,
      required this.targetScoreWins}) {
    this.type = GameType();
    this.type.id = GameType.NORMAL;
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'initial': initial,
  //     'favorite': favorite ? 1 : 0,
  //   };
  // }
}

class TrucoGame extends Game {
  bool twoHalves;
  TrucoGame(int? id, String name, int targetScore, bool targetScoreWins,
      bool this.twoHalves)
      : super(
            id: id,
            name: name,
            targetScore: targetScore,
            targetScoreWins: targetScoreWins) {
    this.type = GameType();
    this.type.id = GameType.TRUCO;
  }
}

class GameType {
  static const int NORMAL = 1;
  static const int TRUCO = 2;

  int id = NORMAL;
}
