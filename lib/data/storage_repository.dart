import 'package:shared_preferences/shared_preferences.dart';

/// Persist data locally in the device. 
/// Refactor: All shared preferences entries in the app should be move to this class.
class StorageRepository {

  SharedPreferences? _prefs;

  // Key for remember me checkbox
  final String _rememberMeKey = "KEY_REMEMBER_ME";

  StorageRepository() {
    SharedPreferences.getInstance().then((value) => 
    _prefs = value
    );
}

  void saveRememberMe(bool? rememberMe) {
    _prefs?.setBool(_rememberMeKey, rememberMe ?? false);
  }

  bool getRememberMe() {
    return _prefs?.getBool(_rememberMeKey) ?? false;
  }
}
