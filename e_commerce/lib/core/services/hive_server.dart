import 'package:hive_flutter/hive_flutter.dart';

/// Central Hive setup + box access, mirrors the role of ApiService
/// for local/offline persistence.
class HiveService {
  static const String authBoxName = 'authBox';

  /// Call once in main() before runApp(), after WidgetsFlutterBinding.ensureInitialized().
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(authBoxName);
  }

  static Box get authBox => Hive.box(authBoxName);

  /// Generic helpers if you end up needing other boxes later.
  static Future<Box> openBox(String name) async {
    if (Hive.isBoxOpen(name)) return Hive.box(name);
    return Hive.openBox(name);
  }

  static Future<void> closeAll() => Hive.close();

  /// Wipes all local Hive data (e.g. on full app reset / logout-everywhere).
  static Future<void> clearAll() async {
    await authBox.clear();
  }
}
