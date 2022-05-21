import 'package:anotador/model/game_type.dart';
import 'dart:core';

class Helpers {
  static Map<int, String> scoreboardTypeByGameType = {
    GameType.TRUCO: 'fosforos',
    GameType.NORMAL: 'numeros',
  };
}