// // // import 'package:flutter_application_0/models/question1.dart';
// // // import 'package:sqflite/sqflite.dart';
// // // import '../services/question_service.dart';


// // // class QuizData {
// // //   final QuestionService questionService;
// // //   final List<Question1> initialQuestions;

// // //   QuizData(this.questionService, this.initialQuestions);

// // //   Future<List<Question1>> getQuestions() async {
// // //     return Future.value(initialQuestions);
// // //   }
// // // }

// // import 'package:flutter_application_0/models/question1.dart';
// // import '../services/question_service.dart';

// // class QuizData {
// //   final QuestionService questionService;
// //   final int questionCount;
// //   final int gradeID;

// //   QuizData({
// //     required this.questionService,
// //     required this.questionCount,
// //     required this.gradeID,
// //   });

// //   Future<List<Question1>> getQuestions() async {
// //     List<Question1> questions = [];
    
// //     try {
// //       for (int i = 0; i < questionCount; i++) {
// //         // สุ่มเลือกโมเดลคำถามระหว่าง 1-3
// //         int modelNum = (i % 3) + 1;
        
// //         Question1 question = await questionService.createDynamicQuestion(
// //           modelNum: modelNum,
// //           gradeID: gradeID,
// //         );
        
// //         questions.add(question);
// //       }
// //     } catch (e) {
// //       print('เกิดข้อผิดพลาดในการสร้างคำถามที่ ${questions.length + 1}: $e');
// //       // ถ้าเกิดข้อผิดพลาด ให้สร้างคำถามง่ายๆ แทน
// //       questions.add(Question1(
// //         modelnum: 1,
// //         setQuestion: "เกิดข้อผิดพลาดในการโหลดคำถาม",
// //         wordQuestion: "",
// //         options: [
// //           Options(optionTEXT: "ลองใหม่อีกครั้ง", isCorrect: true),
// //         ],
// //         endingSound: "",
// //       ));
// //     }
    
// //     return questions;
// //   }
// // }
// //old version;


// import '../models/question1.dart';
// import '../services/question_service.dart';

// class QuizData {
//   final QuestionService questionService;
//   final int questionCount;
//   final int gradeID;

//   QuizData({
//     required this.questionService,
//     this.questionCount = 5,
//     this.gradeID = 1,
//   });

//   Future<List<Question1>> getQuestions() async {
//     List<Question1> questions = [];

//     for (int i = 0; i < questionCount; i++) {
//       try {
//         int modelNum = (i % 2) + 1;
//         Question1 question = await questionService.createDynamicQuestion(
//           modelNum: modelNum,
//           gradeID: gradeID,
//           matraID: 1,
//         );
//         questions.add(question);
//       } catch (e) {
//         print('Error creating question ${i + 1}: $e');
//       }
//     }

//     return questions;
//   }
// }
