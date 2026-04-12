import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  List<Task> _tasks = [];

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