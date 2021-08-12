import 'package:flutter/material.dart';

final themeData = ThemeData(
  primaryColor: Colors.blue,
  accentColor: Colors.blueAccent,
  backgroundColor: Color(0xfffafafa),
  textTheme: TextTheme(
    headline3: TextStyle(color: Colors.black, fontSize: 20),
    headline4: TextStyle(color: Colors.black, fontSize: 16),
    headline6: TextStyle(color: Colors.black, fontSize: 12),
  ),
);

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
  );
}

final double messageTileMargin = 7.0;
final double messageTileBorderRadius = 20.0;
final Color messageColor1 = Color(0xffb3e5fc);
final Color messageColor2 = Color(0xffe1bee7);
