

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jelly_anim/jelly_anim.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_app/registration.dart';
import 'package:math_app/screens/parentHome.dart';
import 'package:math_app/screens/studentHome.dart';
import 'package:math_app/screens/teacherHome.dart';
import 'package:math_app/services/resetPassword.dart';
import 'package:math_app/settings/color.dart';
import 'package:math_app/settings/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);


  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;

  shared() async {
    SharedPreferences save = await SharedPreferences.getInstance();
    print(save.get('email'));
    print(save.get('type'));

    if (save.get('email') != null){
      switch(save.get('type')){
        case 'students':
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StudentHome()));
          break;
        case 'teachers':
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TeacherHome()));
          break;
        case 'parents':
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ParentHome()));
          break;
      }

    }
  }


  Future signIn() async {
    SharedPreferences save = await SharedPreferences.getInstance();


    if (_selectedRole!.isNotEmpty){
      FirebaseFirestore.instance.collection(_selectedRole!).where("email",
      isEqualTo: _emailController.text.trim()).
      where("password", isEqualTo: _passwordController.text.trim()).get().then(
              (value) => {
        save.setString('email', value.docs.first.data()["email"]),
        save.setString('type', _selectedRole!),
        shared(),
        //print(value.docs.first.data())

      });

    }

   // await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shared();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Container(
        height: Sizee.height(context),
        width: Sizee.width(context),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: Sizee.width(context) ,
                height: Sizee.height(context)*0.2,
              ),
              Stack(
                children: [
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: JellyAnim(
                        radius: 140,
                        viewPortSize: Size(300, 300),
                        jellyCoordinates: 5,
                        colors: [
                          textColor.withOpacity(0.50),
                          mainColor
                        ],
                        duration: Duration(microseconds: 1 ),
                        jellyPosition: JellyPosition.center,
                      ),
                  ),
                  Image.asset('assets/mathstudent.png',width: 300, height: 300,)
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left:40.0, right: 40.0) ,
                    margin: EdgeInsets.only(left: .5 , right: .5) ,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        //icon: Icon(CupertinoIcons.person_alt_circle),
                        hintText: '  اسم المستخدم',
                        alignLabelWithHint: true,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: Sizee.width(context) ,
                    height: Sizee.height(context)*0.01,
                  ),
                  Container(
                    padding: EdgeInsets.only(left:40.0, right: 40.0) ,
                    margin: EdgeInsets.only(left: .5 , right: .5) ,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        //icon: Icon(CupertinoIcons.person_alt_circle),
                        hintText: '  كلمة المرور',
                        alignLabelWithHint: true,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: Sizee.width(context) ,
                    height: Sizee.height(context)*0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('معلم'),
                          Radio(
                            value: 'teachers',
                            groupValue: _selectedRole,
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('ولي أمر'),
                          Radio(
                            value: 'parents',
                            groupValue: _selectedRole,
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('طالب'),
                          Radio(
                            value: 'students',
                            groupValue: _selectedRole,
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                    width: Sizee.width(context) ,
                    height: Sizee.height(context)*0.01,
                  ),
                  ElevatedButton(
                    onPressed: signIn,
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                     child: Text("دخول"),
                    style: ButtonStyle(

                        minimumSize: MaterialStateProperty.all(Size(200.0, 50.0)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                        )
                      )
                    ),
                  ),
                  SizedBox(
                    width: Sizee.width(context) ,
                    height: Sizee.height(context)*0.01,
                  ),
                  GestureDetector(
                    child:RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'نسيت كلمة المرور',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPasswordScreen()));
                    } ,

                  ),
                  GestureDetector(
                    child:RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'غير مسجل ، ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'سجل الآن',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    // Text('غير مسجل ، سجل الآن',
                    //   style: TextStyle(color: Colors.blue,
                    //   ),
                    // ),
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Registration()));
                    } ,

                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );}}