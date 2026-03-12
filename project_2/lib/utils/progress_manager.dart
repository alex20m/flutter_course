import 'package:shared_preferences/shared_preferences.dart';

class ProgressManager {
  static const String _keyPrefix = 'level_completed_';

  static Future<void> markLevelCompleted(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_keyPrefix$level', true);
  }

  static Future<bool> isLevelCompleted(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_keyPrefix$level') ?? false;
  }

  static Future<List<bool>> getAllLevelsStatus(int totalLevels) async {
    final statuses = <bool>[];
    for (int i = 1; i <= totalLevels; i++) {
      statuses.add(await isLevelCompleted(i));
    }
    return statuses;
  }
}
