import 'package:flutter_application_0/models/question1.dart';
import 'package:sqflite/sqflite.dart';
import '../services/question_service.dart';


class QuizData {
  final QuestionService questionService;
  final List<Question1> initialQuestions;

  QuizData(this.questionService, this.initialQuestions);

  Future<List<Question1>> getQuestions() async {
    return Future.value(initialQuestions);
  }
}