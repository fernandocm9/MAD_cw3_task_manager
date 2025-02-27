import 'package:flutter/material.dart';

class Task {
  int taskId;
  String title;
  String description;
  bool isCompleted = false;

  Task({required this.taskId, required this.title, required this.description, this.isCompleted = false});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const TaskListScreen(title: 'Task Manager'),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, required this.title});
  final String title;

  @override
  State<TaskListScreen> createState() => _TaskListScreen();
}

class _TaskListScreen extends State<TaskListScreen> {
  late TextEditingController titleController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  List<Task> _taskList = [];
  int _taskId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _taskList.length,
          itemBuilder: (context, index) {
            final task = _taskList[index];
            return ListTile(
              title: Text(task.title),
              tileColor: task.isCompleted ? Colors.green : Colors.red,
              subtitle: Text(task.description),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        task.isCompleted = value!;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _taskList.removeAt(index);
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      titleController.text = task.title;
                      descController.text = task.description;
                      _openDialog();
                    },
                  ),
                ],
              ), 
              isThreeLine: true,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openDialog() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Task Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Enter Task Title'),
                controller: titleController,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Enter Task Description'),
                controller: descController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                  Navigator.of(context).pop([titleController.text, descController.text]);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (result != null && result.length == 2) {
      setState(() {
        _taskId++;
        _taskList.add(Task(
          taskId: _taskId,
          title: result[0],
          description: result[1],
        ));
      });
    }
  }
}
