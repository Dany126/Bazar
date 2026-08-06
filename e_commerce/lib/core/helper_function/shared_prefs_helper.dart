import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  SharedPrefsHelper._();

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String isLoggedInKey = "is_logged_in";

  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(isLoggedInKey, value);
  }

  static bool isLoggedIn() {
    return _prefs.getBool(isLoggedInKey) ?? false;
  }

  static Future<void> logout() async {
    await _prefs.remove(isLoggedInKey);
  }
}
