import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  List<Task> _tasks = [];

// -- Local state version -------------
  void _addTask() {
    final title = _taskController.text.trim();
    if(title.isEmpty) return; // Block empty submissions

    setState(() {
      _tasks.add(Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        createdAt: DateTime.now()
      ));
    });
  }

// -- Firestore version -----------------
Future<void> addTaskToFirestore(String title) async {
  if (title.trim().isEmpty) return; // Same validation rule

  await FirebaseFirestore.instance.collection('tasks').add({
    'title': title.trim(),
    'isCompleted': false,
    'subtasks': [],
    'createdAt': DateTime.now().toIso8601String()
  }); // No setState() needed here - the stream will push the new doc
}

// Toggle isCompleted in Firestore
Future<void> toggleTask(Task task) async {
    await FirebaseFirestore.instance
      .collection('tasks')
      .doc(task.id)
      .update({'isCompleted': !task.isCompleted});
}

// Permanently delete a task
Future<void> deleteTask(String taskId) async {
    await FirebaseFirestore.instance
      .collection('tasks')
      .doc(taskId)
      .delete();
}

  @override
  void dispose() {
    _taskController.dispose(); // IMPORTANT: always dispose controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Column(
        children: [
          // ── Input row ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(child: TextField(controller: _taskController,
                decoration: const InputDecoration(hintText: 'New task name...'),
              )),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _addTask, child: const Text('Add')),
            ]),
          ),
          // ── Task list ──────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_tasks[index].title),
              ),
            ),
          ),
        ],
      ),
    );
  }
}