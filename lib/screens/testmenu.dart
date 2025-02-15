// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/screens/quiz_game.dart';

// class DifficultyMenu extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('เลือกโหมดการเล่น')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // ปุ่มโหมดง่าย
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => QuizGame(
//                       mode: 'Easy',
//                       initialTime: 310,     // กำหนดเวลา 310 วินาที
//                       scorePerCorrect: 10,  // ตอบถูกได้ 10 คะแนน
//                       modeText: 'ระดับง่าย',
//                       timeperminite: (310 / 60).toInt(),
//                     ),
//                   ),
//                 );
//               },
//               child: Text('ง่าย'),
//             ),
//             SizedBox(height: 20),
//             // ปุ่มโหมดปานกลาง
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => QuizGame(
//                       mode: 'Medium',
//                       initialTime: 250,    // กำหนดเวลา 250 วินาที
//                       scorePerCorrect: 15, // ตอบถูกได้ 15 คะแนน
//                       modeText: 'ระดับปานกลาง',
//                       timeperminite: (250/60).toInt(),
//                     ),
//                   ),
//                 );
//               },
//               child: Text('ปานกลาง'),
//             ),
//             SizedBox(height: 20),
//             // ปุ่มโหมดยาก
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => QuizGame(
//                       mode: 'Hard',
//                       initialTime: 210,    // กำหนดเวลา 210 วินาที
//                       scorePerCorrect: 20, // ตอบถูกได้ 20 คะแนน
//                       modeText: 'ระดับยาก',
//                       timeperminite: (210/60).toInt(),
//                     ),
//                   ),
//                 );
//               },
//               child: Text('ยาก'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
