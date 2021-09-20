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
        'CREATE TABLE ${Tables.User}(id integer primary key autoincrement, name text not null, initial text not null, favorite integer not null)',
      );

      await db.insert(
        Tables.User,
        User(id: 0, name: 'Me', initial: 'M', favorite: true).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }, version: 1);
  }
}
