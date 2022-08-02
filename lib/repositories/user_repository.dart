import 'package:anotador/model/user.dart';
import 'package:anotador/repositories/tables.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  Future<User> insertUser(User user, {bool isOwner = false}) async {
    final db = await AppData.database;

    if (isOwner) {
      user.id = 0;
    }

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
      var json = maps[i];
      return User.fromJson(json);
    });
  }

  Future<int> delete(int userId) async {
    if (userId == 0) {
      return 0; // Owner user cannot be deleted
    }
    final db = await AppData.database;

    return await db.delete(Tables.user,
        where: '${Tables.user}_id = ?', whereArgs: [userId]);
  }
}
