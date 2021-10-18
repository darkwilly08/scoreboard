import 'package:anotador/model/Game.dart';
import 'package:anotador/model/User.dart';
import 'package:anotador/repositories/tables.dart';
import 'package:anotador/utils/date_helper.dart';

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
      List<User>? users,
      this.endAt,
      this.wonPlayer}) {
    this.status = MatchStatus(statusId);

    if (users != null) {
      this.players = [];
      for (var user in users) {
        MatchPlayer player = MatchPlayer(
            match: this, user: user, statusId: PlayerStatus.PLAYING);
        this.players.add(player);
      }
    }
  }

  Map<String, dynamic> toMap() {
    return {
      '${Tables.match}_id': id,
      '${Tables.match}_game_id': game.id,
      '${Tables.match}_won_user_id': wonPlayer != null ? wonPlayer!.id : null,
      '${Tables.match}_status_id': status.id,
      '${Tables.match}_created_at': DateUtils.instance.toDB(createdAt),
      '${Tables.match}_updated_at': DateUtils.instance.toDB(updatedAt),
      '${Tables.match}_end_at':
          endAt != null ? DateUtils.instance.toDB(endAt!) : null
    };
  }

  factory Match.fromJson(List<Map<String, dynamic>> json) {
    var m = Match(
      id: json[0]['${Tables.match}_id'],
      game: Game.fromJson(json[0]),
      statusId: json[0]["${Tables.match}_status_id"],
      wonPlayer: json[0]['${Tables.match}_won_user_id'],
      createdAt:
          DateUtils.instance.fromDB(json[0]['${Tables.match}_created_at']),
      updatedAt:
          DateUtils.instance.fromDB(json[0]['${Tables.match}_updated_at']),
    );

    m.players = List.generate(json.length, (i) {
      return MatchPlayer.fromJson(m, json[i]);
    });

    return m;
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

  int? id;
  Match match;
  User user;
  bool hasAsterisk = false;
  String? asteriskReason;
  late PlayerStatus status;
  List<int> scoreList = [];

  MatchPlayer(
      {this.id,
      required this.match,
      required this.user,
      bool? asterisk,
      this.asteriskReason,
      required int statusId}) {
    this.status = PlayerStatus(statusId);
    this.scoreList.add(0);
    if (asterisk != null) {
      hasAsterisk = asterisk;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      '${Tables.match_player}_id': id,
      '${Tables.match_player}_match_id': match.id,
      '${Tables.match_player}_user_id': user.id,
      '${Tables.match_player}_has_asterisk': hasAsterisk ? 1 : 0,
      '${Tables.match_player}_asterisk_reason': asteriskReason,
      '${Tables.match_player}_status_id': status.id,
    };
  }

  factory MatchPlayer.fromJson(Match match, Map<String, dynamic> json) {
    return MatchPlayer(
        id: json['${Tables.match_player}_id'],
        match: match,
        user: User.fromJson(json),
        statusId: json['${Tables.match_player}_status_id']);
  }

  int get lastScore => scoreList.last;

  bool _isValid(int score) {
    if (this.match.game.targetScore > score) {
      return true;
    }
    return false;
  }

  Future<bool> addResult(int value) async {
    bool targetScoreWins = this.match.game.targetScoreWins;
    int lastScore = this.lastScore;
    int statusId = this.status.id;

    int newScore = lastScore + value;

    if (statusId != PlayerStatus.PLAYING && _isValid(newScore)) {
      this.scoreList.add(newScore);
      this.status.id = PlayerStatus.PLAYING;
      return false; //the player is back on match, maybe a bad score loaded and then restored it
    }

    if (statusId != PlayerStatus.PLAYING) {
      return false; //the player already won or lost
    }

    if (!_isValid(newScore)) {
      this.status.id = targetScoreWins ? PlayerStatus.WON : PlayerStatus.LOST;
    }

    this.scoreList.add(newScore);
    return true;
  }
}

class PlayerStatus {
  static const int PLAYING = 1;
  static const int WON = 2;
  static const int LOST = 3;

  int id;

  PlayerStatus(int this.id);
}
