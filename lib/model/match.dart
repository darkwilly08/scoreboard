import 'package:anotador/model/game.dart';
import 'package:anotador/model/match_status.dart';
import 'package:anotador/model/team.dart';
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

  List<User>? getUsers() {
    if (teams == null) return null;
    List<User> users = [];
    for (var team in teams!) {
      for (var player in team.players) {
        users.add(player.user);
      }
    }
    return users;
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
