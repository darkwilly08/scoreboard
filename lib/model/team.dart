import 'package:anotador/model/match.dart';
import 'package:anotador/model/player.dart';
import 'package:anotador/model/team_status.dart';
import 'package:anotador/model/truco_game.dart';
import 'package:anotador/repositories/tables.dart';

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
      return lastScore > match!.game.targetScore / 2;
    }

    return null;
  }

  bool _isValid(int score) {
    if (match!.game.targetScore > score) {
      return true;
    }
    return false;
  }

  Future<bool> removeLast() async {
    if (scoreList.length > 1) {
      scoreList.removeLast();
      return true;
    }
    return false;
  }

  Future<bool> addResult(int value) async {
    bool targetScoreWins = match!.game.targetScoreWins;
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