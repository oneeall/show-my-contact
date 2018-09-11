import 'package:flutter/material.dart';

ThemeData lightTheme(BuildContext context){
  return ThemeData.light().copyWith(
    primaryColor: Color(0xFF55acee),
    accentColor: Color(0xFF292f33),
    textTheme: Theme.of(context).textTheme.apply(
        displayColor: Colors.black,
        bodyColor: Colors.black
    ),
      primaryIconTheme: IconThemeData(color: Colors.white),
      accentIconTheme: IconThemeData(color: Colors.white)
  );
}

ThemeData darkTheme(BuildContext context){
  return ThemeData.dark().copyWith(
    primaryColor: Color(0xFF243447),
      textTheme: Theme.of(context).textTheme.apply(
          displayColor: Colors.white,
        bodyColor: Colors.white
      ),
    accentColor: Color(0xFF55acee),
      primaryIconTheme: IconThemeData(color: Colors.white),
      accentIconTheme: IconThemeData(color: Colors.white)
  );
}