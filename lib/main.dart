import 'package:digit_recognizer_flutter/screens/draw_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MNIST Digit Recognizer',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.black),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
        ),
      ),
      home: DrawScreen(),
    );
  }
}
