import 'package:anotador/model/Game.dart';
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
}
