import 'package:flutter/material.dart';

class AppTheme {
  // Private Constructor
  AppTheme._();
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    primaryColor: Colors.deepPurple,
    primaryIconTheme: IconThemeData(color: Colors.black),
    backgroundColor: Colors.grey[100],
    primaryTextTheme: TextTheme(
      headline6: TextStyle(color: Colors.black),
    ),
    canvasColor: Colors.purple[400],
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: Colors.deepPurple,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    textTheme: TextTheme(
      bodyText2: TextStyle(
        color: Colors.black,
      ),
    ),
    // ... more
  );
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurple,
    backgroundColor: Colors.grey[300],
    canvasColor: Colors.grey[900],
    iconTheme: IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      color: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyText2: TextStyle(
        color: Colors.white,
      ),
    ),
    // ... more
  );
}
