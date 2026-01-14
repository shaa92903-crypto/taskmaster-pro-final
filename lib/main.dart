import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const TaskProApp());

class TaskProApp extends StatelessWidget {
  const TaskProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueAccent),
      home: const TaskHomeScreen(),
    );
  }
}

class TaskHomeScreen extends StatefulWidget {
  const TaskHomeScreen({super.key});
  @override
  State<TaskHomeScreen> createState() => _TaskHomeScreenState();
}

class _TaskHomeScreenState extends State<TaskHomeScreen> {
  final List<String> _tasks = []; // Task 1: Basic State Management
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStoredData(); // Task 2: Persistent Storage
  }

  // Task 2: Logic to save and retrieve data locally
  Future<void> _loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks.addAll(prefs.getStringList('stored_tasks') ?? []);
    });
  }

  Future<void> _syncToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('stored_tasks', _tasks);
  }

  void _handleAddTask() {
    if (_controller.text.isNotEmpty) {
      setState(() => _tasks.insert(0, _controller.text)); // Update UI state
      _syncToStorage(); // Update local storage
      _controller.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advanced Task Pro", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      // Task 3: Display tasks in a ListView
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tasks.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(_tasks[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() => _tasks.removeAt(index));
                _syncToStorage();
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModal(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Task"),
        content: TextField(controller: _controller, autofocus: true),
        actions: [
          ElevatedButton(onPressed: _handleAddTask, child: const Text("Save Task")),
        ],
      ),
    );
  }
}