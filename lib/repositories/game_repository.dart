import 'package:anotador/model/game.dart';
import 'package:anotador/model/match.dart';
import 'package:anotador/repositories/tables.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:sqflite/sqflite.dart';

class GameRepository {
  Future<Game> insert(Game game) async {
    final db = await AppData.database;

    int gameId = await db.insert(
      Tables.game,
      game.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    game.id = gameId;

    return game;
  }

  Future<List<Game>> games() async {
    final db = await AppData.database;

    final List<Map<String, dynamic>> maps = await db.query(Tables.game);

    return List.generate(maps.length, (i) {
      var json = maps[i];
      return Game.fromJson(json);
    });
  }

  Future<void> setSummarizedStats(List<Game> games) async {
    final db = await AppData.database;

    var resultMap = await db.rawQuery(''' 
    select game_id, is_me, count(*) as score_count
    from (
      select m.${Tables.match}_game_id as game_id, 1 is_me
      from ${Tables.match} m
      inner join ${Tables.team} t
      on m.${Tables.match}_id = t.${Tables.team}_match_id
      where t.${Tables.team}_status_id = ${TeamStatus.WON} and exists (
        select null
        from ${Tables.team_player} tp
        where t.${Tables.team}_id = tp.${Tables.team_player}_team_id and ${Tables.team_player}_user_id = 0
      )
      UNION ALL
      select m.${Tables.match}_game_id as game_id, 0 is_me
      from ${Tables.match} m
      inner join ${Tables.team} t
      on m.${Tables.match}_id = t.${Tables.team}_match_id
      where t.${Tables.team}_status_id = ${TeamStatus.LOST} and exists (
        select null
        from ${Tables.team_player} tp
        where t.${Tables.team}_id = tp.${Tables.team_player}_team_id and ${Tables.team_player}_user_id = 0
      )
    )
    group by game_id, is_me
    ''');

    for (var scoreTable in resultMap) {
      var game = games.firstWhere((g) => g.id == scoreTable['game_id']);
      int scoreCount = scoreTable['score_count'] as int;
      if (scoreTable['is_me'] as int > 0) {
        game.won = scoreCount;
      } else {
        game.lost = scoreCount;
      }
    }
  }
}
