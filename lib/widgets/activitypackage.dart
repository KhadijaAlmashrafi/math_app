import 'package:flutter/material.dart';

class ActivityButton extends StatelessWidget {
  final Color color;
  final Image image;
  final Function onPressed;
  final Color scolor;

  ActivityButton({required this.color,required this.scolor, required this.image, required this.onPressed});
  //const ActivityButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color ?? Colors.blue, // Button color
        child: InkWell(
          splashColor: scolor ?? Colors.red, // Splash color
          onTap: () => onPressed(),
          child: SizedBox(width: 56, height: 56, child: image),
        ),
      ),
    );
  }
}

