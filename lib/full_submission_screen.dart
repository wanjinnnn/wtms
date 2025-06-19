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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              submission['task_title'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Submitted on: ${submission['submitted_at'] ?? ''}",
              style: const TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 16),
            const Text(
              "Remarks:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              submission['submission_text']?.isNotEmpty == true
                  ? submission['submission_text']
                  : '-',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => EditSubmissionScreen(submission: submission),
                    ),
                  );
                  if (updated == true) {
                    Navigator.pop(context, true); // Go back and refresh history
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Submission'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
