import 'package:anotador/model/game.dart';
import 'package:anotador/model/match.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/repositories/tables.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:anotador/utils/date_helper.dart';
import 'package:sqflite/sqflite.dart';

class MatchRepository {
  Future<Match> insert(Match match) async {
    final db = await AppData.database;

    await db.transaction((txn) async {
      int matchId = await txn.insert(Tables.match, match.toMap(),
          conflictAlgorithm: ConflictAlgorithm.fail);
      match.id = matchId;
      var teams = match.teams;

      for (var team in teams!) {
        team.match = match;
        // String inClause = team.players.map((e) => e.user.id!).join(",");
        // int? teamId = Sqflite.firstIntValue(await txn.rawQuery('''
        //   select t.${Tables.team}_id
        //   from ${Tables.team} t
        //   inner join ${Tables.team_player} tp
        //   on tp.${Tables.team_player}_team_id = t.${Tables.team}_id
        //   where tp.${Tables.team_player}_user_id in ($inClause)
        //   group by tp.${Tables.team_player}_id
        //   having count (*) = ${team.players.length}
        // '''));

        if (true) {
          team.id = await txn.insert(Tables.team, team.toMap());
          for (var player in team.players) {
            player.id = await txn.insert(Tables.team_player, player.toMap());
          }
        }
        // else {
        //   team.id = teamId;
        //   for (var player in team.players) {
        //     player.id = Sqflite.firstIntValue(await txn.rawQuery('''
        //       select tp.${Tables.team_player}_id
        //       from ${Tables.team_player} tp
        //       where tp.${Tables.team_player}_team_id = ${team.id} and tp.${Tables.team_player}_user_id = ${player.user.id!}
        //     '''));
        //   }
        // }
      }
    });

    return match;
  }

  Future<int> update(Match match) async {
    final db = await AppData.database;
    return db.update(Tables.match, match.toMap(),
        where: '${Tables.match}_id = ${match.id}');
  }

  Future<int> removeLastScore(Team team) async {
    final db = await AppData.database;
    int result = await db.rawDelete('''
          delete from ${Tables.team_score} 
          where ${Tables.team_score}_team_id = ${team.id} 
          and ${Tables.team_score}_created_at = (
            select max(${Tables.team_score}_created_at)
            from ${Tables.team_score}
            where ${Tables.team_score}_team_id = ${team.id} 
          )
        
        ''');

    return result;
  }

  Future<int> addScore(Team team, int score) async {
    String createdAt = DateUtils.instance.toDB(DateTime.now());
    final db = await AppData.database;
    int result = await db.rawInsert(
        "insert into ${Tables.team_score} (${Tables.team_score}_team_id, ${Tables.team_score}_score, ${Tables.team_score}_created_at) values (${team.id}, $score, '$createdAt')");
    await db.rawUpdate(
        "update ${Tables.team} set ${Tables.team}_status_id = ${team.status.id} where ${Tables.team}_id = ${team.id}");
    return result;
  }

  Future<void> setTeamStatusByMatch(Match m) async {
    final aux =
        m.teams!.where((element) => element.status.id == TeamStatus.WON);
    final Team wonTeam = aux.isNotEmpty
        ? aux.single
        : m.teams!
            .where((element) => element.status.id == TeamStatus.PLAYING)
            .single;
    wonTeam.status.id = TeamStatus.WON;
    final db = await AppData.database;
    await db.transaction((txn) async {
      for (var team in m.teams!) {
        if (wonTeam.id == team.id) {
          await txn.rawUpdate(
              "update ${Tables.team} set ${Tables.team}_status_id = ${TeamStatus.WON} where ${Tables.team}_id = ${team.id}");
        } else {
          await txn.rawUpdate(
              "update ${Tables.team} set ${Tables.team}_status_id = ${TeamStatus.LOST} where ${Tables.team}_id = ${team.id}");
        }
      }
    });
  }

  Future<Match?> getMatchByStatusAndGameId(int statusId, int gameId) async {
    final db = await AppData.database;

    final List<Map<String, dynamic>> maps = (await db.rawQuery('''
      SELECT * FROM ${Tables.match} m
      INNER JOIN ${Tables.game} g
      ON g.${Tables.game}_id = m.${Tables.match}_game_id
      INNER JOIN ${Tables.team} t
      ON m.${Tables.match}_id = t.${Tables.team}_match_id
      INNER JOIN ${Tables.team_player} tp
      on tp.${Tables.team_player}_team_id = t.${Tables.team}_id
      INNER JOIN ${Tables.user} u
      ON u.${Tables.user}_id = tp.${Tables.team_player}_user_id
      WHERE m.${Tables.match}_status_id = $statusId and  m.${Tables.match}_game_id = $gameId
    '''));

    if (maps.isEmpty) return null;

    Map<int, Team> teamMap = {};
    Match? m;

    for (final row in maps) {
      if (m == null) {
        m = Match(
          game: Game.fromJson(row),
          id: row['${Tables.match}_id'],
          statusId: row["${Tables.match}_status_id"],
          isFFA: row['${Tables.match}_ffa'] > 0,
          createdAt:
              DateUtils.instance.fromDB(row['${Tables.match}_created_at']),
          updatedAt:
              DateUtils.instance.fromDB(row['${Tables.match}_updated_at']),
        );
        m.teams = [];
      }

      var team = teamMap[row['${Tables.team}_id']];

      if (team == null) {
        team = Team(
            id: row['${Tables.team}_id'],
            match: m,
            name: row['${Tables.team}_name'],
            statusId: row['${Tables.team}_status_id'],
            asterisk: row['${Tables.team}_has_asterisk'] > 0,
            asteriskReason: row['${Tables.team}_asterisk_reason']);
        team.players = [];
        teamMap[row['${Tables.team}_id']] = team;
      }

      final teamPlayer = Player(
          id: row['${Tables.team_player}_id'],
          team: team,
          user: User.fromJson(row));

      team.players.add(teamPlayer);
    }

    if (m != null) {
      m.teams = teamMap.values.toList();

      final List<Map<String, dynamic>> scoreMap = (await db.rawQuery('''
      SELECT ts.* FROM ${Tables.team_score} ts
      INNER JOIN ${Tables.team} t
      ON t.${Tables.team}_id = ts.${Tables.team_score}_team_id
      WHERE t.${Tables.team}_match_id = ${m.id}
    '''));
      for (var scoreTable in scoreMap) {
        var team = m.teams!.firstWhere(
            (t) => t.id == scoreTable['${Tables.team_score}_team_id']);
        team.scoreList.add(scoreTable['${Tables.team_score}_score']);
      }
    }

    return m;
  }

  Future<int> setStatus(int matchId, int statusId) async {
    final db = await AppData.database;
    int result = await db.rawUpdate(
        "update ${Tables.match} set ${Tables.match}_status_id = $statusId");
    return result;
  }

  Future<int> cancelMatchesByGameId(int gameId) async {
    final db = await AppData.database;
    int result = await db.rawUpdate(
        "update ${Tables.match} set ${Tables.match}_status_id = ${MatchStatus.CANCELLED} where ${Tables.match}_status_id <> ${MatchStatus.ENDED} and ${Tables.match}_game_id = $gameId");
    return result;
  }

  //addPlayer
  //add
}
