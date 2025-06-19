import 'package:flutter/material.dart';
import 'edit_submission_screen.dart';

class FullSubmissionScreen extends StatelessWidget {
  final Map<String, dynamic> submission;
  const FullSubmissionScreen({super.key, required this.submission});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submission Details'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                          submission['task_title'] ?? '',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Submitted on:",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    submission['submitted_at'] ?? '',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Submission Text:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(
                      minHeight: 120,
                      maxHeight:
                          300, // Makes the box taller and scrollable if needed
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        submission['submission_text']?.isNotEmpty == true
                            ? submission['submission_text']
                            : '-',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => EditSubmissionScreen(
                                  submission: submission,
                                ),
                          ),
                        );
                        if (updated == true) {
                          Navigator.pop(
                            context,
                            true,
                          ); // Go back and refresh history
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Submission'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
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
    );
  }
}
