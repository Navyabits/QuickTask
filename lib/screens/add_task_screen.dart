import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_task/models/task.dart';
import 'package:quick_task/screens/todo.dart';
import 'package:quick_task/services/task_service.dart';
import 'home_screen.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class AddTaskScreen extends StatefulWidget {
  //final Function updateTaskList;
  final Task? task;

  AddTaskScreen(
      {super.key,
      //required this.updateTaskList,
      this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  static final _formKey = GlobalKey<FormState>();
  String _title = '';
  String? _priority;
  String? _taskid;
  bool _isCompleted = false;
  DateTime _date = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final taskService = TaskService();
  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _title = widget.task!.title;
      _date = widget.task!.dueDate;
      _taskid = widget.task!.taskid;
      _isCompleted = widget.task!.isCompleted;
    }

    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != _date) {
      setState(() {
        _date = date!;
      });
      _dateController.text = _dateFormatter.format(date!);
    }
  }

  Future<void> _delete(BuildContext context) async {
    taskService.deleteTask(widget.task!, context);
    Navigator.pop(context);
    //widget.updateTaskList();
    await taskService.getTasks();
    Toast.show("Task Deleted",
        duration: Toast.lengthLong, gravity: Toast.bottom);
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_title, $_date');
      Task task = Task(title: _title, dueDate: _date);
      if (widget.task == null) {
        // Insert the task to our user's database
        task.isCompleted = false;
        await taskService.addTask(task);
        ToastContext().init(context);
        Toast.show("New Task Added",
            duration: Toast.lengthLong, gravity: Toast.bottom);
      } else {
        // Update the task
        task.taskid = _taskid;
        task.isCompleted = widget.task!.isCompleted;
        await taskService.updateTask(task);
        ToastContext().init(context);
        Toast.show("Task Updated",
            duration: Toast.lengthLong, gravity: Toast.bottom);
      }
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Todo()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context)),
        title: Row(children: [
          Text(
            widget.task == null ? 'Add Task' : 'Update Task',
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ]),
        // actions: [
        //   IconButton(
        //       icon: Icon(
        //         Icons.info_outline,
        //         color: Colors.black,
        //       ),
        //       onPressed: () {}),
        // ],
        centerTitle: false,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: const TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => input!.trim().isEmpty
                              ? 'Please enter a task title'
                              : null,
                          onSaved: (input) => _title = input!,
                          initialValue: _title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          style: const TextStyle(fontSize: 18.0),
                          onTap: _handleDatePicker,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle: const TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        // ignore: deprecated_member_use
                        child: TextButton(
                          child: Text(
                            widget.task == null ? 'Add' : 'Update',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          onPressed: () async {
                            await _submit(context);
                          },
                        ),
                      ),
                      // widget.task != null
                      //     ? Container(
                      //         margin: const EdgeInsets.symmetric(vertical: 0.0),
                      //         height: 60.0,
                      //         width: double.infinity,
                      //         decoration: BoxDecoration(
                      //           color: Theme.of(context).primaryColor,
                      //           borderRadius: BorderRadius.circular(30.0),
                      //         ),
                      //         // ignore: deprecated_member_use
                      //         child: TextButton(
                      //           child: const Text(
                      //             'Delete',
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 20.0,
                      //             ),
                      //           ),
                      //           onPressed: () async {
                      //             await _delete(context);
                      //           },
                      //         ),
                      //       )
                      //     : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
