import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _streakKey = 'streak';
  static const _starKey = 'star';
  static const _lastPlayKey = 'last_play';

  static Future<Map<String, int>> load() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'streak': prefs.getInt(_streakKey) ?? 1,
      'star': prefs.getInt(_starKey) ?? 1,
    };
  }

  static Future<void> onQuizFinished(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final last = prefs.getString(_lastPlayKey);
    final lastDate =
        last == null ? null : DateTime.parse(last);

    int streak = prefs.getInt(_streakKey) ?? 1;
    int star = prefs.getInt(_starKey) ?? 1;

    // streak logic (daily)
    if (lastDate == null ||
        today.difference(lastDate).inDays == 1) {
      streak++;
    } else if (today.difference(lastDate).inDays > 1) {
      streak = 1;
    }

    // star logic (10 correct = +1 star)
    if (score >= 10) star++;

    await prefs.setInt(_streakKey, streak);
    await prefs.setInt(_starKey, star);
    await prefs.setString(_lastPlayKey, today.toIso8601String());
  }
}
