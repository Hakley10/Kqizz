import 'package:flutter/material.dart';

class QuizTimerBar extends StatelessWidget {
  final int timeLeft;
  final int totalTime;

  const QuizTimerBar({
    super.key,
    required this.timeLeft,
    required this.totalTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: timeLeft / totalTime,
          minHeight: 6,
          color: Colors.redAccent,
          backgroundColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 6),
        Text('$timeLeft s'),
      ],
    );
  }
}
