import 'dart:async';
import 'package:flutter/material.dart';

import '../../models/countries_model.dart';
import '../../models/animal_model.dart';
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

  final List<Country> _allCountries = [];
  final List<Country> _quizCountries = [];
  final List<Animal> _animals = [];

  Country? _currentCountry;
  Animal? _currentAnimal;

  List<String> _options = [];

  int _index = 0;
  int _score = 0;
  int _timeLeft = totalTime;

  Timer? _timer;
  bool _loading = true;

  List<dynamic> _randomItems = [];
  dynamic _currentRandom;


  
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (widget.category == 'Random') {
      final animals = await QuizDataService.loadAnimals();
      final countries = await QuizDataService.loadCountries();
      if (!mounted) return;

      final mixed = <dynamic>[
        ...animals,
        ...countries,
      ]..shuffle();

      _randomItems = mixed.take(totalQuestions).toList();

      _loading = false;
      _loadNextRandom();
      return;
    }

    if (widget.category == 'Animal') {
      final animals = await QuizDataService.loadAnimals();
      if (!mounted) return;

      _animals.addAll(animals);
      _animals.shuffle();

      if (_animals.length > totalQuestions) {
        _animals.removeRange(totalQuestions, _animals.length);
      }

      _loading = false;
      _loadNextAnimal();
      return;
    }

    final countries = await QuizDataService.loadCountries();
    if (!mounted) return;

    _allCountries.addAll(countries);

    if (widget.category == 'Continent' && widget.continent != null) {
      _quizCountries.addAll(
        _allCountries.where((c) => c.continent == widget.continent),
      );
    } else {
      _quizCountries.addAll(_allCountries);
    }

    _quizCountries.shuffle();

    if (_quizCountries.length > totalQuestions) {
      _quizCountries.removeRange(totalQuestions, _quizCountries.length);
    }

    _loading = false;
    _loadNextCountry();
  }


  void _startTimer() {
    _timer?.cancel();
    _timeLeft = totalTime;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      if (_timeLeft <= 0) {
        t.cancel();
        widget.category == 'Animal'
            ? _loadNextAnimal()
            : _loadNextCountry();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _loadNextCountry() {
    _timer?.cancel();

    if (_index >= _quizCountries.length) {
      _finish();
      return;
    }

    _currentCountry = _quizCountries[_index];
    _generateCountryOptions();
    _index++;

    _startTimer();
    setState(() {});
  }

  void _loadNextAnimal() {
    _timer?.cancel();

    if (_index >= _animals.length) {
      _finish();
      return;
    }

    _currentAnimal = _animals[_index];
    _generateAnimalOptions();
    _index++;

    _startTimer();
    setState(() {});
  }

  void _finish() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          score: _score,
          category: widget.category,
          difficulty: widget.difficulty,
        ),
      ),
    );
  }

  void _generateCountryOptions() {
    final correct = _countryAnswer(_currentCountry!);

    List<Country> pool;
    if (widget.difficulty == 'Easy') {
      pool =
          _allCountries.where((c) => c.continent != _currentCountry!.continent).toList();
    } else if (widget.difficulty == 'Medium') {
      pool =
          _allCountries.where((c) => c.continent == _currentCountry!.continent).toList();
    } else {
      pool = _allCountries.where((c) => c.id != _currentCountry!.id).toList();
    }

    final wrong = pool
        .map(_countryAnswer)
        .where((v) => v != correct)
        .toSet()
        .toList()
      ..shuffle();

    _options = [correct, ...wrong.take(3)]..shuffle();
  }

  void _generateAnimalOptions() {
    final correct = widget.answerType == 'Image'
        ? _currentAnimal!.image
        : _currentAnimal!.name;

    final wrong = _animals
        .where((a) => a.id != _currentAnimal!.id)
        .map((a) =>
            widget.answerType == 'Image' ? a.image : a.name)
        .toSet()
        .toList()
      ..shuffle();

    _options = [correct, ...wrong.take(3)]..shuffle();
  }

  void _loadNextRandom() {
    _timer?.cancel();

    if (_index >= _randomItems.length) {
      _finish();
      return;
    }

    _currentRandom = _randomItems[_index];

    if (_currentRandom is Animal) {
      _currentAnimal = _currentRandom;
      _generateAnimalOptions();
    } else {
      _currentCountry = _currentRandom;
      _generateCountryOptions();
    }

    _index++;
    _startTimer();
    setState(() {});
  }


  String _countryAnswer(Country c) {
    switch (widget.answerType) {
      case 'Flag':
        return c.flagImage;
      case 'Map':
        return c.mapImage;
      case 'Capital':
        return c.capital;
      default:
        return c.name;
    }
  }

  Widget _questionWidget() {
    if (widget.category == 'Animal') {
      if (widget.questionType == 'Image') {
        return Image.asset(_currentAnimal!.image, height: 120);
      }
      return Text(
        _currentAnimal!.name,
        style: const TextStyle(fontSize: 22, color: Colors.white),
      );
    }

    switch (widget.questionType) {
      case 'Flag':
        return Image.asset(_currentCountry!.flagImage, height: 120);
      case 'Map':
        return Image.asset(_currentCountry!.mapImage, height: 120);
      case 'Capital':
        return Text(
          _currentCountry!.capital,
          style: const TextStyle(fontSize: 22, color: Colors.white),
        );
      default:
        return Text(
          _currentCountry!.name,
          style: const TextStyle(fontSize: 22, color: Colors.white),
        );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading ||
        (widget.category == 'Animal' && _currentAnimal == null) ||
        (widget.category != 'Animal' && _currentCountry == null)) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final bool imageAnswer =
        widget.answerType == 'Flag' || widget.answerType == 'Map' || widget.answerType == 'Image';

    return Scaffold(
      backgroundColor:
          widget.isDarkmode ? const Color(0xFF121212) : const Color(0xFFF6F6FB),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _progressBar(),
            const SizedBox(height: 20),
            _card(imageAnswer),
            const Spacer(),
            _timerBar(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _timer?.cancel();
              Navigator.pop(context);
            },
          ),
          const Text(
            'ABCD Quiz',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _progressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(totalQuestions, (i) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 4,
              decoration: BoxDecoration(
                color: i < _index
                    ? const Color(0xFF6C3CF3)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _card(bool imageAnswer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5B6CFF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _questionWidget(),
          const SizedBox(height: 30),
          ..._options.map((o) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  final correct = widget.category == 'Animal'
                      ? (widget.answerType == 'Image'
                          ? _currentAnimal!.image
                          : _currentAnimal!.name)
                      : _countryAnswer(_currentCountry!);

                  if (o == correct) _score++;

                  widget.category == 'Animal'
                      ? _loadNextAnimal()
                      : _loadNextCountry();
                },
                child: imageAnswer && o.startsWith('assets/')
                  ? Image.asset(
                      o,
                      height: 40,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    )
                  : Text(
                      o,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _timerBar() {
    return Column(
      children: [
        LinearProgressIndicator(
          value: _timeLeft / totalTime,
          minHeight: 6,
          color: Colors.red,
          backgroundColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 4),
        Text('$_timeLeft s'),
      ],
    );
  }
}
