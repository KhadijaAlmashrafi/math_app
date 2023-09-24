import 'package:flutter/material.dart';
import 'package:math_app/screens/studentHome.dart';

import '../settings/keys.dart';
import 'nine.dart';


class Ten extends StatefulWidget {
  const Ten({super.key});

  @override
  State<Ten> createState() => _TenState();
}

class _TenState extends State<Ten> {
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
              child: Text('١٠',style: TextStyle(fontSize: 70,),),
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
                      builder: (context) => StudentHome(), // Replace with your destination screen widget
                    ),
                  );
                }, child: Text("النهاية")),
                ElevatedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Nine(), // Replace with your destination screen widget
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
