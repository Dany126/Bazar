import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  SharedPrefsHelper._();

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String isLoggedInKey = 'is_logged_in';
  static const String userRoleKey = 'user_role';

  // =========================
  // LOGIN
  // =========================

  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(isLoggedInKey, value);
  }

  static bool isLoggedIn() {
    return _prefs.getBool(isLoggedInKey) ?? false;
  }

  // =========================
  // ROLE
  // =========================

  static Future<void> setUserRole(String role) async {
    await _prefs.setString(userRoleKey, role.trim().toUpperCase());
  }

  static String getUserRole() {
    return _prefs.getString(userRoleKey) ?? 'USER';
  }

  static bool isAdmin() {
    return getUserRole() == 'ADMIN';
  }

  // =========================
  // LOGOUT
  // =========================

  static Future<void> logout() async {
    await _prefs.remove(isLoggedInKey);
    await _prefs.remove(userRoleKey);
  }
}
