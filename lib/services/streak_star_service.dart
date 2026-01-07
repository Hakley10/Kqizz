import 'package:shared_preferences/shared_preferences.dart';

class StreakStarService {
  static const _pointsKey = 'points';
  static const _starsKey = 'stars';
  static const _streakKey = 'streak';
  static const _lastPlayedKey = 'last_played_date';

  /// Call this AFTER quiz is finished
  static Future<void> onQuizCompleted({
    required int correctAnswers,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // ---------- STAR SYSTEM ----------
    int points = prefs.getInt(_pointsKey) ?? 0;
    int stars = prefs.getInt(_starsKey) ?? 1;

    points += correctAnswers;

    // Every 10 points = +1 star
    final newStars = (points ~/ 10) + 1;

    if (newStars > stars) {
      stars = newStars;
    }

    await prefs.setInt(_pointsKey, points);
    await prefs.setInt(_starsKey, stars);

    // ---------- STREAK SYSTEM ----------
    final today = DateTime.now();
    final todayDate =
        DateTime(today.year, today.month, today.day);

    final lastPlayedMillis = prefs.getInt(_lastPlayedKey);
    int streak = prefs.getInt(_streakKey) ?? 0;

    if (lastPlayedMillis == null) {
      // First time playing
      streak = 1;
    } else {
      final lastPlayed =
          DateTime.fromMillisecondsSinceEpoch(lastPlayedMillis);
      final lastDate =
          DateTime(lastPlayed.year, lastPlayed.month, lastPlayed.day);

      final difference = todayDate.difference(lastDate).inDays;

      if (difference == 1) {
        streak += 1; // continue streak
      } else if (difference > 1) {
        streak = 1; // reset streak
      }
      // difference == 0 → same day → do nothing
    }

    await prefs.setInt(_streakKey, streak);
    await prefs.setInt(
      _lastPlayedKey,
      todayDate.millisecondsSinceEpoch,
    );
  }

  // ---------- GETTERS ----------

  static Future<int> getStars() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_starsKey) ?? 1;
  }

  static Future<int> getPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pointsKey) ?? 0;
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }
}
