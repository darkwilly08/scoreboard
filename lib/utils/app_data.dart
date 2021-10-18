import 'package:anotador/model/Game.dart';
import 'package:anotador/model/User.dart';
import 'package:anotador/repositories/tables.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class AppData {
  static late SharedPreferences sharedPreferences;
  static late PackageInfo packageInfo;
  static late Future<Database> database;
  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();
    database = openDatabase(join(await getDatabasesPath(), 'scoreboard.db'),
        onCreate: (Database db, version) async {
      await db.execute(
        'CREATE TABLE ${Tables.user}(${Tables.user}_id integer primary key autoincrement, ${Tables.user}_name text not null, ${Tables.user}_initial text not null, ${Tables.user}_favorite integer not null)',
      );
      await db.execute(
        'CREATE TABLE ${Tables.game}(${Tables.game}_id integer primary key autoincrement, ${Tables.game}_name text not null, ${Tables.game}_type_id integer not null, ${Tables.game}_target_score int not null, ${Tables.game}_target_score_wins integer not null, ${Tables.game}_two_halves integer)',
      );

      await db.execute(
        'CREATE TABLE ${Tables.match}(${Tables.match}_id integer primary key autoincrement, ${Tables.match}_game_id integer not null, ${Tables.match}_won_user_id integer, ${Tables.match}_status_id integer not null, ${Tables.match}_created_at TEXT not null, ${Tables.match}_updated_at TEXT not null, ${Tables.match}_end_at TEXT, FOREIGN KEY(${Tables.match}_game_id) REFERENCES ${Tables.game}(${Tables.game}_id), FOREIGN KEY(${Tables.match}_won_user_id) REFERENCES ${Tables.user}(${Tables.user}_id))',
      );

      await db.execute(
        'CREATE TABLE ${Tables.match_player}(${Tables.match_player}_id integer primary key autoincrement, ${Tables.match_player}_match_id integer not null, ${Tables.match_player}_user_id integer not null, ${Tables.match_player}_has_asterisk integer not null, ${Tables.match_player}_asterisk_reason TEXT, ${Tables.match_player}_status_id integer not null, FOREIGN KEY(${Tables.match_player}_match_id) REFERENCES ${Tables.match}(${Tables.match}_id), FOREIGN KEY(${Tables.match_player}_user_id) REFERENCES ${Tables.user}(${Tables.user}_id))',
      );

      await db.execute(
        'CREATE TABLE ${Tables.player_score}(${Tables.player_score}_match_player_id integer not null, ${Tables.player_score}_score integer not null, FOREIGN KEY(${Tables.player_score}_match_player_id) REFERENCES ${Tables.match_player}(${Tables.match_player}_id))',
      );

      await db.insert(
        Tables.user,
        User(id: 0, name: 'Me', initial: 'M', favorite: true).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await db.insert(Tables.game,
          Game(name: "Uno", targetScore: 201, targetScoreWins: false).toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
      await db.insert(
          Tables.game,
          Game(name: "Diez Mil", targetScore: 10000, targetScoreWins: true)
              .toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
      await db.insert(
          Tables.game,
          TrucoGame(
                  name: "Truco",
                  targetScore: 30,
                  targetScoreWins: true,
                  twoHalves: true)
              .toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }, version: 1);
  }
}
