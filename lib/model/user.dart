import 'package:anotador/repositories/tables.dart';
import 'package:flutter/material.dart';

class User {
  int? id;
  String name;
  String initial;
  bool favorite;

  User(
      {this.id,
      required this.name,
      required this.initial,
      required this.favorite});

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

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType || other is! User) {
      return false;
    }

    User otherUser = other;

    if ((otherUser.id != null || id != null) && otherUser.id != id) {
      return false;
    }

    if (otherUser.name != name) {
      return false;
    }

    return true;
  }

  @override
  int get hashCode => hashValues(id, name);
}
