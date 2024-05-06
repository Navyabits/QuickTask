import 'package:flutter/material.dart';
import 'package:quick_task/models/task.dart';
import 'package:quick_task/screens/add_task_screen.dart';
import 'package:quick_task/services/task_service.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    final taskService = TaskService(); // Get instance of TaskService

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks for $username'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: taskService.getTasks(), // Call getTasks() here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final tasks = snapshot.data ?? [];
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                Task task = tasks[index];
                return ListTile(
                  title: Text(task.title!),
                  subtitle: Text('Due Date: ${task.dueDate}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Implement delete task functionality
                        },
                      ),
                      IconButton(
                        icon: Icon(task.isCompleted
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                        onPressed: () {
                          // Implement toggle completion status functionality
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
