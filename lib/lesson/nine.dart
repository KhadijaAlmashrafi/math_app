import 'package:flutter/material.dart';
import 'package:math_app/lesson/eight.dart';
import 'package:math_app/lesson/ten.dart';

import '../settings/keys.dart';


class Nine extends StatefulWidget {
  const Nine({super.key});

  @override
  State<Nine> createState() => _NineState();
}

class _NineState extends State<Nine> {
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
              child: Text('٩',style: TextStyle(fontSize: 70,),),
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
                      builder: (context) => Ten(), // Replace with your destination screen widget
                    ),
                  );
                }, child: Text("التالي")),
                ElevatedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Eight(), // Replace with your destination screen widget
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
