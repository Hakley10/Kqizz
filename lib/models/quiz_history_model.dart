class QuizHistory {
  final String category;
  final String difficulty;
  final int score;
  final int total;
  final String playedAt;

  QuizHistory({
    required this.category,
    required this.difficulty,
    required this.score,
    required this.total,
    required this.playedAt,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'difficulty': difficulty,
        'score': score,
        'total': total,
        'playedAt': playedAt,
      };

  factory QuizHistory.fromJson(Map<String, dynamic> json) {
    return QuizHistory(
      category: json['category'],
      difficulty: json['difficulty'],
      score: json['score'],
      total: json['total'],
      playedAt: json['playedAt'],
    );
  }
}
