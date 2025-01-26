import 'package:flutter/material.dart';
import 'package:flutter_application_0/services/question_check.dart';
import 'package:flutter_application_0/services/question_service.dart';
import 'package:sqflite/sqflite.dart';

class WordCheckIntegration {
  final QuestionService questionService;
  final _wordCheckScreen = WordCheckScreen();

  WordCheckIntegration(Database database) 
    : questionService = QuestionService(database);

  Future<String> processRandomWord({int? gradeID, int? matraID}) async {
    try {
      // สุ่มคำศัพท์จาก QuestionService
      final randomWord = await questionService.getRandomWord(gradeID: gradeID);

      // ใช้เมธอดจาก WordCheckScreen เพื่อตรวจสอบมาตราตัวสะกด
      final lastConsonant = _wordCheckScreen.processThaiWordEnding(randomWord.vocab);
      final category = _wordCheckScreen.identifyThaiCategory(lastConsonant);

      return category;
    } catch (e) {
      return 'เกิดข้อผิดพลาด: $e';
    }
  }
}