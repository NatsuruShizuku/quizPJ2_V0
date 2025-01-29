

import 'dart:math';

import 'package:flutter_application_0/models/matraModel.dart';
import 'package:flutter_application_0/models/questionModel.dart';
import 'package:flutter_application_0/models/wordModel.dart';

import 'question1.dart';
import '../services/question_service.dart';

class QuizData {
  final QuestionService questionService;

  final int questionCount;
  final int gradeID;
  final int matraID;
  final int questionID;

  QuizData({
    required this.questionService,
    this.questionCount = 10,  // จำนวนคำถามเริ่มต้น
    this.gradeID = 1,
    this.matraID = 1,       // ระดับชั้นเริ่มต้น
    this.questionID = 2,    //กำหนดค่าโมเดลคำถาม
  });


// Future<List<Question1>> getQuestions() async {
//   List<Question1> questions = [];

//   try {
//     // ดึงจำนวนคำถามทั้งหมดในฐานข้อมูล
//     final List<Map<String, dynamic>> totalQuestions = await questionService.fetchAllQuestions();

//     if (questionCount > totalQuestions.length) {
//       throw Exception('จำนวนคำถามที่ร้องขอมากกว่าจำนวนคำถามในฐานข้อมูล (${totalQuestions.length})');
//     }

//     for (int i = 0; i < questionCount; i++) {
//       int modelNum = (i % 2) + 1;

//       try {
//         // สร้างคำถาม
//         Question1 question = await questionService.createDynamicQuestion(
//           modelNum: modelNum,
//           gradeID: gradeID,
//           matraID: matraID,
//         );

//         questions.add(question);
//       } catch (e) {
//         print('เกิดข้อผิดพลาดในการสร้างคำถามที่ ${i + 1}: $e');
//       }
//     }
//   } catch (e) {
//     print('เกิดข้อผิดพลาดในการดึงคำถาม: $e');
//   }

//   return questions;
// }
Future<List<Question1>> getQuestions() async {
  List<Question1> questions = [];

  try {
    for (int i = 0; i < questionCount; i++) {
      int modelNum = (i % 6) +1;

      try {
        // เรียกใช้ createDynamicQuestion เพื่อสร้างคำถามใหม่
        Question1 question = await questionService.createDynamicQuestion(
          modelNum: modelNum,
          gradeID: gradeID,
          matraID: matraID,
        );

        questions.add(question); // เพิ่มคำถามลงในลิสต์
      } catch (e) {
        print('เกิดข้อผิดพลาดในการสร้างคำถามที่ ${i + 1}: $e');
      }
    }
  } catch (e) {
    print('เกิดข้อผิดพลาดในการดึงคำถาม: $e');
  }

  return questions; // คืนค่าลิสต์คำถาม
}
}
