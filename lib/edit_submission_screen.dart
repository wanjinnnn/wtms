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
      print('Update response: ${response.body}');
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.submission['task_title'] ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _submissionController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Submission Text',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (v) =>
                        v == null || v.isEmpty ? 'Enter your submission' : null,
              ),
              const SizedBox(height: 24),
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
                                            () => Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: const Text('Update'),
                                      ),
                                    ],
                                  ),
                            );
                            if (confirmed == true) {
                              await saveEdit();
                            }
                          },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
