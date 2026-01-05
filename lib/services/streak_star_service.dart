import 'package:shared_preferences/shared_preferences.dart';

class StreakStarService {
  static const String _streakKey = 'streak_count';
  static const String _starsKey = 'stars_count';
  static const String _lastVisitDateKey = 'last_visit_date';
  static const String _earnedStarsTodayKey = 'earned_stars_today';

  // Add streak when user opens the app
  static Future<void> addStreakOnAppOpen() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Get last visit date
    final lastVisitMillis = prefs.getInt(_lastVisitDateKey) ?? 0;
    final lastVisitDate = lastVisitMillis == 0 
        ? null 
        : DateTime.fromMillisecondsSinceEpoch(lastVisitMillis);
    
    // Check if it's a new day
    if (lastVisitDate == null || lastVisitDate.isBefore(today)) {
      // Reset earned stars for the new day
      await prefs.setInt(_earnedStarsTodayKey, 0);
      
      // Check if user visited yesterday for streak continuity
      final yesterday = today.subtract(const Duration(days: 1));
      final lastVisitWasYesterday = lastVisitDate != null && 
          DateTime(lastVisitDate.year, lastVisitDate.month, lastVisitDate.day) == yesterday;
      
      if (lastVisitWasYesterday) {
        // Continue streak
        final currentStreak = prefs.getInt(_streakKey) ?? 0;
        await prefs.setInt(_streakKey, currentStreak + 1);
      } else if (lastVisitDate == null || lastVisitDate.isBefore(yesterday)) {
        // Break streak - start from 1
        await prefs.setInt(_streakKey, 1);
      }
      // If visited today already, do nothing for streak
    }
    
    // Update last visit date to today
    await prefs.setInt(_lastVisitDateKey, today.millisecondsSinceEpoch);
  }

  // Add stars when quiz is completed
  static Future<void> addStars(int earnedStars) async {
    final prefs = await SharedPreferences.getInstance();
    final currentStars = prefs.getInt(_starsKey) ?? 0;
    await prefs.setInt(_starsKey, currentStars + earnedStars);
  }

  // Get current streak
  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  // Get total stars
  static Future<int> getStars() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_starsKey) ?? 0;
  }

  // Reset all data (for testing/debugging)
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_streakKey);
    await prefs.remove(_starsKey);
    await prefs.remove(_lastVisitDateKey);
    await prefs.remove(_earnedStarsTodayKey);
  }
}