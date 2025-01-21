
// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:flutter_application_0/screens/category_screen.dart';
// import 'package:flutter_application_0/screens/home_page.dart';
// import 'package:flutter_application_0/screens/question_ui.dart';  // Add this import for Timer

// class QuizApp extends StatelessWidget {
//   const QuizApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Quiz App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//         fontFamily: 'Roboto',
//       ),
//       home: const HomePage(),
//       // home: QuestionUi(),
//     );
//   }
// }

// void main() {
//   runApp(const QuizApp());
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_0/models/question1.dart';
import 'package:flutter_application_0/services/question_service.dart';
import 'package:flutter_application_0/models/quiz_data.dart';
import 'package:flutter_application_0/screens/quiz_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // เตรียมฐานข้อมูล
//   final database = openDatabase(
//     join(await getDatabasesPath(), 'word1.db'),
//     onCreate: (db, version) async {
//       // สร้างตารางเก็บคำศัพท์
//       await db.execute(
//         'CREATE TABLE Vocabulary(vocabID INTEGER PRIMARY KEY, syllable INTEGER, vocab TEXT, gradeID INTEGER)',
//       );
      
//       // เพิ่มข้อมูลตัวอย่าง
//       await db.insert('Vocabulary', {
//         'vocabID': 1,
//         'syllable': 2,
//         'vocab': 'สีขาว',
//         'gradeID': 1,
//       });
//       // เพิ่มข้อมูลอื่นๆ ตามต้องการ
//     },
//     version: 1,
//   );

//   final QuestionService questionService = QuestionService(await database);
//   final QuizData quizData = QuizData(questionService);

//   runApp(QuizApp(quizData: quizData));
// }

// class QuizApp extends StatelessWidget {
//   final QuizData quizData;

//   const QuizApp({super.key, required this.quizData});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Quiz App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: QuizScreen(quizData: quizData),
//     );
//   }
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // เตรียมฐานข้อมูล
  final database = await openDatabase(
    join(await getDatabasesPath(), 'word1.db'),
    onCreate: (db, version) async {
      // สร้างตารางเก็บคำศัพท์
      await db.execute(
        'CREATE TABLE Vocabulary(vocabID INTEGER PRIMARY KEY, syllable INTEGER, vocab TEXT, gradeID INTEGER ,  endingSound TEXT)',
      );
      
      // เพิ่มข้อมูลตัวอย่างหลายๆ คำ
       final Batch batch = db.batch();
      batch.insert('Vocabulary', {
        'vocabID': 1,
        'syllable': 2,
        'vocab': 'สีขาว',
        'gradeID': 1,
        'endingSound': 'แม่เกอว'
      });
      batch.insert('Vocabulary', {
        'vocabID': 2,
        'syllable': 2,
        'vocab': 'ร้อนแรง',
        'gradeID': 1,
        'endingSound': 'แม่กง'
      });
      batch.insert('Vocabulary', {
        'vocabID': 3,
        'syllable': 2,
        'vocab': 'เล่นเกม',
        'gradeID': 1,
        'endingSound': 'แม่กม'
      });
      batch.insert('Vocabulary', {
        'vocabID': 4,
        'syllable': 2,
        'vocab': 'คำถาม',
        'gradeID': 1,
        'endingSound': 'แม่กม'
      });
      await batch.commit();
    },
    version: 1,
  );

//   // สร้างข้อมูลคำถามแบบ hardcode ก่อน
//   final List<Question1> initialQuestions = [
//     Question1(
//       model_num: 1,
//       setQuestion: "{wordQuestion}เป็นคำที่มีตัวสะกดมาตราใด?",
//       wordQuestion: "บุญคุณ",
//       options: [
//         Options(optionTEXT: "แม่กม", isCorrect: false),
//         Options(optionTEXT: "แม่กน", isCorrect: true),
//         Options(optionTEXT: "แม่เกย", isCorrect: false),
//         Options(optionTEXT: "แม่กบ", isCorrect: false),
//       ],
//     ),
//     Question1(
//       model_num: 2,
//       setQuestion: "ข้อใดมีมาตราตัวสะกดคำท้ายตรงกับคำว่า {wordQuestion}?",
//       wordQuestion: "กางเกง",
//       options: [
//         Options(optionTEXT: "สีขาว", isCorrect: false),
//         Options(optionTEXT: "ร้อนแรง", isCorrect: true),
//         Options(optionTEXT: "เล่นเกม", isCorrect: false),
//         Options(optionTEXT: "คำถาม", isCorrect: false),
//       ],
//     ),
//   ];

//    final questionService = QuestionService(database);
//   final quizData = QuizData(questionService, initialQuestions);

//   runApp(MaterialApp(
//     home: QuizScreen(quizData: quizData),
//   ));
// }

  final questionService = QuestionService(database);
  final quizData = QuizData(
    questionService: questionService,
    questionCount: 5,  // กำหนดจำนวนคำถาม
    gradeID: 1,       // กำหนดระดับชั้น
  );

  runApp(MaterialApp(
    home: QuizScreen(quizData: quizData),
  ));
}