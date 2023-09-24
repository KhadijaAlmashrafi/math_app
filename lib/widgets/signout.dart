
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignOutScreen extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      // Clear any locally stored authentication tokens or credentials here.
      // For example, you can use shared preferences or secure storage to store user tokens.

      // Remove any references to the current user.
      // For example, if you are using Provider, you can do something like:
      // Provider.of<UserData>(context, listen: false).clearUserData();

      // Navigate back to the login or home screen.
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Out'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _signOut(context),
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
