import 'package:flutter/material.dart';
import 'package:math_app/lesson/three.dart';

import '../settings/keys.dart';
import 'five.dart';

class Four extends StatefulWidget {
  const Four({super.key});

  @override
  State<Four> createState() => _FourState();
}

class _FourState extends State<Four> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('...كرر معي الأعداد...',style: TextStyle(fontSize: 30),),
            SizedBox(
              height: Sizee.height(context)/50,
            ),
            Container(
              color: Colors.lightBlueAccent,
              width: Sizee.width(context)-(Sizee.width(context)/3),
              height: Sizee.height(context)-(Sizee.width(context)/0.85),
              child: Text('٤',style: TextStyle(fontSize: 70,),),
            ),
            SizedBox(
              height: Sizee.height(context)/50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Five(), // Replace with your destination screen widget
                    ),
                  );
                }, child: Text("التالي")),
                ElevatedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Three(), // Replace with your destination screen widget
                    ),
                  );

                }, child: Text("السابق"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
