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

  Future<void> updateTargetScore(int targetScore) async {
    _selectedGame?.targetScore = targetScore; //TODO maybe a setter?
    //TODO call repository
    notifyListeners();
  }

  Future<void> updateScoreInfo(TrucoScore trucoScore) async {
    if (_selectedGame is TrucoGame) {
      TrucoGame tg = _selectedGame as TrucoGame;
      tg.targetScore = trucoScore.points;
      tg.twoHalves = trucoScore.twoHalves;
      //TODO call repository
      notifyListeners();
    }
  }

  Future<void> updateTargetScoreWins(bool targetScoreWins) async {
    _selectedGame?.targetScoreWins = targetScoreWins; //TODO maybe a setter?
    //TODO call repository
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
