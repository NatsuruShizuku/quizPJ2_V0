// // import 'package:flutter/material.dart';
// // import 'package:flutter_application_0/services/question_service.dart';
// // import 'package:flutter_application_0/models/quiz_data.dart';
// // import 'package:flutter_application_0/screens/quiz_screen.dart';
// // import 'package:sqflite/sqflite.dart';
// // import 'package:path/path.dart';

// // void main() async {
// //   try {
// //     WidgetsFlutterBinding.ensureInitialized();

// //     String path = join(await getDatabasesPath(), 'word5.db');

// //     final database = await openDatabase(
// //       path,
// //       version: 5
// //     );

// //     // Initialize QuestionService
// //     final questionService = QuestionService(database);

// //     // ตรวจสอบการเชื่อมต่อฐานข้อมูล
// //     await questionService.checkDatabaseConnection();

// //     // ส่งข้อมูลไปยัง QuizData
// //     final quizData = QuizData(
// //       questionService: questionService,
// //       questionCount: 10,
// //       gradeID: 1,
// //     );

// //     // รันแอป
// //     runApp(MaterialApp(
// //       home: QuizScreen(quizData: quizData),
// //       debugShowCheckedModeBanner: false,
// //     ));

// //   } catch (e, stackTrace) {
// //     print('Error during initialization: $e');
// //     print('Stack trace: $stackTrace');
// //     runApp(MaterialApp(
// //       home: Scaffold(
// //         body: Center(
// //           child: Text('เกิดข้อผิดพลาดในการเริ่มต้นแอป: $e'),
// //         ),
// //       ),
// //     ));
// //   }
// // }
// // old version

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/data/quiz_data.dart';
// import 'package:flutter_application_0/database/db_helper.dart';
// import 'package:flutter_application_0/models/matraModel.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'services/question_service.dart';
// import 'models/quiz_data.dart';
// import 'screens/quiz_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//  try {
//     // เชื่อมต่อฐานข้อมูล
//     final dbHelper = DatabaseHelper.instance;
//     final Database database = await dbHelper.database;

//     await dbHelper.checkDatabaseConnection();

//     // สร้าง QuestionService
//     final QuestionService questionService = QuestionService(database);

//     // สร้าง QuizData
//     final QuizData quizData = QuizData(
//       questionService: questionService,
//       questionCount: 10, // จำนวนคำถาม
//       // gradeID: 2,       // ระดับชั้น
//       matraID: Random().nextInt(9),
//       questionID: 1,
//     );
//     runApp(MyApp(quizData: quizData));

//   } catch (e) {
//     runApp(MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('เกิดข้อผิดพลาดในการเริ่มต้น: $e'),
//         ),
//       ),
//     ));
//   }
// }

// class MyApp extends StatelessWidget {
//   final QuizData quizData;

//   const MyApp({Key? key, required this.quizData}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Quiz App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: QuizScreen(quizData: quizData), // ส่ง QuizData ให้ QuizScreen
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

//V2
import 'package:flutter/material.dart';
import 'package:flutter_application_0/screens/quiz_game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary Game',
      home: QuizGame(mode: 'Easy',),
      debugShowCheckedModeBanner: false,
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Popup Test',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool showPopup = true; // ค่าตั้งต้นให้แสดง Popup

//   @override
//   void initState() {
//     super.initState();
//     _checkPopupPreference();
//   }

//   // ตรวจสอบว่าผู้ใช้ต้องการให้แสดง Popup หรือไม่
//   Future<void> _checkPopupPreference() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool shouldShowPopup = prefs.getBool('show_popup') ?? true;

//     if (shouldShowPopup) {
//       Future.delayed(Duration(milliseconds: 500), () {
//         showGameSettingsPopup(context);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Popup Test')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => showGameSettingsPopup(context),
//           child: Text('Show Popup'),
//         ),
//       ),
//     );
//   }
// }

// void showGameSettingsPopup(BuildContext context) {
//   bool showPopupNextTime = true;

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.white,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // แถบด้านบน
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Colors.red.withOpacity(0.3),
//                     ),
//                     child: Row(
//                       children: [
//                         SizedBox(width: 10),
//                         _buildCircle(Colors.pinkAccent),
//                         _buildCircle(Colors.yellowAccent),
//                         _buildCircle(Colors.green),
//                         Spacer(),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.red.withOpacity(0.9),
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 2),
//                           ),
//                           child: IconButton(
//                             icon: Icon(Icons.close,
//                                 color: Colors.white, size: 35),
//                             onPressed: () {
//                               _savePopupPreference(showPopupNextTime);
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),

//                   // ชื่อระดับ
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.yellow.shade600,
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: Text(
//                       'ระดับง่าย',
//                       style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                   ),
//                   SizedBox(height: 15),

//                   // รายการการตั้งค่า
//                   _buildSettingItem('กำหนดเวลา', '3 นาที'),
//                   _buildSettingItem('ตอบถูกข้อละ', '10 คะแนน'),
//                   _buildSettingItem('ตอบผิดติดกันได้', '3 ครั้ง'),

//                   SizedBox(height: 10),

//                   // Checkbox สำหรับการตั้งค่า
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Checkbox(
//                         value: showPopupNextTime,
//                         onChanged: (value) {
//                           setState(() {
//                             showPopupNextTime = value!;
//                           });
//                         },
//                       ),
//                       Text(
//                         'แสดง Popup ทุกครั้งที่เข้าหน้า Home',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }

// // ฟังก์ชันบันทึกค่าความต้องการของผู้ใช้
// Future<void> _savePopupPreference(bool value) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('show_popup', value);
// }

// // ฟังก์ชันสร้างกล่องแสดงข้อมูล
// Widget _buildSettingItem(String title, String value) {
//   return Container(
//     margin: EdgeInsets.symmetric(vertical: 8),
//     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//     constraints: BoxConstraints(
//       minHeight: 60,
//       maxHeight: 100,
//       minWidth: double.infinity,
//     ),
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Colors.blue.shade200, Colors.purple.shade200],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       borderRadius: BorderRadius.circular(35),
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(title, style: TextStyle(fontSize: 20, color: Colors.black)),
//         SizedBox(height: 5),
//         Text(value,
//             style: TextStyle(
//                 fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
//       ],
//     ),
//   );
// }

// // ฟังก์ชันสร้างวงกลมสีด้านบน
// Widget _buildCircle(Color color) {
//   return Container(
//     width: 40,
//     height: 25,
//     margin: EdgeInsets.symmetric(horizontal: 5),
//     decoration: BoxDecoration(
//       color: color.withOpacity(0.7),
//       shape: BoxShape.circle,
//     ),
//   );
// }
