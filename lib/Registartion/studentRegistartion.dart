import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login.dart';
import '../settings/keys.dart';

class SRegistartion extends StatefulWidget {
  const SRegistartion({Key? key}) : super(key: key);

  @override
  State<SRegistartion> createState() => _SRegistartionState();
}

class _SRegistartionState extends State<SRegistartion> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _teacherEmailController = TextEditingController();
  bool _isPasswordValid = true;
  bool _emailExists = false;
  bool _isLoading = false;
  bool _isLoading1 = false;
  bool _studentEmailExists = false;



  void _validatePassword(String password) {
    // Define the password validation rules
    RegExp passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    bool isValid = passwordRegExp.hasMatch(password);
    setState(() {
      _isPasswordValid = isValid;
    });
  }


  Future signUp() async {
    if (passwordConfirmed()) {
      addUserDetails(
        _studentNameController.text.trim(),
        _emailController.text.trim(),
        _teacherEmailController.text.trim(),
        _passwordController.text.trim(),
      );


    }
  }

  Future addUserDetails( String sName, String sEmail, String tEmail, String sPassword) async {
    await FirebaseFirestore.instance.collection('students').add({
      'full_name': sName,
      'email': sEmail,
      'teacher_email': tEmail,
      'password': sPassword,

    }).then((value) => {
    Navigator.of(context).pushNamed('/'),
    });

  }

  bool passwordConfirmed(){
    if  (_passwordController.text.trim() == _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _studentNameController.dispose();
    _teacherEmailController.dispose();
  }

  void _checkEmailExists(String email) async {
    if (email.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _emailExists = false;
      });

      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('teachers')
            .where('email', isEqualTo: email)
            .get();

        setState(() {
          _emailExists = snapshot.size > 0;
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _emailExists = false;
      });
    }
  }

  void _checkStudentEmailExists(String semail) async {
    if (semail.isNotEmpty) {
      setState(() {
        _isLoading1 = true;
        _studentEmailExists = false;
      });

      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('students')
            .where('email', isEqualTo: semail)
            .get();

        setState(() {
          _studentEmailExists = snapshot.size > 0;
          _isLoading1 = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading1 = false;
        });
      }
    } else {
      setState(() {
        _studentEmailExists = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left:40.0, right: 40.0) ,
              margin: EdgeInsets.only(left: .5 , right: .5) ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _studentNameController ,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      suffixIcon: Icon(Icons.person),
                      //icon: Icon(CupertinoIcons.person_alt_circle),
                      hintText: '  الإسم الثلاثي مع القبيلة',
                      alignLabelWithHint: true,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    width: Sizee.width(context) ,
                    height: Sizee.height(context)*0.03,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),

                      suffixIcon: Icon(Icons.email),
                      hintText: 'البريد الإلكتروني',
                      alignLabelWithHint: true,
                    ),
                    //textAlign: TextAlign.right,
                    onChanged: (semail) {
                      _checkStudentEmailExists(semail.trim());},
                    textAlign: TextAlign.right,
                  ),
                  _isLoading1
                  ? CircularProgressIndicator()
                  : !_studentEmailExists
                  ? Text(
                ''
                ,
                style: TextStyle(color: Colors.red),
              )
                  : Text(
                'أنت مسجل مسبقا',
                style: TextStyle(color: Colors.green),

                  ),
                  SizedBox(
                    width: Sizee.width(context) ,
                    height: Sizee.height(context)*0.03,
                  ),
                  TextField(
                    controller: _teacherEmailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      suffixIcon: Icon(Icons.attach_email),
                      hintText: 'البريد الإلكتروني للمعلم',
                      alignLabelWithHint: true,
                    ),
                    onChanged: (email) {
                    _checkEmailExists(email.trim());},
                    textAlign: TextAlign.right,
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : _emailExists
                      ? Text(
                    '',
                    style: TextStyle(color: Colors.green),
                  )
                      : Text(
                    'البريد الالكتروني غير موجود',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(
                    width: Sizee.width(context) ,
                    height: Sizee.height(context)*0.03,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      errorText: _isPasswordValid ? null : 'كلمة مرور غير صالحة. يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل، وحرف كبير واحد، وحرف صغير واحد، ورقم واحد على الأقل.',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      suffixIcon: Icon(Icons.lock),
                      hintText: 'كلمة المرور',
                      alignLabelWithHint: true,
                    ),
                    onChanged: (password) {
                      _validatePassword(password);
                    },
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    width: Sizee.width(context) ,
                    height: Sizee.height(context)*0.03,
                  ),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      suffixIcon: Icon(Icons.lock),
                      hintText: 'تأكيد كلمة المرور',
                      alignLabelWithHint: true,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    width: Sizee.width(context) ,
                    height: Sizee.height(context)*0.03,
                  ),
                  ElevatedButton(
                    onPressed: _isPasswordValid && _emailExists && !_studentEmailExists
                        ? () {
                      // Password is valid, do something with it
                      print('Password: ${_passwordController.text}');
                      signUp();
                    }: null,
                    child: Text("سجل الآن"),
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
              ),
            ),
          )
      ),
    );
  }
}
