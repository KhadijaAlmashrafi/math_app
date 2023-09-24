import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../login.dart';
import '../settings/keys.dart';

class PRegistartion extends StatefulWidget {
  const PRegistartion({Key? key}) : super(key: key);

  @override
  State<PRegistartion> createState() => _PRegistartionState();
}

class _PRegistartionState extends State<PRegistartion> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _childEmailController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _parentNameController = TextEditingController();
  bool _isPasswordValid = true;
  bool _emailExists = false;
  bool _isLoading = false;

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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
      ).then((value) => {
      addUserDetails(
        pName: _parentNameController.text.trim(),
        pEmail: _emailController.text.trim(),
        cEmail: _childEmailController.text.trim(),
        pPhone: int.parse(_parentPhoneController.text.trim()),
        pPassword: _passwordController.text.trim(),
          pUserId: value.user!.uid!
      ),

      });



    }
  }

  Future addUserDetails( {required String pName, required String pEmail, required String cEmail,
    required int pPhone, required String pPassword, required String pUserId}) async {
    await FirebaseFirestore.instance.collection('parents').doc(pUserId).set({
      'full_name': pName,
      'email': pEmail,
      //'child email': cEmail,
      'parent_phone': pPhone,
      'password': pPassword,

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
    _childEmailController.dispose();
    _parentPhoneController.dispose();
    _parentNameController.dispose();
  }

  void _checkEmailExists(String email) async {
    if (email.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _emailExists = true;
      });

      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('parents')
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: Sizee.height(context)*0.15,
        // title: Text('How to Flutter', style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 28
        // ),) ,
        // centerTitle: true,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //       image: DecorationImage(
        //           image: AssetImage('assets/bc.jpg'),
        //           fit: BoxFit.fill
        //       )
        //   ),
        // ),

      ),
      body:Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left:40.0, right: 40.0) ,
              margin: EdgeInsets.only(left: .5 , right: .5) ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _parentNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      suffixIcon: Icon(Icons.person),
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
                    onChanged: (email) {
                      _checkEmailExists(email.trim());},
                    textAlign: TextAlign.right,
                  ),
              _isLoading
                  ? CircularProgressIndicator()
                  : !_emailExists
                  ? Text(
                  ''
              )
                  : Text(
                'أنت مسجل مسبقا',
                style: TextStyle(color: Colors.green),

              ),

                  SizedBox(
                    width: Sizee.width(context) ,
                    height: Sizee.height(context)*0.03,
                  ),

                  IntlPhoneField(
                    controller: _parentPhoneController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      suffixIcon: Icon(Icons.phone_enabled_sharp),
                      hintText: 'رقم الهاتف',
                      alignLabelWithHint: true,
                    ),
                    textAlign: TextAlign.right,
                    initialCountryCode: 'OM',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                    onCountryChanged: (country) {
                      print('Country changed to: ' + country.name);
                    },
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
                    onPressed: _isPasswordValid && !_emailExists
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
