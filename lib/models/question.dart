
class QuestionModel {
  String question;
  List<String> options;
  int correctIndex;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}
