import 'dart:math';

import 'package:anotador/model/game.dart';
import 'package:anotador/model/truco/truco_score.dart';
import 'package:anotador/model/truco_game.dart';
import 'package:anotador/repositories/game_repository.dart';
import 'package:flutter/material.dart';

class GameController extends ChangeNotifier {
  final GameRepository _gameRepository = GameRepository();
  List<Game>? _games;
  Game? _selectedGame;

  List<Game>? get games => _games;

  Game? get selectedGame => _selectedGame;

  GameController();

  Future<void> setSelected(Game? game) async {
    _selectedGame = game;
  }

  Game createEmptyGame(String name) {
    Game game = Game(
        name: name,
        targetScore: 100,
        targetScoreWins: true,
        isNegativeAllowed: false,
        npMaxVal: 100,
        npMinVal: 0,
        npStep: 10);

    return game;
  }

  void recalculateNp(Game game) {
    if (game.npMaxVal != null && game.npMinVal != null) {
      game.npMaxVal = min(game.targetScore, game.npMaxVal!);
      game.npMinVal = min(game.targetScore - 1, game.npMinVal!);

      int range = ((game.npMaxVal! - game.npMinVal!) / 2).floor();
      range == 0 ? 1 : range;

      game.npStep = min(range, game.npStep!);
    }
  }

  Future<void> updateTargetScore(int targetScore) async {
    if (_selectedGame == null) {
      throw Exception("game is not selected yet");
    }

    _selectedGame?.targetScore = targetScore; //TODO maybe a setter?
    recalculateNp(_selectedGame!);

    _gameRepository.update(_selectedGame!);
    notifyListeners();
  }

  Future<void> updateNpMin(int min) async {
    if (_selectedGame == null) {
      throw Exception("game is not selected yet");
    }

    _selectedGame?.npMinVal = min; //TODO maybe a setter?
    recalculateNp(_selectedGame!);

    _gameRepository.update(_selectedGame!);
    notifyListeners();
  }

  Future<void> updateNpMax(int max) async {
    if (_selectedGame == null) {
      throw Exception("game is not selected yet");
    }

    _selectedGame?.npMaxVal = max; //TODO maybe a setter?
    recalculateNp(_selectedGame!);

    _gameRepository.update(_selectedGame!);
    notifyListeners();
  }

  Future<void> updateNpStep(int step) async {
    if (_selectedGame == null) {
      throw Exception("game is not selected yet");
    }

    _selectedGame?.npStep = step; //TODO maybe a setter?
    recalculateNp(_selectedGame!);

    _gameRepository.update(_selectedGame!);
    notifyListeners();
  }

  Future<void> updateScoreInfo(TrucoScore trucoScore) async {
    if (_selectedGame == null) {
      throw Exception("game is not selected yet");
    }
    if (_selectedGame is TrucoGame) {
      TrucoGame tg = _selectedGame as TrucoGame;
      tg.targetScore = trucoScore.points;
      tg.twoHalves = trucoScore.twoHalves;
      _gameRepository.update(_selectedGame!);
      notifyListeners();
    }
  }

  Future<void> updateTargetScoreWins(bool targetScoreWins) async {
    if (_selectedGame == null) {
      throw Exception("game is not selected yet");
    }
    _selectedGame?.targetScoreWins = targetScoreWins; //TODO maybe a setter?
    _gameRepository.update(_selectedGame!);
    notifyListeners();
  }

  Future<void> updateGameName(String newName) async {
    if (_selectedGame == null) {
      throw Exception("game is not selected yet");
    }

    _selectedGame!.name = newName; //TODO maybe a setter?
    _gameRepository.update(_selectedGame!);
    notifyListeners();
  }

  Future<void> updateNegativeAllowed(bool isNegativeAllowed) async {
    if (_selectedGame == null) {
      throw Exception("game is not selected yet");
    }

    _selectedGame!.isNegativeAllowed = isNegativeAllowed; //TODO maybe a setter?
    _gameRepository.update(_selectedGame!);
    notifyListeners();
  }

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
