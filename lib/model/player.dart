import 'package:anotador/model/team.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/repositories/tables.dart';

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