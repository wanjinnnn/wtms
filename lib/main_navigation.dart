import 'package:flutter/material.dart';
import 'task_list_screen.dart';
import 'submission_history_screen.dart';
import 'profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainNavigation extends StatefulWidget {
  final int workerId;
  const MainNavigation({super.key, required this.workerId});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      TaskListScreen(workerId: widget.workerId),
      SubmissionHistoryScreen(workerId: widget.workerId),
      ProfileScreen(workerId: widget.workerId),
    ];

    final titles = ['Tasks', 'Submission History', 'Profile'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        backgroundColor: Colors.teal,
        actions:
            _currentIndex ==
                    2 // Profile tab index
                ? [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    onPressed: () async {
                      // Clear shared preferences and navigate to login
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    },
                  ),
                ]
                : null,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.teal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.account_circle, size: 64, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'WTMS Menu',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Tasks'),
              selected: _currentIndex == 0,
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Submission History'),
              selected: _currentIndex == 1,
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              selected: _currentIndex == 2,
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
