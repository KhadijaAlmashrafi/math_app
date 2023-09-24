import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      // Show a success message or navigate to a screen indicating that a password reset link has been sent.
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text("تم إرسال رابط إعادة تعيين كلمة المرور! تحقق من بريدك الإلكتروني"),
            );
          }
      );
    } on FirebaseAuthException catch (e) {
      // Show an error message or handle the error accordingly.
      print('Error sending password reset email: $e');
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('لإعادة تعيين كلمة المرور اكتب الإيميل المستخدم لتسجيل الدخول وسيصلك رابط لإعادة تعيين كلمة المرور على البريد الالكتروني',
                textAlign: TextAlign.center,),
              SizedBox(height: 16.0),
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
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text('إعادة تعيين كلمة المرور'),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(100.0, 50.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        )
                    )
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
