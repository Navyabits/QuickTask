import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quick_task/back4app_config.dart';
import 'package:quick_task/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_task/screens/home_screen.dart';

class AuthService {
  AuthService() {
    Parse().initialize(
      Back4AppConfig.applicationId,
      Back4AppConfig.parseServerUrl,
      clientKey: Back4AppConfig.clientKey,
      autoSendSessionId: true,
    );
  }

  // Future<User?> signUp(String username, String email, String password) async {
  //   final user = ParseUser.createUser(username, password, email);
  //   try {
  //     await user.signUp();
  //     return User(username: user.username!);
  //   } catch (e) {
  //     print('Error signing up: $e');
  //     return null;
  //   }
  // }

  Future<User?> signUp(String username, String email, String password,
      BuildContext context) async {
    try {
      var user = ParseUser(username, password, email)..set('email', email);
      await user.signUp();
      Fluttertoast.showToast(
        msg: 'User account created successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(username: username)),
      );
      return User(username: user.username!);
    } catch (e) {
      print('Error signing up: $e');
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  // Future<User?> login(String username, String password, String? email) async {
  //   try {
  //     await ParseUser(username, password, email).login();
  //     return User(username: username);
  //   } catch (e) {
  //     print('Error logging in: $e');
  //     return null;
  //   }
  // }

  Future<User?> login(
      String username, String password, BuildContext context) async {
    try {
      var user = await ParseUser(username, password, null).login();
      Fluttertoast.showToast(
        msg: 'Logged in successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(username: username)),
      );
      return User(username: username);
    } catch (e) {
      print('Error logging in: $e');
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  Future<void> logout() async {
    final currentUser = await ParseUser.currentUser();
    if (currentUser != null) {
      await currentUser.logout();
    }
  }

  Future<User?> getCurrentUser() async {
    final currentUser = await ParseUser.currentUser();
    if (currentUser != null) {
      await currentUser.fetch();
      return User(
          username: currentUser.username!,
          email: currentUser.email!,
          password: currentUser.password);
    }
    return null;
  }
}
