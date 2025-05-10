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
      "http://192.168.0.9/wtms/register_worker.php",
    ); // adjust
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

    if (response.statusCode == 200) {
      var msg = response.body;
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("Registration"),
              content: Text(msg),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (msg.contains("success")) {
                      Navigator.pop(context); // go back to login
                    }
                  },
                  child: Text("OK"),
                ),
              ],
            ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Worker Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(nameController, "Full Name"),
              buildTextField(emailController, "Email", isEmail: true),
              buildTextField(passwordController, "Password", isPassword: true),
              buildTextField(phoneController, "Phone Number"),
              buildTextField(addressController, "Address"),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: registerWorker,
                    child: Text("Register"),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) return '$label required';
          if (isEmail && !value.contains('@')) return 'Invalid email';
          if (isPassword && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }
}
