import 'package:anotador/repositories/tables.dart';

class User {
  int? id;
  String name;
  String initial;
  bool favorite;

  User(
      {this.id,
      required this.name,
      required this.initial,
      required bool this.favorite});

  Map<String, dynamic> toMap() {
    return {
      '${Tables.user}_id': id,
      '${Tables.user}_name': name,
      '${Tables.user}_initial': initial,
      '${Tables.user}_favorite': favorite ? 1 : 0,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['${Tables.user}_id'],
        name: json['${Tables.user}_name'],
        initial: json['${Tables.user}_initial'],
        favorite: json['${Tables.user}_favorite'] > 0);
  }
}
