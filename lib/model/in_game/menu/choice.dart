import 'package:flutter/material.dart';

class Choice {
  static const int addTeam = 1;
  static const int restartMatch = 2;
  static const int goToSettings = 3;
  static const int exit = 4;
  const Choice({required this.title, required this.icon, required this.type});

  final String title;
  final IconData icon;
  final int type;
}
