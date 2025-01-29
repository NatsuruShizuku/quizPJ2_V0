// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/services/question_service.dart';
// import 'package:flutter_application_0/models/quiz_data.dart';
// import 'package:flutter_application_0/screens/quiz_screen.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// void main() async {
//   try {
//     WidgetsFlutterBinding.ensureInitialized();

//     String path = join(await getDatabasesPath(), 'word5.db');

//     final database = await openDatabase(
//       path,
//       version: 5
//     );

//     // Initialize QuestionService
//     final questionService = QuestionService(database);

//     // ตรวจสอบการเชื่อมต่อฐานข้อมูล
//     await questionService.checkDatabaseConnection();

//     // ส่งข้อมูลไปยัง QuizData
//     final quizData = QuizData(
//       questionService: questionService,
//       questionCount: 10,
//       gradeID: 1,
//     );

//     // รันแอป
//     runApp(MaterialApp(
//       home: QuizScreen(quizData: quizData),
//       debugShowCheckedModeBanner: false,
//     ));


//   } catch (e, stackTrace) {
//     print('Error during initialization: $e');
//     print('Stack trace: $stackTrace');
//     runApp(MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('เกิดข้อผิดพลาดในการเริ่มต้นแอป: $e'),
//         ),
//       ),
//     ));
//   }
// }
// old version

import 'package:flutter/material.dart';
import 'package:flutter_application_0/data/quiz_data.dart';
import 'package:flutter_application_0/database/db_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'services/question_service.dart';
import 'models/quiz_data.dart';
import 'screens/quiz_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // เชื่อมต่อฐานข้อมูล
    final dbHelper = DatabaseHelper.instance;
    final Database database = await dbHelper.database;

    await dbHelper.checkDatabaseConnection();
    
    // สร้าง QuestionService
    final QuestionService questionService = QuestionService(database);

    // สร้าง QuizData
    final QuizData quizData = QuizData(
      questionService: questionService,
      questionCount: 10, // จำนวนคำถาม
      gradeID: 2,       // ระดับชั้น
    );

    runApp(MyApp(quizData: quizData));
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('เกิดข้อผิดพลาดในการเริ่มต้น: $e'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  final QuizData quizData;

  const MyApp({Key? key, required this.quizData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: QuizScreen(quizData: quizData), // ส่ง QuizData ให้ QuizScreen
      debugShowCheckedModeBanner: false,
    );
  }
}
