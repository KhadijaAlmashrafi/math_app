import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math_app/lesson/numbers.dart';
import 'package:math_app/settings/keys.dart';
import 'package:math_app/widgets/activitypackage.dart';
import 'package:math_app/widgets/signout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';

class Child {
  final String name;

  Child(this.name);
}

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();

}


class _StudentHomeState extends State<StudentHome> {

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
      body: SingleChildScrollView(
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('...درس تعليمي...',
                  style: TextStyle(fontSize: 40),
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ActivityButton(
                            color: Colors.blue, // Button color
                            scolor: Colors.red, // Splash color
                            image: Image.asset('assets/bear1.jpg'), // Replace with your image
                            onPressed: () {
                              try{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Numbers(), // Replace with your destination screen
                                ),
                              );
                            }catch(e){
                                print('Navigation error: $e');
                              }
                            }
                          ),

                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text('...خزانة اللعب...',
                  style: TextStyle(fontSize: 40),
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          ActivityButton(
                            color: Colors.blue, // Button color
                            scolor: Colors.red, // Splash color
                            image: Image.asset('assets/bear1.jpg'), // Replace with your image
                            onPressed: () {
                              // Your onTap logic here
                            },
                          ),
                          ActivityButton(
                            color: Colors.blue, // Button color
                            scolor: Colors.red, // Splash color
                            image: Image.asset('assets/bear1.jpg'), // Replace with your image
                            onPressed: () {
                              // Your onTap logic here
                            },
                          ),
                          ActivityButton(
                            color: Colors.blue, // Button color
                            scolor: Colors.red, // Splash color
                            image: Image.asset('assets/bear1.jpg'), // Replace with your image
                            onPressed: () {
                              // Your onTap logic here
                            },
                          ),

                        ],
                      ),
                      SizedBox(height: 30),
                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          ActivityButton(
                            color: Colors.blue, // Button color
                            scolor: Colors.red, // Splash color
                            image: Image.asset('assets/bear1.jpg'), // Replace with your image
                            onPressed: () {
                              // Your onTap logic here
                            },
                          ),
                          ActivityButton(
                            color: Colors.blue, // Button color
                            scolor: Colors.red, // Splash color
                            image: Image.asset('assets/bear1.jpg'), // Replace with your image
                            onPressed: () {
                              // Your onTap logic here
                            },
                          ),
                          ActivityButton(
                            color: Colors.blue, // Button color
                            scolor: Colors.red, // Splash color
                            image: Image.asset('assets/bear1.jpg'), // Replace with your image
                            onPressed: () {
                              // Your onTap logic here
                            },
                          ),

                        ],
                      ),
                      SizedBox(height: 30),
                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          ActivityButton(
                            color: Colors.blue, // Button color
                            scolor: Colors.red, // Splash color
                            image: Image.asset('assets/bear1.jpg'), // Replace with your image
                            onPressed: () {
                              // Your onTap logic here
                            },
                          ),


                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text('...أرقام اليرقة...',
                  style: TextStyle(fontSize: 40),
                ),
                IconButton(onPressed: () => _signOut(context), icon: Icon(Icons.door_back_door_outlined)),

                // ElevatedButton(onPressed: () => _signOut(context), child: Text('sign out')),
                // Text('student home'),
              ],
            ),
          )
      )

      //Text('student home'),
    );
  }
}


// ClipOval(
// child: Material(
// color: Colors.blue, // Button color
// child: InkWell(
// splashColor: Colors.red, // Splash color
// onTap: () {},
// child: SizedBox(width: 56, height: 56, child: Icon(Icons.menu)),
// ),
// ),
// )


