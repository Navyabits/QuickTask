//import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/task.dart';
import 'package:quick_task/back4app_config.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:flutter/foundation.dart';

class TaskService extends ChangeNotifier {
  TaskService() {
    Parse().initialize(
      Back4AppConfig.applicationId,
      Back4AppConfig.parseServerUrl,
      clientKey: Back4AppConfig.clientKey,
      autoSendSessionId: true,
    );
  }

  Future<List<Task>> getTasks() async {
    final currentUser = ParseUser.currentUser();
    if (currentUser != null) {
      final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Task'));
      //..whereEqualTo('user', currentUser);
      final response = await queryBuilder.query();
      if (response.success && response.results != null) {
        return response.results!.map((task) {
          if (task is ParseObject) {
            return Task(
              taskid: task.get('taskid') as String,
              title: task.get('title') as String,
              dueDate: task.get('dueDate') as DateTime,
              isCompleted: task.get('isCompleted') as bool,
            );
          } else {
            throw Exception('Unexpected data type for task: $task');
          }
        }).toList();
      }
    }
    return [];
  }

  Future<void> addTask(Task task) async {
    final currentUser = ParseUser.currentUser();
    if (currentUser != null) {
      final newTask = ParseObject('Task')
        ..set('taskid', currentUser.hashCode.toString() + task.title)
        ..set('title', task.title)
        ..set('dueDate', task.dueDate)
        ..set('isCompleted', task.isCompleted);
      // ..set('user', currentUser);
      try {
        await newTask.save();
        // After successfully saving the task, navigate to the '/todo' route
      } catch (e) {
        // Handle any errors that occur during task saving
        print('Error saving task: $e');
        // Optionally, display an error message or perform other error handling
      }
      //await getTasks();
      //GoRouter.of(context).go('/todo');
    }
  }

  Future<void> deleteTask(Task task, BuildContext context) async {
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('taskid', task.taskid);
    final response = await queryBuilder.query();
    if (response.success &&
        response.results != null &&
        response.results!.isNotEmpty) {
      final taskToDelete = response.results!.first;
      await taskToDelete.delete();
      //await getTasks();
      //   GoRouter.of(context).go('/todo');
    }
  }

  Future<void> updateTask(Task task) async {
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('taskid', task.taskid);
    final response = await queryBuilder.query();
    if (response.success &&
        response.results != null &&
        response.results!.isNotEmpty) {
      final taskToUpdate = response.results!.first;
      taskToUpdate.set('title', task.title);
      taskToUpdate.set('dueDate', task.dueDate);
      taskToUpdate.set('isCompleted', task.isCompleted);
      await taskToUpdate.save();
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    // final index = tasks.indexOf(task);
    // tasks[index].completed = !tasks[index].completed;

    // Update the completion status on the Parse server
    // final parseObject = ParseObject('Task')
    //   // ..set('taskid', task.taskid)
    //   //     .taskid // Assuming you have an objectId property in your Task model
    //   ..set('isCompleted', !task.isCompleted);
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('taskid', task.taskid);
    final response = await queryBuilder.query();
    if (response.success &&
        response.results != null &&
        response.results!.isNotEmpty) {
      final taskToUpdate = response.results!.first;
      taskToUpdate.set('isCompleted', !task.isCompleted);
      try {
        await taskToUpdate.save();
        notifyListeners();
      } catch (e) {
        print('Error updating task completion status: $e');
        // Revert the local change if updating on the server fails
        //tasks[index].completed = !tasks[index].completed;
        notifyListeners();
        throw e; // Rethrow the error for handling in UI
      }
    }
  }
}
