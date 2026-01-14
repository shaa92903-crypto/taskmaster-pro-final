import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(const TaskMasterApp());

class TaskMasterApp extends StatelessWidget {
  const TaskMasterApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const TaskListScreen(),
    );
  }
}

class TodoTask {
  String name;
  bool isDone;
  TodoTask({required this.name, this.isDone = false});

  Map<String, dynamic> toMap() => {'name': name, 'isDone': isDone};
  factory TodoTask.fromMap(Map<String, dynamic> map) => TodoTask(name: map['name'], isDone: map['isDone']);
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<TodoTask> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load data on startup
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('week3_tasks');
    if (data != null) {
      final List decoded = json.decode(data);
      setState(() => _tasks.addAll(decoded.map((x) => TodoTask.fromMap(x)).toList()));
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('week3_tasks', json.encode(_tasks.map((t) => t.toMap()).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI Enhancement: Custom App Bar with action button
      appBar: AppBar(
        title: const Text("TaskMaster Pro", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // Action button requirement
            onPressed: () => setState(() {}),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            // Requirement: Mark tasks as complete
            leading: Checkbox(
              value: _tasks[index].isDone,
              onChanged: (val) {
                setState(() => _tasks[index].isDone = val!);
                _saveTasks();
              },
            ),
            title: Text(
              _tasks[index].name,
              style: TextStyle(decoration: _tasks[index].isDone ? TextDecoration.lineThrough : null),
            ),
            // Requirement: Functionality to delete
            trailing: IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.red),
              onPressed: () {
                setState(() => _tasks.removeAt(index));
                _saveTasks();
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTaskDialog,
        label: const Text("New Task"),
        icon: const Icon(Icons.add_task), // Visual appeal with icons
      ),
    );
  }

  void _addTaskDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Task"),
        content: TextField(controller: _taskController, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (_taskController.text.isNotEmpty) {
                setState(() => _tasks.add(TodoTask(name: _taskController.text)));
                _saveTasks();
                _taskController.clear();
                Navigator.pop(ctx);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}