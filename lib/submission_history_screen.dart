import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  final int workerId;
  const SubmissionHistoryScreen({super.key, required this.workerId});

  @override
  State<SubmissionHistoryScreen> createState() =>
      _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  List<dynamic> submissions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubmissionHistory();
  }

  Future<void> fetchSubmissionHistory() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.198.1/wtms/get_submissions.php'),
        body: {'worker_id': widget.workerId.toString()},
      );
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          submissions = data['submissions'];
          isLoading = false;
        });
      } else {
        showError(data['message']);
      }
    } catch (e) {
      showError("Failed to load submissions.");
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    setState(() => isLoading = false);
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submission History'),
        backgroundColor: Colors.teal,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : submissions.isEmpty
              ? const Center(child: Text("No submissions yet."))
              : ListView.builder(
                itemCount: submissions.length,
                itemBuilder: (context, index) {
                  final sub = submissions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sub['task_title'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Submitted on: ${formatDate(sub['submitted_at'] ?? '')}",
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Remarks: ${sub['remarks'] ?? '-'}",
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
