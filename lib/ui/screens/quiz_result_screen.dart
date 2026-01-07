import 'package:flutter/material.dart';
import '../../models/quiz_history_model.dart';
import '../../services/history_service.dart';
import '../../services/progress_service.dart';
import 'history_screen.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final String category;
  final String difficulty;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.category,
    required this.difficulty,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  static const int total = 10;
  bool _saved = false;

  @override
    void initState() {
      super.initState();
      _onFinish();
    }

    Future<void> _onFinish() async {
      await ProgressService.onQuizFinished(widget.score);
      _saveOnce();
    }

    void _saveOnce() {
      if (_saved) return;

      HistoryService.saveHistory(
        QuizHistory(
          category: widget.category,
          difficulty: widget.difficulty,
          score: widget.score,
          total: total,
          playedAt: DateTime.now().toIso8601String(),
        ),
      );

      _saved = true;
    }


  @override
  Widget build(BuildContext context) {
    final int correct = widget.score;
    final int wrong = total - widget.score;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FB),
      body: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events,
                  size: 64, color: Color(0xFF6C3CF3)),
              const SizedBox(height: 12),
              const Text(
                'Quiz Completed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _box(correct.toString(), 'Correct', Colors.green),
                  _box(wrong.toString(), 'Wrong', Colors.red),
                ],
              ),

              const SizedBox(height: 24),
              Text('Score: $correct / $total'),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                child: const Text('Home'),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistoryScreen(),
                    ),
                  );
                },
                child: const Text('View History'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box(String value, String label, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: color)),
        Text(label),
      ],
    );
  }
}
