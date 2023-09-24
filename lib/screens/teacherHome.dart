import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import '../settings/color.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({Key? key}) : super(key: key);

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  Future<void> _signOut(BuildContext context) async {
    try {
      SharedPreferences save = await SharedPreferences.getInstance();
      save.clear();
      // Clear any locally stored authentication tokens or credentials here.
      // For example, you can use shared preferences or secure storage to store user tokens.

      // Remove any references to the current user.
      // For example, if you are using Provider, you can do something like:
      // Provider.of<UserData>(context, listen: false).clearUserData();

      // Navigate to the login page.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
            (route) => false, // Remove all previous routes from the stack.
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () => _signOut(context), child: Text('sign out')),
              Text('teacher home'),
            ],
          ),
        )
      //Text('student home'),
    );
  }
}