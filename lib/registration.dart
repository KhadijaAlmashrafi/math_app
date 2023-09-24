import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_app/Registartion/parentRegistartion.dart';
import 'package:math_app/Registartion/teacherRegistration.dart';
import 'package:math_app/settings/keys.dart';

import 'Registartion/studentRegistartion.dart';
import 'login.dart';
class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set the desired color here
        title: Text('النسجيل'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SRegistartion() ));
            }, child: Text("التسجيل كطالب"),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(200.0, 50.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      )
                  )
              ),),
            SizedBox(
              width: Sizee.width(context) ,
              height: Sizee.height(context)*0.01,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> TRegistartion()));
            }, child: Text("التسجيل كمعلم"),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(200.0, 50.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      )
                  )
              ),),
            SizedBox(
              width: Sizee.width(context) ,
              height: Sizee.height(context)*0.01,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> PRegistartion()));
            }, child: Text("التسجيل كولي أمر"),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(200.0, 50.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      )
                  )
              ),),
            SizedBox(
              width: Sizee.width(context) ,
              height: Sizee.height(context)*0.01,
            ),
            GestureDetector(
              child:RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'تسجيل الدخول',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Login() ));
              } ,

            ),
          ],
        ) ,
      ),
    );
  }
}
