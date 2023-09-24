import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:math_app/login.dart';
import 'package:math_app/services/auth.dart';
import 'package:math_app/settings/color.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: ArabicThemeData.font(arabicFont: ArabicFont.cairo),
          package: ArabicThemeData.package,
          appBarTheme: const AppBarTheme(elevation: 0, color: Colors.white),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: mainColor,
              onSecondary: mainColor,
              background: Colors.white
          )
      ),
      //home: const Auth(),
      routes: {
        '/':(context) => const Auth(),
      },
    );
  }
}

