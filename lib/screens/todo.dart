import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_task/models/task.dart';
import 'package:quick_task/screens/add_task_screen.dart';
import 'package:quick_task/services/auth_service.dart';
import 'package:quick_task/services/task_service.dart';

class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final taskService = TaskService();
  final authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              //Navigator.pushReplacementNamed(context, '/login');
              GoRouter.of(context).go('/');
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
                        onPressed: () async {
                          await taskService.deleteTask(task, context);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Icon(task.isCompleted
                            ? Icons.toggle_on_rounded
                            : Icons.toggle_off_rounded),
                        onPressed: () async {
                          await taskService.toggleTaskCompletion(task);
                          //setState(() {});
                          setState(() {
                            task.isCompleted = !task.isCompleted;
                          });
                          // await taskService.getTasks();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddTaskScreen(
                                    task:
                                        task)), // Adjust the screen to navigate to
                          );
                          // await taskService.getTasks();
                        },
                      )
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    AddTaskScreen()), // Adjust the screen to navigate to
          );
          // GoRouter.of(context).go('/addTask');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
