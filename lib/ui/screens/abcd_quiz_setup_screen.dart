import 'package:flutter/material.dart';
import 'abcd_quiz_screen.dart';

class AbcdQuizSetupScreen extends StatefulWidget {
  final bool isDarkmode;

  const AbcdQuizSetupScreen({
    super.key,
    required this.isDarkmode,
  });

  @override
  State<AbcdQuizSetupScreen> createState() => _AbcdQuizSetupScreenState();
}

class _AbcdQuizSetupScreenState extends State<AbcdQuizSetupScreen> {
  final Color primaryColor = const Color(0xFF6C3CF3);

  String mainCategory = 'Countries';
  String? continent;

  String question = 'Flag';
  String answer = 'Name';
  String difficulty = 'Easy';

  final List<String> mainCategories = ['Countries', 'Animal', 'Continent'];
  final List<String> continents = ['Africa', 'Asia', 'Europe', 'America'];
  final List<String> questionOptions = ['Flag', 'Name', 'Capital', 'Map'];
  final List<String> difficultyOptions = ['Easy', 'Medium', 'Hard'];

  Color get bgColor =>
      widget.isDarkmode ? const Color(0xFF121212) : const Color(0xFFF2F3F7);

  Color get textColor =>
      widget.isDarkmode ? Colors.white : Colors.black;

  List<String> get answerOptions {
    if (mainCategory == 'Countries' || mainCategory == 'Continent') {
      if (question == 'Flag') return ['Name', 'Capital'];
      if (question == 'Name') return ['Flag', 'Capital'];
      if (question == 'Capital') return ['Flag', 'Name'];
      if (question == 'Map') return ['Name', 'Flag', 'Capital'];
    }

    if (mainCategory == 'Animal') {
      if (question == 'Flag') return ['Name'];
      if (question == 'Name') return ['Flag'];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'ABCD Quiz',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title('Category'),

            Row(
              children: mainCategories.map((c) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _option(
                      c,
                      mainCategory == c,
                      () {
                        setState(() {
                          mainCategory = c;
                          continent = null;
                          question = 'Flag';
                          answer = answerOptions.first;
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
            ),

            if (mainCategory == 'Continent') ...[
              const SizedBox(height: 16),
              _title('Continent'),
              Row(
                children: continents.map((c) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _option(
                        c,
                        continent == c,
                        () {
                          setState(() {
                            continent = c;
                            question = 'Flag';
                            answer = answerOptions.first;
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Question',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Answer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _columnOptions(
                    questionOptions,
                    question,
                    (v) {
                      setState(() {
                        question = v;
                        answer = answerOptions.first;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _columnOptions(
                    answerOptions,
                    answer,
                    (v) => setState(() => answer = v),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            _title('Difficulty'),
            Row(
              children: difficultyOptions.map((d) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _option(
                      d,
                      difficulty == d,
                      () => setState(() => difficulty = d),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AbcdQuizScreen(
                        isDarkmode: widget.isDarkmode,
                        category: mainCategory,
                        continent: continent,
                        questionType: question,
                        answerType: answer,
                        difficulty: difficulty,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Start!',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _columnOptions(
    List<String> items,
    String selected,
    Function(String) onSelect,
  ) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _option(
            item,
            selected == item,
            () => onSelect(item),
          ),
        );
      }).toList(),
    );
  }

  Widget _option(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
