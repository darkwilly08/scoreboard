import 'package:anotador/model/game.dart';
import 'package:anotador/model/match.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/repositories/match_repository.dart';
import 'package:flutter/material.dart';

class MatchController extends ChangeNotifier {
  MatchRepository _matchRepository = MatchRepository();
  Match? _match;

  Match? get match => _match;

  MatchController();

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

  Future<void> addPlayer(User user) async {
    if (_match == null) {
      throw Exception("match is not initilized");
    }

    // _match!.players.add(
    //     MatchPlayer(match: _match!, user: user, statusId: PlayerStatus.WON));

    // await _matchRepository.addPlayer(_match);
    notifyListeners();
  }

  Future<void> cancelMatchesByGameId(int gameId) async {
    await _matchRepository.cancelMatchesByGameId(gameId);
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

    if (team.status.id == TeamStatus.WON ||
        ((_match!.teams!.length -
                _match!.teams!
                    .where((p) => p.status.id == TeamStatus.LOST)
                    .length) ==
            1)) {
      _match!.status.id = MatchStatus.ENDED;
      _match!.endAt = DateTime.now();
      _matchRepository.setTeamStatusByMatch(_match!);
      notifyListeners();
    } else {
      _match!.status.id = MatchStatus.IN_PROGRES;
    }

    await _matchRepository.update(_match!);
  }
}
