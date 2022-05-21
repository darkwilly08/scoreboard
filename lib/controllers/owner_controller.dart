import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/repositories/user_repository.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:flutter/foundation.dart';

class OwnerController extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  bool _onboardingCompleted = false;

  OwnerController() {
    _onboardingCompleted = _initFromSharedPreferences();
  }

  bool get isOnboardingCompleted => _onboardingCompleted;

  Future<void> createOwner(String displayname) async {
    final user = User(
        name: displayname,
        initial: displayname[0].toUpperCase(),
        favorite: true);
    await _userRepository.insertUser(user, isOwner: true);
    _onboardingCompleted = true;
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    await AppData.sharedPreferences
        .setBool(PreferenceKeys.ownerReadyKey, _onboardingCompleted);
  }

  bool _initFromSharedPreferences() {
    return AppData.sharedPreferences.getBool(PreferenceKeys.ownerReadyKey) ??
        false;
  }
}
