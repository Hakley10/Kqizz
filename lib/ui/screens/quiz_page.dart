import 'package:flutter/material.dart';
import '../widgets/info_box.dart';
import '../widgets/quiz_card.dart';
import '../screens/abcd_quiz_setup_screen.dart';
import '../../services/streak_star_service.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool isDarkmode = false;
  int currentStreak = 0;
  int totalStars = 0;

  Color get bgColor =>
      isDarkmode ? const Color(0xFF121212) : const Color(0xFFF4F4F4);
  Color get cardColor =>
      isDarkmode ? const Color(0xFF1E1E1E) : Colors.white;
  Color get textColor => isDarkmode ? Colors.white : Colors.black;
  Color get primaryColor => const Color(0xFF8442FE);

  @override
  void initState() {
    super.initState();
    _loadStreakAndStars();
  }

  // Refresh when page becomes visible again
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when returning to this page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  Future<void> _loadStreakAndStars() async {
    final streak = await StreakStarService.getStreak();
    final stars = await StreakStarService.getStars();

    setState(() {
      currentStreak = streak;
      totalStars = stars;
    });
  }

  // Refresh data
  Future<void> _refreshData() async {
    await _loadStreakAndStars();
  }

  void toggleTheme() {
    setState(() => isDarkmode = !isDarkmode);
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
        title: Image.asset(
          'assets/Logo/appBarLogo.png',
          height: 60,
          errorBuilder: (context, error, stackTrace) {
            // If image doesn't exist, show text instead
            return Text(
              'Kuizzer',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            );
          },
        ),
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

      drawer: Drawer(
        child: Center(child: Text('Menu')),
      ),

      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: bgColor,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              value: "$currentStreak",
                              iconColor: Colors.orange,
                              isDarkmode: isDarkmode,
                            ),
                            const SizedBox(width: 8),
                            InfoBox(
                              icon: Icons.star,
                              value: "$totalStars",
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
                            _showHistoryDialog();
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

              Text("🎲 Random Quiz",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 10),

              QuizCard(
                title: "All Randomize Quizzes",
                subtitle1: "10 Questions",
                subtitle2: "3 Categories",
                icon: Icons.casino,
                color: primaryColor,
              ),

              const SizedBox(height: 20),

              Text("▶ Start Play Kuiz",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 10),

              QuizCard(
                title: "ABCD Quiz",
                subtitle1: "Play Now",
                icon: Icons.play_arrow,
                color: Colors.orange,
                onTap: () async {
                  // Navigate to quiz and wait for return
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AbcdQuizSetupScreen(
                        isDarkmode: isDarkmode,
                      ),
                    ),
                  );
                  
                  // Automatically refresh when returning
                  await _refreshData();
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

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Your Progress"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  "Current Streak: $currentStreak days",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  "Total Stars: $totalStars",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "How it works:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("• Earn 1 streak each day you open the app"),
            const SizedBox(height: 4),
            const Text("• Earn 1 star for each correct quiz answer"),
            const SizedBox(height: 4),
            const Text("• Complete quizzes to earn more stars!"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}