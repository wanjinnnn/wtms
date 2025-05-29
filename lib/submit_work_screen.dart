import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubmitWorkScreen extends StatefulWidget {
  final Map<String, dynamic> task;
  final int workerId;

  const SubmitWorkScreen({
    super.key,
    required this.task,
    required this.workerId,
  });

  @override
  State<SubmitWorkScreen> createState() => _SubmitWorkScreenState();
}

class _SubmitWorkScreenState extends State<SubmitWorkScreen> {
  final TextEditingController _submissionController = TextEditingController();
  bool isSubmitting = false;

  Future<void> submitWork() async {
    if (_submissionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your completion report.")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost/ctg/submit_work.php'), // adjust if needed
        body: {
          'work_id': widget.task['id'].toString(),
          'worker_id': widget.workerId.toString(),
          'submission_text': _submissionController.text,
        },
      );

      final data = json.decode(response.body);
      if (data['success']) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Submission successful.")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${data['message']}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Submission failed. Please try again.")),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(title: const Text("Submit Work")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Task: ${task['title']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Due: ${task['due_date']}"),
            const SizedBox(height: 20),
            const Text(
              "What did you complete?",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _submissionController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Describe your completed work here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: isSubmitting ? null : submitWork,
                child:
                    isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
