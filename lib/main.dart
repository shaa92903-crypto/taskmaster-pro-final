/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCmnh3beElzc9jsSxBHn8uYVeeXJ1_js-8",
      appId: "1:253933620702:android:85966fc09ca3ce814b214f",
      messagingSenderId: "253933620702",
      projectId: "com.example.taskmaster_pro",
      databaseURL: "https://taskmasterpro-1ad54-default-rtdb.firebaseio.com/",
    ),
  );
  runApp(RealTimeTaskApp());
}


class RealTimeTaskApp extends StatelessWidget {
  const RealTimeTaskApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const TaskScreen(),
    );
  }
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('tasks');
  final TextEditingController _controller = TextEditingController();

  // Task 1: Add a task to Realtime Database
  void _addTask() {
    if (_controller.text.isNotEmpty) {
      _dbRef.push().set({
        'title': _controller.text,
        'isCompleted': false, // Requirement: Functional task management
      });
      _controller.clear();
      Navigator.pop(context);
    }
  }

  // Task 1: Mark as complete / Toggle status
  void _toggleComplete(String key, bool currentStatus) {
    _dbRef.child(key).update({'isCompleted': !currentStatus});
  }

  // Task 1: Delete functionality
  void _deleteTask(String key) {
    _dbRef.child(key).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Task 3: Custom App Bar with action button and icons
      appBar: AppBar(
        title: const Text("TaskMaster Cloud", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.cloud_done), onPressed: () {}),
        ],
        backgroundColor: Colors.indigo.shade100,
      ),
      body: StreamBuilder(
        stream: _dbRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List<dynamic> keys = map.keys.toList();

            return ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) {
                String key = keys[index];
                var data = map[key];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: ListTile(
                    leading: Checkbox(
                      value: data['isCompleted'],
                      onChanged: (_) => _toggleComplete(key, data['isCompleted']),
                    ),
                    title: Text(
                      data['title'],
                      style: TextStyle(
                        decoration: data['isCompleted'] ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteTask(key),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("No tasks found in the cloud."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Cloud Task"),
        content: TextField(controller: _controller, autofocus: true),
        actions: [
          ElevatedButton(onPressed: _addTask, child: const Text("Add Task")),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCmnh3beElzc9jsSxBHn8uYVeeXJ1_js-8",
      appId: "1:253933620702:android:85966fc09ca3ce814b214f",
      messagingSenderId: "253933620702",
      projectId: "com.example.taskmaster_pro",
      databaseURL: "https://taskmasterpro-1ad54-default-rtdb.firebaseio.com/",
    ),
  );
  runApp(const RealTimeTaskApp());
}

class RealTimeTaskApp extends StatelessWidget {
  const RealTimeTaskApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // PINK THEME: Using pink as the seed color for Material 3
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pinkAccent,
        brightness: Brightness.light,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaskScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PINK THEME: Splash screen background
      backgroundColor: Colors.pink.shade400,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_done_rounded, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "TaskMaster Cloud",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('tasks');
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      _dbRef.push().set({
        'title': _controller.text,
        'isCompleted': false,
      });
      _controller.clear();
      Navigator.pop(context);
    }
  }

  void _toggleComplete(String key, bool currentStatus) {
    _dbRef.child(key).update({'isCompleted': !currentStatus});
  }

  void _deleteTask(String key) {
    _dbRef.child(key).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TaskMaster Cloud", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.cloud_done), onPressed: () {}),
        ],
        // PINK THEME: Light pink for the App Bar
        backgroundColor: Colors.pink.shade50,
      ),
      body: StreamBuilder(
        stream: _dbRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List<dynamic> keys = map.keys.toList();

            return ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) {
                String key = keys[index];
                var data = map[key];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  // PINK THEME: Subtle pink borders for cards
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.pink.shade100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      // PINK THEME: Checkbox color will follow colorSchemeSeed automatically
                      value: data['isCompleted'],
                      onChanged: (_) => _toggleComplete(key, data['isCompleted']),
                    ),
                    title: Text(
                      data['title'],
                      style: TextStyle(
                        decoration: data['isCompleted'] ? TextDecoration.lineThrough : null,
                        color: data['isCompleted'] ? Colors.grey : Colors.black87,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.pink),
                      onPressed: () => _deleteTask(key),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("No tasks found in the cloud."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        // PINK THEME: Floating action button
        backgroundColor: Colors.pink.shade400,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Cloud Task"),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.pink))),
        ),
        actions: [
          ElevatedButton(
            onPressed: _addTask,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade50),
            child: const Text("Add Task", style: TextStyle(color: Colors.pink)),
          ),
        ],
      ),
    );
  }
}