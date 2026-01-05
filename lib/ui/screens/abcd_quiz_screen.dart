import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/countries_model.dart';
import '../../services/quiz_data_service.dart';
import 'quiz_result_screen.dart';

class AbcdQuizScreen extends StatefulWidget {
  final bool isDarkmode;
  final String category;
  final String questionType;
  final String answerType;
  final String difficulty;
  final String? continent;

  const AbcdQuizScreen({
    super.key,
    required this.isDarkmode,
    required this.category,
    required this.questionType,
    required this.answerType,
    required this.difficulty,
    this.continent,
  });

  @override
  State<AbcdQuizScreen> createState() => _AbcdQuizScreenState();
}

class _AbcdQuizScreenState extends State<AbcdQuizScreen> {
  static const int totalQuestions = 10;
  static const int totalTime = 30;

  List<Country> allCountries = [];
  List<Country> quizCountries = [];
  Country? currentCountry;

  List<String> options = [];
  int currentIndex = 0;
  int score = 0;
  int timeLeft = totalTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }

  Future<void> loadQuiz() async {
    allCountries = await QuizDataService.loadCountries();

    if (widget.category == 'Continent' && widget.continent != null) {
      quizCountries = allCountries
          .where((c) => c.continent == widget.continent)
          .toList();
    } else {
      quizCountries = allCountries;
    }

    quizCountries.shuffle();
    quizCountries = quizCountries.take(totalQuestions).toList();

    nextQuestion();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = totalTime;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft == 0) {
        t.cancel();
        nextQuestion();
      } else {
        setState(() => timeLeft--);
      }
    });
  }

void nextQuestion() {
  if (currentIndex >= quizCountries.length) {
    // Store the score before navigating
    final quizScore = score;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(score: quizScore,),
      ),
    );
    return;
  }
  
  currentCountry = quizCountries[currentIndex];
  generateOptions();
  currentIndex++;
  startTimer();
  setState(() {});
}

  void generateOptions() {
    final correct = getAnswer(currentCountry!);

    final wrong = allCountries
        .where((c) => c.id != currentCountry!.id)
        .map((c) => getAnswer(c))
        .toSet()
        .toList()
      ..shuffle();

    options = [correct, ...wrong.take(3)]..shuffle();
  }

  String getAnswer(Country c) {
    switch (widget.answerType) {
      case 'Capital':
        return c.capital;
      case 'Name':
      default:
        return c.name;
    }
  }

  Widget buildQuestion(Country c) {
    switch (widget.questionType) {
      case 'Flag':
        return Image.asset(c.flagImage, height: 120);
      case 'Map':
        return Image.asset(c.mapImage, height: 120);
      case 'Name':
        return Text(c.name, style: const TextStyle(fontSize: 20));
      case 'Capital':
        return Text(c.capital, style: const TextStyle(fontSize: 20));
      default:
        return const SizedBox();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentCountry == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('ABCD Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(value: timeLeft / totalTime),
            const SizedBox(height: 20),
            buildQuestion(currentCountry!),
            const SizedBox(height: 20),
            ...options.map(
              (o) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: () {
                    if (o == getAnswer(currentCountry!)) score++;
                    nextQuestion();
                  },
                  child: Text(o),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
