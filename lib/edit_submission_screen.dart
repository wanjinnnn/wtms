import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditSubmissionScreen extends StatefulWidget {
  final Map<String, dynamic> submission;
  const EditSubmissionScreen({super.key, required this.submission});

  @override
  State<EditSubmissionScreen> createState() => _EditSubmissionScreenState();
}

class _EditSubmissionScreenState extends State<EditSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _submissionController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _submissionController = TextEditingController(
      text: widget.submission['submission_text'] ?? '',
    );
  }

  Future<void> saveEdit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSaving = true);
    try {
      final response = await http.post(
        Uri.parse('http://192.168.137.185/wtms/edit_submission.php'),
        body: {
          'submission_id': widget.submission['id'].toString(),
          'submission_text': _submissionController.text,
        },
      );
      final data = json.decode(response.body);
      if (data['success']) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Update failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating submission')),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Submission'),
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assignment_turned_in,
                          color: Colors.teal[700],
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.submission['task_title'] ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _submissionController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        labelText: 'Submission Text',
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: Colors.teal[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator:
                          (v) =>
                              v == null || v.isEmpty
                                  ? 'Enter your submission'
                                  : null,
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed:
                            isSaving
                                ? null
                                : () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (_) => AlertDialog(
                                          title: const Text('Confirm Update'),
                                          content: const Text(
                                            'Are you sure you want to update this submission?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: const Text('Update'),
                                            ),
                                          ],
                                        ),
                                  );
                                  if (confirmed == true) {
                                    await saveEdit();
                                  }
                                },
                        icon:
                            isSaving
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.save),
                        label: const Text('Save Changes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
