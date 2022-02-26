import 'package:anotador/model/game.dart';
import 'package:anotador/repositories/game_repository.dart';
import 'package:flutter/material.dart';

class GameController extends ChangeNotifier {
  final GameRepository _gameRepository = GameRepository();
  List<Game>? _games;

  List<Game>? get games => _games;

  GameController();

  Future<void> addGame(Game newGame) async {
    Game game = await _gameRepository.insert(newGame);
    _games ??= [];

    _games!.add(game);

    notifyListeners();
  }

  Future<void> initGameList() async {
    if (_games != null) {
      // _players!.sort(sortPlayers);
      return;
    }
    _games = await _gameRepository.games();
    await _gameRepository.setSummarizedStats(_games!);
    // _players!.sort(sortPlayers);
    notifyListeners();
  }

  Future<void> refreshStats() async {
    await _gameRepository.setSummarizedStats(_games!);
    notifyListeners();
  }
}
