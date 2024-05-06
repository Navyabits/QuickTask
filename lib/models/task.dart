import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Task {
  String? taskid;
  String title;
  DateTime dueDate;
  bool isCompleted;

  Task(
      {this.taskid,
      required this.title,
      required this.dueDate,
      this.isCompleted = false});

  ParseObject toParseObject() {
    var parseObject = ParseObject('Task');
    parseObject.set('taskid', this.taskid);
    parseObject.set('isCompleted', this.isCompleted);
    parseObject.set('title', this.title);
    parseObject.set('dueDate', this.dueDate);
    return parseObject;
  }
}
