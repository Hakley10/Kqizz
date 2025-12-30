import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool isDarkmode = false;

  void toggleTheme() {
    setState(() {
      isDarkmode = !isDarkmode;
    });
  }

  Widget _infoBox({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkmode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(color: isDarkmode ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: isDarkmode ? Colors.grey[900] : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkmode ? Colors.deepPurple[800] : Colors.deepPurple,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: isDarkmode ? Colors.white : Colors.black,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  color: isDarkmode ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.quiz,
                color: isDarkmode ? Colors.white : Colors.black,
              ),
              title: Text(
                'Quizzes',
                style: TextStyle(
                  color: isDarkmode ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: isDarkmode ? Colors.white : Colors.black,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: isDarkmode ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: isDarkmode ? Colors.grey[900] : Colors.deepPurple,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Center(child: Image.asset('assets/kuiz.png', height: 40)),
        actions: [
          IconButton(
            icon: Icon(
              isDarkmode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Container(
        color: isDarkmode ? Colors.grey[900] : Colors.grey[100],
        padding: EdgeInsets.all(16),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkmode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // LEFT: container holding image + title
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        "Kuizzer",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkmode ? Colors.white : Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                // RIGHT: container holding streak, star and history
                Container(
                  
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          _infoBox(
                            icon: Icons.local_fire_department,
                            value: "7",
                            color: Colors.orange,
                          ),
                          SizedBox(width: 8),
                          _infoBox(
                            icon: Icons.star,
                            value: "3",
                            color: Colors.amber,
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.history, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              "History",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

            ),
          ),
        ),
      ),
    );
  }
}
