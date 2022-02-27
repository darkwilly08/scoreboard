import 'package:anotador/model/game.dart';
import 'package:anotador/model/truco_game.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/repositories/tables.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
      await db.transaction((txn)async {
      await txn.execute(
      'CREATE TABLE ${Tables.user}(${Tables.user}_id integer primary key autoincrement, ${Tables.user}_name text not null, ${Tables.user}_initial text not null, ${Tables.user}_favorite integer not null)',
      );

        await txn.execute(
        'CREATE TABLE ${Tables.game}(${Tables.game}_id integer primary key autoincrement, ${Tables.game}_name text not null, ${Tables.game}_type_id integer not null, ${Tables.game}_target_score int not null, ${Tables.game}_target_score_wins integer not null, ${Tables.game}_is_negative_allowed integer not null, ${Tables.game}_two_halves integer, ${Tables.game}_np_min_val integer, ${Tables.game}_np_max_val integer, ${Tables.game}_np_step integer)',
      );

      await txn.execute(
        'CREATE TABLE ${Tables.match}(${Tables.match}_id integer primary key autoincrement, ${Tables.match}_game_id integer not null, ${Tables.match}_status_id integer not null, ${Tables.match}_ffa integer not null, ${Tables.match}_created_at TEXT not null, ${Tables.match}_updated_at TEXT not null, ${Tables.match}_end_at TEXT, FOREIGN KEY(${Tables.match}_game_id) REFERENCES ${Tables.game}(${Tables.game}_id))',
      );

      await txn.execute(
        'CREATE TABLE ${Tables.team}(${Tables.team}_id integer primary key autoincrement, ${Tables.team}_match_id integer not null, ${Tables.team}_name text not null, ${Tables.team}_has_asterisk integer not null, ${Tables.team}_asterisk_reason TEXT, ${Tables.team}_status_id integer not null, FOREIGN KEY(${Tables.team}_match_id) REFERENCES ${Tables.match}(${Tables.match}_id))',
      );

      await txn.execute(
        'CREATE TABLE ${Tables.team_player}(${Tables.team_player}_id integer primary key autoincrement, ${Tables.team_player}_team_id integer not null, ${Tables.team_player}_user_id integer not null, FOREIGN KEY(${Tables.team_player}_team_id) REFERENCES ${Tables.team}(${Tables.team}_id), FOREIGN KEY(${Tables.team_player}_user_id) REFERENCES ${Tables.user}(${Tables.user}_id))',
      );

      await txn.execute(
        'CREATE TABLE ${Tables.team_score}(${Tables.team_score}_team_id integer not null, ${Tables.team_score}_score integer not null, ${Tables.team_score}_created_at TEXT not null, FOREIGN KEY(${Tables.team_score}_team_id) REFERENCES ${Tables.team}(${Tables.team}_id))',
      );

      await txn.insert(
        Tables.user,
        User(id: 0, name: 'Me', initial: 'M', favorite: true).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await txn.insert(
          Tables.game,
          Game(
              name: "Uno",
              targetScore: 201,
              targetScoreWins: false,
              isNegativeAllowed: true,
              npMinVal: 0,
              npMaxVal: 100,
              npStep: 1)
              .toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
      await txn.insert(
          Tables.game,
          Game(
              name: "Diez Mil",
              targetScore: 10000,
              targetScoreWins: true,
              isNegativeAllowed: true,
              npMinVal: 200,
              npMaxVal: 1000,
              npStep: 50)
              .toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
      await txn.insert(
          Tables.game,
          TrucoGame(
              name: "Truco",
              targetScore: 30,
              targetScoreWins: true,
              twoHalves: true)
              .toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
      });
    }, version: 1);
  }
}
