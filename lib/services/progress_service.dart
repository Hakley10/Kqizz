import 'streak_star_service.dart';

/// Thin compatibility wrapper. Delegate all logic to `StreakStarService`
/// so the app uses a single source of truth for points/stars/streak.
class ProgressService {
  static Future<Map<String, int>> load() async {
    final streak = await StreakStarService.getStreak();
    final star = await StreakStarService.getStars();

    return {'streak': streak, 'star': star};
  }

  static Future<void> onQuizFinished(int score) async {
    await StreakStarService.onQuizCompleted(correctAnswers: score);
  }
}
