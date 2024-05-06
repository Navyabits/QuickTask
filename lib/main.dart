import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quick_task/screens/add_task_screen.dart';
import 'package:quick_task/screens/login_page.dart';
import 'package:quick_task/screens/signup_page.dart';
import 'package:quick_task/screens/signup_screen_notused.dart';
import 'package:quick_task/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:quick_task/screens/todo.dart';
import 'package:quick_task/services/auth_service.dart';
import 'package:quick_task/services/task_service.dart';

import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'package:go_router/go_router.dart';
import 'package:quick_task/back4app_config.dart';

void main() async {
  //  Parse code
  WidgetsFlutterBinding.ensureInitialized();

  // Parse Config Options
  const keyApplicationId = Back4AppConfig.applicationId;
  const keyParseServerUrl = 'http://123.45.678.90/parse';

  // Connect to Parse Server
  var response = await Parse().initialize(
      keyApplicationId, Back4AppConfig.parseServerUrl,
      clientKey: Back4AppConfig.clientKey);
  if (!response.hasParseBeenInitialized()) {
    exit(0);
  }

  // Create an Object to verify connected
  var firstObject = ParseObject('FirstClass')
    ..set('message', 'Parse Login Demo is Connected');
  await firstObject.save();

  print('done');
  // Parse code done
  runApp(const MyApp());
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/todo',
      builder: (context, state) => const Todo(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUp(),
    ),
    GoRoute(
      path: '/addTask',
      builder: (context, state) => AddTaskScreen(),
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
