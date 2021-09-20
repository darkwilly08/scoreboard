import 'package:anotador/model/User.dart';
import 'package:anotador/repositories/tables.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  Future<User> insertUser(User user) async {
    final db = await AppData.database;

    int userId = await db.insert(
      Tables.user,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    user.id = userId;

    return user;
  }

  Future<List<User>> users() async {
    // Get a reference to the database.
    final db = await AppData.database;

    final List<Map<String, dynamic>> maps = await db.query(Tables.user);

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        initial: maps[i]['initial'],
        favorite: maps[i]['favorite'] > 0,
      );
    });
  }

  Future<void> delete(int userId) async {
    final db = await AppData.database;

    await db.delete(Tables.user, where: 'id = ?', whereArgs: [userId]);
  }
}
