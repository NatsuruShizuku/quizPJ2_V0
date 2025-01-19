// import 'package:flutter/material.dart';

// class QuestionUi extends StatefulWidget {
//   const QuestionUi({super.key});

//   @override
//   State<QuestionUi> createState() => _QuestionUiState();
// }

// class _QuestionUiState extends State<QuestionUi> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(color: Color(0xFF538eec)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.white60),
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Icon(
//                       Icons.close,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white, width: 2.0),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Text(
//                     "01",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22.0,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white),
//                       borderRadius: BorderRadius.circular(30)),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.pause,
//                         color: Colors.white,
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               "question 5 of 10",
//               style: TextStyle(
//                 color: Color.fromARGB(244, 255, 255, 255),
//                 fontSize: 22,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Text(
//               "ข้อใดมีตัวสะกด แม่กม",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 30.0,),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 10.0,),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
//               child: Center(
//                 child: Text(
//                   "สมัน",
//                   style: TextStyle(
//                     color: Color(0xff5177ee),
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20.0,),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 10.0,),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
//               child: Center(
//                 child: Text(
//                   "สนาม",
//                   style: TextStyle(
//                     color: Color(0xff5177ee),
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 30.0,),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 10.0,),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
//               child: Center(
//                 child: Text(
//                   "หลอน",
//                   style: TextStyle(
//                     color: Color(0xff5177ee),
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 30.0,),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 10.0,),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
//               child: Center(
//                 child: Text(
//                   "สอน",
//                   style: TextStyle(
//                     color: Color(0xff5177ee),
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
