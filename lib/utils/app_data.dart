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
        'CREATE TABLE ${Tables.user}(id integer primary key autoincrement, name text not null, initial text not null, favorite integer not null)',
      );
      await db.execute(
        'CREATE TABLE ${Tables.game}(id integer primary key autoincrement, name text not null, type_id integer not null, target_score int not null, target_score_wins integer not null, two_halves integer)',
      );

      await db.execute(
        'CREATE TABLE ${Tables.match}(id integer primary key autoincrement, game_id integer not null, won_user_id integer not null, status_id integer not null, created_at TEXT not null, updated_at TEXT not null, end_at TEXT)',
      );

      await db.execute(
        'CREATE TABLE ${Tables.match_player}(match_id integer not null, user_id integer not null, has_asterisk integer, asterisk_reason TEXT, status_id integer not null)',
      );

      await db.insert(
        Tables.user,
        User(id: 0, name: 'Me', initial: 'M', favorite: true).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }, version: 1);
  }
}
