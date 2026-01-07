import 'package:flutter/material.dart';
import '../widgets/info_box.dart';
import '../widgets/quiz_card.dart';
import 'abcd_quiz_setup_screen.dart';
import 'history_screen.dart';
import 'abcd_quiz_screen.dart';
import '../../services/progress_service.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int streak = 1;
  int star = 1;

  bool isDarkmode = false;

  Color get bgColor =>
      isDarkmode ? const Color(0xFF121212) : const Color(0xFFF4F4F4);
  Color get cardColor => isDarkmode ? const Color(0xFF1E1E1E) : Colors.white;
  Color get textColor => isDarkmode ? Colors.white : Colors.black;
  Color get primaryColor => const Color(0xFF8442FE);

  void toggleTheme() {
    setState(() => isDarkmode = !isDarkmode);
  }

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final data = await ProgressService.load();
    setState(() {
      streak = data['streak']!;
      star = data['star']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: primaryColor),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        centerTitle: true,
        title: Image.asset('assets/Logo/appBarLogo.png', height: 60),
        actions: [
          IconButton(
            icon: Icon(
              isDarkmode ? Icons.light_mode : Icons.dark_mode,
              color: primaryColor,
            ),
            onPressed: toggleTheme,
          ),
        ],
      ),

      drawer: Drawer(child: Center(child: Text('Menu'))),

      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: bgColor,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      "Kuizzer",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            InfoBox(
                              icon: Icons.local_fire_department,
                              value: streak.toString(),
                              iconColor: Colors.orange,
                              isDarkmode: isDarkmode,
                            ),
                            const SizedBox(width: 8),
                            InfoBox(
                              icon: Icons.star,
                              value: star.toString(),
                              iconColor: Colors.amber,
                              isDarkmode: isDarkmode,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HistoryScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.history, size: 16),
                          label: const Text("History"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              QuizCard(
                title: "All Randomize Quizzes",
                subtitle1: "10 Questions",
                subtitle2: "Mixed",
                icon: Icons.casino,
                color: primaryColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AbcdQuizScreen(
                        isDarkmode: isDarkmode,
                        category: 'Random', // 👈 HERE
                        questionType: 'Flag',
                        answerType: 'Name',
                        difficulty: 'Easy',
                      ),
                    ),
                  ).then((_) => _loadProgress());
                },
              ),

              const SizedBox(height: 20),

              Text(
                "▶ Start Play Kuiz",
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 10),

              QuizCard(
                title: "ABCD Quiz",
                subtitle1: "Play Now",
                icon: Icons.play_arrow,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AbcdQuizSetupScreen(isDarkmode: isDarkmode),
                    ),
                  ).then((_) => _loadProgress());
                },
              ),

              const SizedBox(height: 12),

              QuizCard(
                title: "True / False Quiz",
                subtitle1: "Play Now",
                icon: Icons.check_circle,
                color: Colors.green,
              ),
              const SizedBox(height: 12),

              QuizCard(
                title: "Matching Quiz",
                subtitle1: "Play Now",
                icon: Icons.extension,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
