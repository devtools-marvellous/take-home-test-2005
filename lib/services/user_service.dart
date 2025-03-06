import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '/config/constants.dart';
import '/models/user.model.dart';

abstract class UserManager {
  Future<void> storeUserData(User verifiedUser);
  Future<User> retrieveUserData();
  Future<void> removeUserData();
}

class UserService implements UserManager {
  UserService(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> storeUserData(User verifiedUser) async {
    await _prefs.setString(userKey, jsonEncode(verifiedUser.toJson()));
  }

  @override
  Future<User> retrieveUserData() async {
    String cachedUser = _prefs.getString(userKey) ?? '';
    if (cachedUser.isNotEmpty) {
      return User.fromJson(jsonDecode(cachedUser));
    } else {
      throw Exception('User data not found');
    }
  }

  @override
  Future<void> removeUserData() async {
    await _prefs.remove(userKey);
  }
}
