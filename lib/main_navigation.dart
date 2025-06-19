import 'package:flutter/material.dart';
import 'task_list_screen.dart';
import 'submission_history_screen.dart';
import 'profile_screen.dart';

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

    return Scaffold(
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
