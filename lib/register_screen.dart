import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoading = false;

  Future<void> registerWorker() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(
      "http://192.168.54.129/wtms/register_worker.php",
    ); // for register
    var response = await http.post(
      url,
      body: {
        "full_name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "phone": phoneController.text,
        "address": addressController.text,
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        String status = data['status'];
        String message = data['message'];

        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    Icon(
                      status == "success" ? Icons.check_circle : Icons.error,
                      color: status == "success" ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      status == "success" ? "Success" : "Error",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                content: Text(message, style: const TextStyle(fontSize: 16)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      if (status == "success") {
                        Navigator.pop(context); // Go back to login screen
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                    ),
                    child: const Text("OK"),
                  ),
                ],
              ),
        );
      } catch (e) {
        _showSimpleDialog(
          "Oops",
          "Something went wrong. Please try again later.",
        );
      }
    } else {
      _showSimpleDialog("Error", "Server connection failed.");
    }
  }

  void _showSimpleDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2EBF2), Color(0xFFE0F7FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
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
                    Icon(
                      Icons.person_add_alt_1,
                      size: 64,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildTextField(
                      nameController,
                      "Full Name",
                      icon: Icons.person,
                    ),
                    buildTextField(
                      emailController,
                      "Email",
                      icon: Icons.email,
                      isEmail: true,
                    ),
                    buildTextField(
                      passwordController,
                      "Password",
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    buildTextField(
                      phoneController,
                      "Phone Number",
                      icon: Icons.phone,
                    ),
                    buildTextField(
                      addressController,
                      "Address",
                      icon: Icons.home,
                    ),
                    const SizedBox(height: 24),
                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                          onPressed: registerWorker,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.app_registration),
                          label: const Text(
                            "Register",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Back to login
                      },
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon ?? Icons.text_fields),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return '$label required';
          if (isEmail && !value.contains('@')) return 'Invalid email';
          if (isPassword && value.length < 6)
            return 'Password must be at least 6 characters';
          return null;
        },
      ),
    );
  }
}
