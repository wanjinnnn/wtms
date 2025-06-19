import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'full_submission_screen.dart'; // Import the screen to navigate to

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
        Uri.parse('http://192.168.137.185/wtms/get_submissions.php'),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2EBF2), Color(0xFFE0F7FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : submissions.isEmpty
                    ? const Center(child: Text("No submissions yet."))
                    : ListView.builder(
                      itemCount: submissions.length,
                      itemBuilder: (context, index) {
                        final sub = submissions[index];
                        return InkWell(
                          onTap: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        FullSubmissionScreen(submission: sub),
                              ),
                            );
                            if (updated == true) {
                              fetchSubmissionHistory();
                            }
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.assignment_turned_in,
                                        color: Colors.teal[700],
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          sub['task_title'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.blueGrey,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Submitted on: ${formatDate(sub['submitted_at'] ?? '')}",
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ),
      ),
    );
  }
}
