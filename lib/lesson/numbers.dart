import 'package:flutter/material.dart';
import 'package:math_app/lesson/two.dart';
import 'package:math_app/settings/keys.dart';

class Numbers extends StatefulWidget {
  const Numbers({super.key});

  @override
  State<Numbers> createState() => _NumbersState();
}

class _NumbersState extends State<Numbers> {
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
              child: Text('١',style: TextStyle(fontSize: 70,),),
            ),
            SizedBox(
              height: Sizee.height(context)/50,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Two(), // Replace with your destination screen widget
                ),
              );

            }, child: Text("التالي")),

          ],
        ),
      ),
    );
  }
}
