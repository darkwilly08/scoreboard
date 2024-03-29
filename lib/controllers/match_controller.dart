import 'package:anotador/controllers/game_controller.dart';
import 'package:anotador/model/game.dart';
import 'package:anotador/model/match.dart';
import 'package:anotador/model/match_status.dart';
import 'package:anotador/model/team.dart';
import 'package:anotador/model/team_status.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/repositories/match_repository.dart';
import 'package:flutter/material.dart';

class MatchController extends ChangeNotifier {
  GameController? _gameController;
  final MatchRepository _matchRepository = MatchRepository();
  Match? _match;

  Match? get match => _match;

  MatchController();

  MatchController update(GameController? gameController) {
    _gameController = gameController;
    return this;
  }

  Future<void> start(Game game, bool isFFA, List<Team> teams) async {
    _match = Match(
        game: game,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        statusId: MatchStatus.CREATED,
        isFFA: isFFA,
        teams: teams);

    await _matchRepository.insert(_match!);
    notifyListeners();
  }

  Future<Match?> getMatchInProgressByGameId(int gameId) async {
    return _matchRepository.getMatchByStatusAndGameId(
        MatchStatus.IN_PROGRES, gameId);
  }

  void continueMatch(Match match) {
    _match = match;
    notifyListeners();
  }

  Future<void> restartMatch() async {
    await cancelMatchesByGameId(
        _match!.game.id!); //to be sure there is no match in progress
    // regenerate teams
    List<Team> newTeams =
        _match!.teams!.map((team) => Team.createCopy(team)).toList();
    start(_match!.game, _match!.isFFA, newTeams);
  }

  Future<void> addTeam(Team team) async {
    if (_match == null) {
      throw Exception("match is not initilized");
    }
    team.match = _match;
    _match!.teams!.add(team);
    await _matchRepository.addTeam(team);
    notifyListeners();
  }

  Future<void> cancelMatchesByGameId(int gameId) async {
    await _matchRepository.cancelMatchesByGameId(gameId);
  }

  Future<void> removeLatestResult(Team team) async {
    bool wasRemoved = await team.removeLast();
    if (wasRemoved) {
      await _matchRepository.removeLastScore(team);
    }
  }

  /* TODO: Review this method. I think this should be responsibility of Match
        Maybe something like isOnePlayerStanding() */
  bool hasOthersLost() {
    // all lost except you
    return (_match!.teams!.length -
            _match!.teams!
                .where((p) => p.status.id == TeamStatus.LOST)
                .length) ==
        1;
  }

  Future<void> addResult(Team team, int value) async {
    bool wasAdded = await team.addResult(value);
    if (wasAdded) {
      await _matchRepository.addScore(team, team.scoreList.last);
    }

    // if (_match!.status.id == MatchStatus.ENDED) {
    //   if (player.user.id == _match!.wonPlayer!.id) {
    //     _match!.status.id = MatchStatus.IN_PROGRES;
    //     _match!.endAt = null;
    //     _match!.wonPlayer = null;
    //     notifyListeners();
    //   } else {
    //     return; //you can keep playing but
    //   }
    // }

    if (team.status.id == TeamStatus.WON || hasOthersLost()) {
      _match!.status.id = MatchStatus.ENDED;
      _match!.endAt = DateTime.now();
      await _matchRepository.setTeamStatusByMatch(_match!);
      await _gameController?.refreshStats();
      notifyListeners();
    } else {
      _match!.status.id = MatchStatus.IN_PROGRES;
    }

    await _matchRepository.update(_match!);
  }
}
