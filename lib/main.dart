
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_application_0/screens/category_screen.dart';
import 'package:flutter_application_0/screens/home_page.dart';
import 'package:flutter_application_0/screens/question_ui.dart';  // Add this import for Timer

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
      // home: QuestionUi(),
    );
  }
}

void main() {
  runApp(const QuizApp());
}
