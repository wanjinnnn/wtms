import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'submit_work_screen.dart';

void main() {
  runApp(const WTMSApp());
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
        '/submit': (context) => const SubmitWorkScreen(),
      },
    );
  }
}
