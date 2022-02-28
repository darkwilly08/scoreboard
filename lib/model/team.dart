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

  static Team createCopy(Team team) {
    Team newTeam = Team(
      name: team.name,
      statusId: PLAYING,
    );
    newTeam.players = team.players
        .map((player) => Player(team: newTeam, user: player.user))
        .toList();
    return newTeam;
  }

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

  bool _isValidScore(int score) {
    return !match!.game.isNegativeAllowed ? score >= 0 : true;
  }

  bool _hasReachedTargetScore(int score) {
    return score >= match!.game.targetScore;
  }

  Future<bool> removeLast() async {
    if (scoreList.length > 1) {
      scoreList.removeLast();
      status.id = TeamStatus.PLAYING;
      return true;
    }
    return false;
  }

  Future<bool> addResult(int value) async {
    bool targetScoreWins = match!.game.targetScoreWins;

    int newScore = lastScore + value;

    if (_isValidScore(newScore) && status.id == TeamStatus.PLAYING) {
      if (_hasReachedTargetScore(newScore)) {
        status.id = targetScoreWins ? TeamStatus.WON : TeamStatus.LOST;
      } else {
        status.id = TeamStatus.PLAYING;
      }
      scoreList.add(newScore);
      return true;
    }
    return false;
  }
}
