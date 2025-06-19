import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final int workerId;
  const EditProfileScreen({super.key, required this.workerId});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://192.168.137.185/wtms/get_profile.php'),
        body: {'worker_id': widget.workerId.toString()},
      );
      final data = json.decode(response.body);
      if (data['success']) {
        nameController.text = data['profile']['full_name'] ?? '';
        emailController.text = data['profile']['email'] ?? '';
        phoneController.text = data['profile']['phone'] ?? '';
        addressController.text = data['profile']['address'] ?? '';
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Failed to load profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error loading profile')));
    }
    setState(() => isLoading = false);
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    final response = await http.post(
      Uri.parse('http://192.168.137.185/wtms/update_profile.php'),
      body: {
        'worker_id': widget.workerId.toString(),
        'full_name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
      },
    );
    final data = json.decode(response.body);
    setState(() => isLoading = false);
    if (data['success'] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('worker', json.encode(data['profile']));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Update failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.teal,
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.97),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.edit,
                              size: 48,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Enter name'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Enter email'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone',
                                prefixIcon: Icon(Icons.phone),
                                border: OutlineInputBorder(),
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Enter phone'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: addressController,
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                prefixIcon: Icon(Icons.home),
                                border: OutlineInputBorder(),
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Enter address'
                                          : null,
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: saveProfile,
                              icon: const Icon(Icons.save),
                              label: const Text("Save"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 14,
                                ),
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
}
