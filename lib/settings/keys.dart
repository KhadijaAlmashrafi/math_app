import 'package:flutter/cupertino.dart';

class Sizee<Size>{

  Sizee._();
  static width(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
  static height(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

}