import 'package:anotador/model/user.dart';
import 'package:anotador/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  List<User>? _players;

  List<User>? get players => _players;

  UserController();

  int sortPlayers(User a, User b) {
    if (a.favorite && b.favorite) {
      return a.name.compareTo(b.name);
    }

    if (a.favorite) {
      return 0;
    }

    if (b.favorite) {
      return 1;
    }
    return a.name.compareTo(b.name);
  }

  Future<void> addPlayer(User newPlayer) async {
    User player = await _userRepository.insertUser(newPlayer);
    _players ??= [];

    _players!.add(player);

    notifyListeners();
  }

  Future<void> editPlayer(User editedPlayer) async {
    // Id is not empty, is really modifying one user
    await _userRepository.insertUser(editedPlayer);

    var pOnList =
        _players!.where((player) => player.id == editedPlayer.id).single;

    pOnList.name = editedPlayer.name;
    pOnList.initial = editedPlayer.initial;
    pOnList.favorite = editedPlayer.favorite;

    notifyListeners();
  }

  Future<void> deletePlayerById(int playerId) async {
    int wasDeleted = await _userRepository.delete(playerId);
    if (wasDeleted > 0) {
      _players!.removeWhere((player) => player.id == playerId);
      notifyListeners();
    }
  }

  Future<void> initPlayerList() async {
    if (_players != null) {
      _players!.sort(sortPlayers);
      return;
    }
    _players = await _userRepository.users();
    _players!.sort(sortPlayers);
    notifyListeners();
  }
}
