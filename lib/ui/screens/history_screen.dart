import 'package:flutter/material.dart';
import '../../models/quiz_history_model.dart';
import '../../services/history_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz History')),
      body: FutureBuilder<List<QuizHistory>>(
        future: HistoryService.getHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final history = snapshot.data!;

          if (history.isEmpty) {
            return const Center(child: Text('No history yet'));
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, i) {
              final h = history[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('${h.category} (${h.difficulty})'),
                  subtitle: Text(
                    'Score: ${h.score}/${h.total}\n${h.playedAt}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
