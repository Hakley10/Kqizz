import 'package:flutter/material.dart';
import '../../services/streak_star_service.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final VoidCallback? onStarsUpdated;

  const QuizResultScreen({super.key, required this.score, this.onStarsUpdated});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late int starsEarned;
  bool starsSaved = false;

  @override
  void initState() {
    super.initState();
    starsEarned = widget.score; // 1 star per correct answer
    _saveStars();
  }

  Future<void> _saveStars() async {
    if (!starsSaved) {
      await StreakStarService.addStars(starsEarned);
      starsSaved = true;
      widget.onStarsUpdated?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quiz Finished!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score: ${widget.score} / 10',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            if (starsEarned > 0)
              Column(
                children: [
                  Text(
                    '⭐ Earned: $starsEarned stars',
                    style: const TextStyle(fontSize: 16, color: Colors.amber),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Stars have been added to your total!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Make sure stars are saved before going back
                _saveStars().then((_) {
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C3CF3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
