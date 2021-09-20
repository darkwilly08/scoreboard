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
  List<MatchPlayer>? players;

  Match(
      {this.id,
      required this.game,
      required this.createdAt,
      required this.updatedAt,
      this.endAt,
      this.wonPlayer,
      required int statusId}) {
    this.status = MatchStatus();
    this.status.id = statusId;
  }
}

class MatchStatus {
  static const int CREATED = 1;
  static const int IN_PROGRES = 2;
  static const int ENDED = 3;
  static const int CANCELLED = 4;

  int id = CREATED;
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

  MatchPlayer(
      {required this.match,
      required this.user,
      this.hasAsterisk,
      this.asteriskReason,
      required int statusId}) {
    this.status = PlayerStatus();
    this.status.id = statusId;
  }
}

class PlayerStatus {
  static const int PLAYING = 1;
  static const int WON = 2;
  static const int LOST = 3;

  int id = PLAYING;
}
