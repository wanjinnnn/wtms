import 'package:flutter/material.dart';
import 'submit_work_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<dynamic> tasks = [];
  bool isLoading = true;
  int? workerId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    workerId = ModalRoute.of(context)!.settings.arguments as int?;
    if (workerId != null) {
      fetchTasks();
    }
  }

  Future<void> fetchTasks() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/ctg/get_works.php'), // adjust URL if hosted
        body: {'worker_id': workerId.toString()},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : tasks.isEmpty
              ? const Center(child: Text("No tasks assigned."))
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(task['title']),
                      subtitle: Text(task['description']),
                      trailing: Text(task['status']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => SubmitWorkScreen(
                                  task: task,
                                  workerId: workerId!,
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
