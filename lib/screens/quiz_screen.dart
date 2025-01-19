// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/models/category.dart';
// import 'package:flutter_application_0/screens/result_screen.dart';

// class QuizScreen extends StatefulWidget {
//   final Category category;

//   const QuizScreen({super.key, required this.category});

//   @override
//   State<QuizScreen> createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   int currentQuestionIndex = 0;
//   int score = 0;
//   int timeLeft = 60;
//   late Timer timer;
//   List<int?> userAnswers = List.filled(5, null);
//   bool showFeedback = false;
//   int? selectedAnswer;

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   void startTimer() {
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (timeLeft > 0) {
//         setState(() {
//           timeLeft--;
//         });
//       } else {
//         moveToNext();
//       }
//     });
//   }

//   void moveToNext() {
//     timer.cancel();
//     if (currentQuestionIndex < widget.category.questions.length - 1) {
//       setState(() {
//         currentQuestionIndex++;
//         timeLeft = 60;
//         showFeedback = false;
//         selectedAnswer = null;
//       });
//       startTimer();
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResultScreen(
//             category: widget.category,
//             score: score,
//             userAnswers: userAnswers,
//           ),
//         ),
//       );
//     }
//   }

//   void checkAnswer(int selectedIndex) {
//     timer.cancel();
//     final correctIndex =
//         widget.category.questions[currentQuestionIndex].correctAnswerIndex;

//     setState(() {
//       selectedAnswer = selectedIndex;
//       showFeedback = true;
//       if (selectedIndex == correctIndex) {
//         score++;
//       }
//       userAnswers[currentQuestionIndex] = selectedIndex;
//     });

//     // Wait 2 seconds before moving to next question
//     Future.delayed(const Duration(seconds: 5), () {
//       if (mounted) {
//         moveToNext();
//       }
//     });
//   }

//   Color getOptionColor(int index) {
//     if (!showFeedback) return Colors.white;

//     final correctIndex =
//         widget.category.questions[currentQuestionIndex].correctAnswerIndex;

//     if (index == correctIndex) {
//       return Colors.green.shade100;
//     } else if (index == selectedAnswer) {
//       return Colors.red.shade100;
//     }
//     return Colors.white;
//   }

//   Color getOptionBorderColor(int index) {
//     if (!showFeedback) return Colors.grey.shade300;

//     final correctIndex =
//         widget.category.questions[currentQuestionIndex].correctAnswerIndex;

//     if (index == correctIndex) {
//       return Colors.green;
//     } else if (index == selectedAnswer) {
//       return Colors.red;
//     }
//     return Colors.grey.shade300;
//   }

//   Widget getFeedbackIcon(int index) {
//     if (!showFeedback) return const SizedBox.shrink();

//     final correctIndex =
//         widget.category.questions[currentQuestionIndex].correctAnswerIndex;

//     if (index == correctIndex) {
//       return const Icon(Icons.check_circle, color: Colors.green);
//     } else if (index == selectedAnswer && index != correctIndex) {
//       return const Icon(Icons.cancel, color: Colors.red);
//     }
//     return const SizedBox.shrink();
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final question = widget.category.questions[currentQuestionIndex];

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.blue.shade100, Colors.white],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.white60),
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Icon(
//                           Icons.close,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     // Text(
//                     //   widget.category.name,
//                     //   style: const TextStyle(
//                     //     fontSize: 24,
//                     //     fontWeight: FontWeight.bold,
//                     //   ),
//                     // ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade100,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.timer, size: 20),
//                           const SizedBox(width: 4),
//                           Text(
//                             '$timeLeft วินาที',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black),
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Icon(
//                           Icons.pause,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     // const SizedBox(width: 8),
//                   ],
//                 ),
//               ),
//               if (showFeedback)
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   margin: const EdgeInsets.symmetric(horizontal: 24),
//                   decoration: BoxDecoration(
//                     color: selectedAnswer == question.correctAnswerIndex
//                         ? Colors.green.shade100
//                         : Colors.red.shade100,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         selectedAnswer == question.correctAnswerIndex
//                             ? Icons.check_circle
//                             : Icons.cancel,
//                         color: selectedAnswer == question.correctAnswerIndex
//                             ? Colors.green
//                             : Colors.red,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         selectedAnswer == question.correctAnswerIndex
//                             ? 'ถูกต้อง!'
//                             : 'ไม่ถูกต้อง! คำตอบที่ถูกคือ ${question.options[question.correctAnswerIndex]}',
//                         style: TextStyle(
//                           color: selectedAnswer == question.correctAnswerIndex
//                               ? Colors.green
//                               : Colors.red,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           'คำถามที่ ${currentQuestionIndex + 1}/${widget.category.questions.length}',
//                           style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: LinearProgressIndicator(
//                         value: timeLeft / 60,
//                         backgroundColor: Colors.grey[300],
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           timeLeft > 30 ? Colors.blue : Colors.red,
//                         ),
//                         minHeight: 8,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(24),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.1),
//                               spreadRadius: 5,
//                               blurRadius: 10,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Text(
//                           question.questionText,
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w500,
//                             height: 1.5,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       const SizedBox(height: 32),
//                       ...List.generate(
//                         question.options.length,
//                         (index) => Padding(
//                           padding: const EdgeInsets.only(bottom: 16),
//                           child: ElevatedButton(
//                             onPressed:
//                                 showFeedback ? null : () => checkAnswer(index),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: getOptionColor(index),
//                               foregroundColor: Colors.black87,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 24,
//                                 vertical: 16,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 side: BorderSide(
//                                   color: getOptionBorderColor(index),
//                                   width: 2,
//                                 ),
//                               ),
//                               elevation: 2,
//                             ),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: 35,
//                                   height: 35,
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue.shade50,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       String.fromCharCode(65 + index),
//                                       style: TextStyle(
//                                         color: Colors.blue.shade700,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: Text(
//                                     question.options[index],
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                                 getFeedbackIcon(index),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
