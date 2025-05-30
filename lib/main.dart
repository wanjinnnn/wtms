import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'profile_screen.dart';
import 'task_list_screen.dart';

void main() {
  runApp(WTMSApp());
}

class WTMSApp extends StatelessWidget {
  const WTMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WTMS',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/profile': (context) => ProfileScreen(),
        '/taskList': (context) => TaskListScreen(),
      },
    );
  }
}
