import 'package:anotador/model/Game.dart';
import 'package:anotador/repositories/game_repository.dart';
import 'package:flutter/material.dart';

class GameController extends ChangeNotifier {
  GameRepository _gameRepository = GameRepository();
  List<Game>? _games;

  List<Game>? get games => _games;

  GameController();

  Future<void> AddGame(Game newGame) async {
    Game game = await _gameRepository.insert(newGame);
    if (_games == null) {
      _games = [];
    }

    _games!.add(game);

    notifyListeners();
  }

  Future<void> initGameList() async {
    if (_games != null) {
      // _players!.sort(sortPlayers);
      return;
    }
    _games = await _gameRepository.games();
    // _players!.sort(sortPlayers);
    notifyListeners();
  }
}
