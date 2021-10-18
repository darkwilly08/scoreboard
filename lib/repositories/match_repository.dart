import 'package:anotador/model/Match.dart';
import 'package:anotador/repositories/tables.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:sqflite/sqflite.dart';

class MatchRepository {
  Future<Match> insert(Match match) async {
    final db = await AppData.database;

    await db.transaction((txn) async {
      int matchId = await txn.insert(Tables.match, match.toMap(),
          conflictAlgorithm: ConflictAlgorithm.fail);
      match.id = matchId;
      var players = match.players;

      for (var player in players) {
        player.id = await txn.insert(Tables.match_player, player.toMap());
      }
    });

    return match;
  }

  Future<int> addScore(MatchPlayer player, int score) async {
    final db = await AppData.database;
    int result = await db.rawInsert(
        "insert into ${Tables.player_score} (${Tables.player_score}_match_player_id, ${Tables.player_score}_score) values (${player.id}, $score)");
    return result;
  }

  Future<Match?> getMatchByStatusAndGameId(int statusId, int gameId) async {
    final db = await AppData.database;

    final List<Map<String, dynamic>> maps = (await db.rawQuery('''
      SELECT * FROM ${Tables.match} m
      INNER JOIN ${Tables.game} g
      ON g.${Tables.game}_id = m.${Tables.match}_game_id
      INNER JOIN ${Tables.match_player} mp
      ON m.${Tables.match}_id = ${Tables.match_player}_match_id
      INNER JOIN ${Tables.user} u
      ON u.${Tables.user}_id = mp.${Tables.match_player}_user_id
      WHERE m.${Tables.match}_status_id = $statusId and  m.${Tables.match}_game_id = $gameId
    '''));

    if (maps.length == 0) return null;

    var m = Match.fromJson(maps);

    final List<Map<String, dynamic>> scoreMap = (await db.rawQuery('''
      SELECT ps.* FROM ${Tables.player_score} ps
      INNER JOIN ${Tables.match_player} mp
      ON mp.${Tables.match_player}_id = ps.${Tables.player_score}_match_player_id
      WHERE ${Tables.match_player}_match_id = ${m.id}
    '''));

    for (var scoreTable in scoreMap) {
      var player = m.players.firstWhere(
          (p) => p.id == scoreTable['${Tables.player_score}_match_player_id']);
      player.scoreList.add(scoreTable['${Tables.player_score}_score']);
    }
    return m;
  }

  Future<int> setStatus(int matchId, int statusId) async {
    final db = await AppData.database;
    int result = await db.rawUpdate(
        "update ${Tables.match} set ${Tables.match}_status_id = $statusId");
    return result;
  }

  //addPlayer
  //add
}
