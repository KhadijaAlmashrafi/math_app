


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home.dart';
import '../login.dart';

final user = FirebaseAuth.instance.currentUser!;
class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData){
            print(snapshot.data!.email!);
            return Home();
          } else{
            return Login();
          }
        }),
      ),
    );
  }
}


//0000000000000000000000000000000000000000000000
// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthServices {
//
//    final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   //sign in anon
//   Future signInAnon()  async{
//     try {
//       UserCredential result = await _auth.signInAnonymously();
//       User? user = result.user;
//       return user;
//
//     } catch(e){
//       print(e.toString());
//       return null;
//
//     }
//   }
//   //sign in with email and pass
//
//   //register with email and pass
//
//   //sign ouy
//
// }