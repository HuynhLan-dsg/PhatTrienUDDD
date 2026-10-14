import 'package:flutter/material.dart';

import 'learn_screen.dart';
import 'quiz_screen.dart';
import 'schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  int selectedIndex = 0;

  final List<Widget> screens = [
    const LearnScreen(),
    const QuizScreen(),
    const ScheduleScreen(),
  ];

  final List<String> titles = [
    "Học từ vựng",
    "Kiểm tra từ",
    "Lịch nhắc"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(titles[selectedIndex]),
      ),

      drawer: Drawer(
        child: ListView(
          children: [

            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  "Trợ lý học từ vựng",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            ListTile(
              leading:
                  const Icon(Icons.book),
              title: const Text(
                "Học từ",
              ),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading:
                  const Icon(Icons.quiz),
              title: const Text(
                "Kiểm tra từ",
              ),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading:
                  const Icon(Icons.alarm),
              title: const Text(
                "Lịch nhắc",
              ),
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: screens[selectedIndex],
    );
  }
}