import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../home.dart';
import '../login.dart';
import '../settings/keys.dart';

class TRegistartion extends StatefulWidget {
  const TRegistartion({Key? key}) : super(key: key);

  @override
  State<TRegistartion> createState() => _TRegistartionState();
}
TextEditingController _passwordController = TextEditingController();
class _TRegistartionState extends State<TRegistartion> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _teacherNameController = TextEditingController();
  final _teacherPhoneController = TextEditingController();
  bool _isPasswordValid = true;
  bool _emailExists = false;
  bool _isLoading = false;
  final String errorMessage = 'كلمة مرور غير صالحة. يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل، وحرف كبير واحد، وحرف صغير واحد، ورقم واحد على الأقل.';

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
      ).then((value) => {addUserDetails(
      _teacherNameController.text.trim(),
      _emailController.text.trim(),
      int.parse(_teacherPhoneController.text.trim()),
      _passwordController.text.trim(),
        value.user!.uid!
      ),});

    }
  }


  Future addUserDetails( String tName, String tEmail, int tPhone, String tPassword, String tUserId,) async {
    await FirebaseFirestore.instance.collection('teachers').doc(tUserId).set({
      'full name': tName,
      'email': tEmail,
      'teacher phone no': tPhone,
      'password': tPassword,

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
    _teacherNameController.dispose();
    _teacherPhoneController.dispose();
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
                 controller: _teacherNameController,
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

                // textAlign: TextAlign.right,
                 onChanged: (email) {
                   _checkEmailExists(email.trim());},
                  textAlign: TextAlign.right,
               ),
           _isLoading
               ? CircularProgressIndicator()
               : !_emailExists
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
               IntlPhoneField(
                 controller: _teacherPhoneController,
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
                   errorText: _isPasswordValid ? null :  'كلمة مرور غير صالحة. يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل، وحرف كبير واحد، وحرف صغير واحد، ورقم واحد على الأقل.',

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
