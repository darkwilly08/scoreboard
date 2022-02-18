import 'package:anotador/model/game.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/repositories/tables.dart';
import 'package:anotador/utils/date_helper.dart';

class Match {
  int? id;
  Game game;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? endAt;
  bool isFFA;
  late MatchStatus status;
  List<Team>? teams;

  Match(
      {this.id,
      required this.game,
      required this.createdAt,
      required this.updatedAt,
      required int statusId,
      required this.isFFA,
      this.teams,
      this.endAt}) {
    status = MatchStatus(statusId);
    teams?.forEach((element) => element.match = this);
  }

  Map<String, dynamic> toMap() {
    return {
      '${Tables.match}_id': id,
      '${Tables.match}_game_id': game.id,
      '${Tables.match}_ffa': isFFA ? 1 : 0,
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
      isFFA: json[0]['${Tables.match}_ffa'] > 0,
      createdAt:
          DateUtils.instance.fromDB(json[0]['${Tables.match}_created_at']),
      updatedAt:
          DateUtils.instance.fromDB(json[0]['${Tables.match}_updated_at']),
    );

    m.teams = List.generate(json.length, (i) {
      return Team.fromJson(m, json[i]);
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

  MatchStatus(this.id);
}

class Team {
  static const int PLAYING = 1;
  static const int WON = 2;
  static const int LOST = 3;

  int? id;
  Match? match;
  String name;

  bool hasAsterisk = false;
  String? asteriskReason;
  late TeamStatus status;
  List<int> scoreList = [];
  List<Player> players = [];

  Team(
      {this.id,
      this.match,
      required this.name,
      bool? asterisk,
      this.asteriskReason,
      required int statusId}) {
    status = TeamStatus(statusId);
    scoreList.add(0);
    if (asterisk != null) {
      hasAsterisk = asterisk;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      '${Tables.team}_id': id,
      '${Tables.team}_match_id': match!.id,
      '${Tables.team}_name': name,
      '${Tables.team}_has_asterisk': hasAsterisk ? 1 : 0,
      '${Tables.team}_asterisk_reason': asteriskReason,
      '${Tables.team}_status_id': status.id,
    };
  }

  factory Team.fromJson(Match match, Map<String, dynamic> json) {
    var t = Team(
        id: json['${Tables.team}_id'],
        match: match,
        name: json['${Tables.team}_name'],
        statusId: json['${Tables.team}_status_id'],
        asterisk: json['${Tables.team}_has_asterisk'] > 0,
        asteriskReason: json['${Tables.team}_asterisk_reason']);

    t.players = List.generate(json.length, (i) {
      return Player.fromJson(t, json[i]);
    });

    return t;
  }

  int get lastScore => scoreList.last;

  bool? areGood() {
    if (match!.game is TrucoGame && (match!.game as TrucoGame).twoHalves) {
      return lastScore > match!.game.targetScore;
    }

    return null;
  }

  bool _isValid(int score) {
    if (match!.game.targetScore > score) {
      return true;
    }
    return false;
  }

  Future<bool> addResult(int value) async {
    bool targetScoreWins = match!.game.targetScoreWins;
    int lastScore = this.lastScore;
    int statusId = status.id;

    int newScore = lastScore + value;

    if (statusId != TeamStatus.PLAYING && _isValid(newScore)) {
      scoreList.add(newScore);
      status.id = TeamStatus.PLAYING;
      return false; //the team is back on match, maybe a bad score loaded and then restored it
    }

    if (statusId != TeamStatus.PLAYING) {
      return false; //the team already won or lost
    }

    if (!_isValid(newScore)) {
      status.id = targetScoreWins ? TeamStatus.WON : TeamStatus.LOST;
    }

    scoreList.add(newScore);
    return true;
  }
}

class TeamStatus {
  static const int PLAYING = 1;
  static const int WON = 2;
  static const int LOST = 3;

  int id;

  TeamStatus(this.id);
}

class Player {
  int? id;
  Team team;
  User user;

  Player({this.id, required this.team, required this.user});

  factory Player.fromJson(Team team, Map<String, dynamic> json) {
    var t = Player(
      id: json['${Tables.team_player}_id'],
      team: team,
      user: User.fromJson(json),
    );

    return t;
  }

  Map<String, dynamic> toMap() {
    return {
      '${Tables.team_player}_id': id,
      '${Tables.team_player}_team_id': team.id,
      '${Tables.team_player}_user_id': user.id
    };
  }
}
