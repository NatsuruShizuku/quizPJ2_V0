

import 'package:sqflite/sqflite.dart';
import 'question1.dart';
import '../services/question_service.dart';

class QuizData {
  final QuestionService questionService;
  // final List<Question1> initialQuestions;

  // QuizData(this.questionService, this.initialQuestions);

  // Future<List<Question1>> getQuestions() async {
  //   return Future.value(initialQuestions);
  // }

final int questionCount;
  final int gradeID;

  QuizData({
    required this.questionService,
    this.questionCount = 5,  // จำนวนคำถามเริ่มต้น
    this.gradeID = 1,       // ระดับชั้นเริ่มต้น
  });

 Future<List<Question1>> getQuestions() async {
    List<Question1> questions = [];
    
    // สร้างคำถามแบบ Dynamic ตามจำนวนที่กำหนด
    for (int i = 0; i < questionCount; i++) {
      // สลับระหว่างโมเดลคำถามที่ 1 และ 2
      int modelNum = (i % 2) + 1;
      
      try {
        Question1 question = await questionService.createDynamicQuestion(
          modelNum: modelNum,
          gradeID: gradeID,
        );
        questions.add(question);
      } catch (e) {
        print('เกิดข้อผิดพลาดในการสร้างคำถามที่ ${i + 1}: $e');
      }
    }
    
    return questions;
  }
}
