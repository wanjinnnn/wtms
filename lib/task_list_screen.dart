import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  final int workerId;
  const TaskListScreen({super.key, required this.workerId});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<dynamic> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.137.185/wtms/get_works.php'),
        body: {'worker_id': widget.workerId.toString()},
      );
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          tasks = data['tasks'];
          isLoading = false;
        });
      } else {
        showError(data['message']);
      }
    } catch (e) {
      showError("Failed to load tasks.");
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    setState(() => isLoading = false);
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Tasks',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : tasks.isEmpty
                          ? const Center(child: Text("No tasks assigned."))
                          : ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Card(
                                  color: Colors.white.withOpacity(0.95),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task['title'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          task['description'] ?? '',
                                          style: const TextStyle(fontSize: 16),
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
                                              "Due: ${formatDate(task['due_date'] ?? '')}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    task['status'] ==
                                                            'Completed'
                                                        ? Colors.green[100]
                                                        : Colors.orange[100],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                task['status'] ?? '',
                                                style: TextStyle(
                                                  color:
                                                      task['status'] ==
                                                              'Completed'
                                                          ? Colors.green
                                                          : Colors.orange,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child:
                                              task['status'] == 'Completed'
                                                  ? ElevatedButton.icon(
                                                    onPressed: null,
                                                    icon: const Icon(
                                                      Icons
                                                          .assignment_turned_in,
                                                    ),
                                                    label: const Text(
                                                      "Already Submitted",
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.grey,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                    ),
                                                  )
                                                  : ElevatedButton.icon(
                                                    onPressed: () async {
                                                      final result =
                                                          await Navigator.pushNamed(
                                                            context,
                                                            '/submit',
                                                            arguments: {
                                                              'task': task,
                                                              'workerId':
                                                                  widget
                                                                      .workerId,
                                                            },
                                                          );
                                                      if (result == true) {
                                                        fetchTasks(); // Refresh the task list
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .assignment_turned_in,
                                                    ),
                                                    label: const Text(
                                                      "Submit Work",
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.teal,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
