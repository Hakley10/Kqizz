import 'package:flutter/material.dart';

class QuizQuestionCard extends StatelessWidget {
  final Widget question;
  final Widget options;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C3CF3), Color(0xFF8B7CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          question,
          const SizedBox(height: 20),
          options,
        ],
      ),
    );
  }
}
