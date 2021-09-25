import 'package:anotador/model/Game.dart';
import 'package:anotador/model/Match.dart';
import 'package:anotador/model/User.dart';
import 'package:flutter/material.dart';

class MatchController extends ChangeNotifier {
  // MatchRepository _matchRepository = MatchRepository();
  Match? _match;

  Match? get match => _match;

  MatchController();

  Future<void> start(Game game, List<User> users) async {
    _match = Match(
        game: game,
        users: users,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        statusId: MatchStatus.CREATED);

    // await _matchRepository.insert(_match);
    notifyListeners();
  }

  Future<void> addPlayer(User user) async {
    if (_match == null) {
      throw Exception("match is not initilized");
    }

    _match!.players.add(
        MatchPlayer(match: _match!, user: user, statusId: PlayerStatus.WON));

    // await _matchRepository.addPlayer(_match);
    notifyListeners();
  }

  Future<void> addResult(MatchPlayer player, int value) async {
    player.addResult(value);

    if (_match!.status.id == MatchStatus.ENDED) {
      if (player.user.id == _match!.wonPlayer!.id) {
        _match!.status.id = MatchStatus.IN_PROGRES;
        _match!.endAt = null;
        _match!.wonPlayer = null;
        notifyListeners();
      } else {
        return; //you can keep playing but
      }
    }

    if (player.status.id == PlayerStatus.WON ||
        ((_match!.players.length -
                _match!.players
                    .where((p) => p.status.id == PlayerStatus.LOST)
                    .length) ==
            1)) {
      _match!.status.id = MatchStatus.ENDED;
      _match!.endAt = DateTime.now();
      _match!.wonPlayer = player.user;
      notifyListeners();
    } else {
      _match!.status.id = MatchStatus.IN_PROGRES;
    }
  }
}
