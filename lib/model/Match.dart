import 'package:anotador/model/Game.dart';
import 'package:anotador/model/User.dart';

class Match {
  int? id;
  Game game;
  User? wonPlayer;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? endAt;
  late MatchStatus status;
  late List<MatchPlayer> players;

  Match(
      {this.id,
      required this.game,
      required this.createdAt,
      required this.updatedAt,
      required int statusId,
      required List<User> users,
      this.endAt,
      this.wonPlayer}) {
    this.status = MatchStatus(statusId);
    this.players = [];
    for (var user in users) {
      MatchPlayer player =
          MatchPlayer(match: this, user: user, statusId: PlayerStatus.PLAYING);
      players.add(player);
    }
  }
}

class MatchStatus {
  static const int CREATED = 1;
  static const int IN_PROGRES = 2;
  static const int ENDED = 3;
  static const int CANCELLED = 4;

  int id;

  MatchStatus(int this.id);
}

class MatchPlayer {
  static const int PLAYING = 1;
  static const int WON = 2;
  static const int LOST = 3;

  Match match;
  User user;
  bool? hasAsterisk;
  String? asteriskReason;
  late PlayerStatus status;
  List<int> scoreList = [];

  MatchPlayer(
      {required this.match,
      required this.user,
      this.hasAsterisk,
      this.asteriskReason,
      required int statusId}) {
    this.status = PlayerStatus(statusId);
    this.scoreList.add(0);
  }

  int get lastScore => scoreList.last;

  bool _isValid(int score) {
    if (this.match.game.targetScore > score) {
      return true;
    }
    return false;
  }

  Future<void> addResult(int value) async {
    bool targetScoreWins = this.match.game.targetScoreWins;
    int lastScore = this.lastScore;
    int statusId = this.status.id;

    int newScore = lastScore + value;

    if (statusId != PlayerStatus.PLAYING && _isValid(newScore)) {
      this.scoreList.add(newScore);
      this.status.id = PlayerStatus.PLAYING;
      return; //the player is back on match, maybe a bad score loaded and then restored it
    }

    if (statusId != PlayerStatus.PLAYING) {
      return; //the player already won or lost
    }

    if (!_isValid(newScore)) {
      this.status.id = targetScoreWins ? PlayerStatus.WON : PlayerStatus.LOST;
    }

    this.scoreList.add(newScore);
  }
}

class PlayerStatus {
  static const int PLAYING = 1;
  static const int WON = 2;
  static const int LOST = 3;

  int id;

  PlayerStatus(int this.id);
}
