import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> loginWorker() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    var url = Uri.parse("http://192.168.0.9/wtms/login_worker.php");
    var response = await http.post(
      url,
      body: {
        "email": emailController.text,
        "password": passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        var worker = jsonData['worker'];
        await prefs.setString('worker', json.encode(worker));

        Navigator.pushReplacementNamed(context, '/profile', arguments: worker);
      } else {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text("Login Failed"),
                content: Text(jsonData['message']),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  ),
                ],
              ),
        );
      }
    } else {
      print("Server error");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: Colors.blueAccent),
                  SizedBox(height: 12),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Login to your worker account",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Email required';
                      if (!value.contains('@')) return 'Invalid email';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton.icon(
                        onPressed: loginWorker,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Icon(Icons.login),
                        label: Text("Login", style: TextStyle(fontSize: 18)),
                      ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      "Don't have an account? Register",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
