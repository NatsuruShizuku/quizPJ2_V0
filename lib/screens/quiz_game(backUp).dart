// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/database/database_helper.dart';
// import 'package:flutter_application_0/models/dataModel.dart';

// class QuizGame extends StatefulWidget {
//   @override
//   _QuizGameState createState() => _QuizGameState();
// }
// enum AnswerType { matraText, vocab }

// class _QuizGameState extends State<QuizGame> {
//   List<QuestionM> questions = [];
//   List<Vocabulary> vocabularies = [];
//   List<Matra> matras = [];
//   int score = 0;
//   int consecutiveWrong = 0;
//   int remainingTime = 180;
//   Timer? timer;
//   QuizQuestion? currentQuestion;
// // adding
// bool showFeedback = false;
//   String? selectedAnswer;
//   bool isCorrect = false;
//   Timer? feedbackTimer;
//   bool isProcessingAnswer = false;

//   @override
//   void initState() {
//     super.initState();
//     initializeGame();
//   }

//   Future<void> initializeGame() async {
//     final questions = await DatabaseHelper.getQuestions();
//     final vocabularies = await DatabaseHelper.getVocabularies();
//     final matras = await DatabaseHelper.getMatras();

//     setState(() {
//       this.questions = questions;
//       this.vocabularies = vocabularies;
//       this.matras = matras;
//     });

//     startGame();
//   }

// //new Stratgame
// void startGame() {
//   // รีเซ็ตค่าทั้งหมด
//   timer?.cancel();
//   feedbackTimer?.cancel();
  
//   setState(() {
//     score = 0;
//     consecutiveWrong = 0;
//     remainingTime = 180;
//     showFeedback = false;
//     selectedAnswer = null;
//     isCorrect = false;
//     isProcessingAnswer = false;
//   });

//   generateNewQuestion();
//   startTimer();
// }

//   // void startTimer() {
//   //   timer = Timer.periodic(Duration(seconds: 1), (timer) {
//   //     if (remainingTime > 0) {
//   //       setState(() => remainingTime--);
//   //     } else {
//   //       endGame();
//   //     }
//   //   });
//   // }
//   void startTimer() {
//   timer = Timer.periodic(Duration(seconds: 1), (timer) {
//     if (remainingTime > 0) {
//       setState(() => remainingTime--);
//     } else {
//       timer.cancel();
//       endGame();
//     }
//   });
// }

// //   //ส่วนสร้างคำถาม
// //   void generateNewQuestion() {
// //   final random = Random();
  
// //   // สุ่มคำถาม
// //   final question = questions[random.nextInt(questions.length)];
  
// //   // สุ่มคำศัพท์หลัก
// //   final vocabulary = vocabularies[random.nextInt(vocabularies.length)];
  
// //   // สุ่มคำศัพท์เพิ่มเติมสำหรับรูปแบบที่ 2
// //   Vocabulary randomWord;
// //   do {
// //     randomWord = vocabularies[random.nextInt(vocabularies.length)];
// //   } while (randomWord.vocabID == vocabulary.vocabID);

// //   // เตรียมข้อมูลสำหรับสร้างคำถาม
// //   final questionData = {
// //     'vocab': vocabulary.vocab,
// //     'randomWord': randomWord.vocab,
// //     'matraText': vocabulary.matraText,
// //   };

// //   // สร้างข้อความคำถาม
// //   final questionText = question.generateQuestionText(questionData);

// //   // เตรียมตัวเลือก
// //   final wrongMatras = matras
// //       .where((m) => m.matraText != vocabulary.matraText)
// //       .map((m) => m.matraText)
// //       .toList()
// //     ..shuffle();
  
// //   final options = [
// //     vocabulary.matraText,
// //     ...wrongMatras.take(3)
// //   ]..shuffle();

// //   setState(() {
// //     currentQuestion = QuizQuestion(
// //       text: questionText,
// //       correctAnswer: vocabulary.matraText,
// //       options: options,
// //     );
// //   });
// // }

// void generateNewQuestion() {
//   final random = Random();
//   final question = questions[random.nextInt(questions.length)];
//   final vocabulary = vocabularies[random.nextInt(vocabularies.length)];
//   Vocabulary randomWord = _getRandomWord(vocabulary.vocabID);

//   final questionText = question.generateQuestionText(vocabulary, randomWord);
//   final correctAnswer = _getCorrectAnswer(question, vocabulary);
//   final options = _generateOptions(question, vocabulary, correctAnswer);

//   setState(() {
//     currentQuestion = QuizQuestion(
//       text: questionText,
//       correctAnswer: correctAnswer,
//       options: options,
//     );
//   });
// }

// // String _getCorrectAnswer(QuestionM question, Vocabulary vocabulary) {
// //   return question.answerType == AnswerType.matraText 
// //       ? vocabulary.matraText 
// //       : vocabulary.vocab;
// // }
// String _getCorrectAnswer(QuestionM question, Vocabulary vocabulary) {
//   switch (question.answerType) {
//     case AnswerType.matraText:
//       return vocabulary.matraText;
//     case AnswerType.vocab:
//       return vocabulary.vocab;
//     // เพิ่มประเภทคำตอบอื่นๆ ตามต้องการ
//   }
// }

// List<String> _generateOptions(QuestionM question, Vocabulary vocabulary, String correctAnswer) {
//   final usedIds = {vocabulary.vocabID};
//   final options = <String>[correctAnswer];
//   final answerType = question.answerType;

//   while (options.length < 4) {
//     final randomWord = vocabularies[Random().nextInt(vocabularies.length)];
//     if (!usedIds.contains(randomWord.vocabID)) {
//       usedIds.add(randomWord.vocabID);
//       final value = answerType == AnswerType.matraText 
//           ? randomWord.matraText 
//           : randomWord.vocab;
//       if (!options.contains(value)) {
//         options.add(value);
//       }
//     }
//   }

//   return options..shuffle();
// }

// Vocabulary _getRandomWord(int excludeId) {
//   final random = Random();
//   Vocabulary randomWord;
//   do {
//     randomWord = vocabularies[random.nextInt(vocabularies.length)];
//   } while (randomWord.vocabID == excludeId);
//   return randomWord;
// }

// AnswerType get answerType {
//   switch (questionID) { // ใช้ questionID ของคำถามปัจจุบัน
//     case 1:  // ถ้า QuestionID เป็น 1
//     case 3:  // หรือ 3
//     case 4:  // หรือ 4
//       return AnswerType.matraText; // ใช้มาตราตัวสะกดเป็นคำตอบ
//     default: // กรณีอื่นๆ ทั้งหมด
//       return AnswerType.vocab; // ใช้คำศัพท์เป็นคำตอบ
//   }
// }


// //new handleAnswer
// void handleAnswer(String selectedOption) {
//   if (isProcessingAnswer || currentQuestion == null) return;
  
//   setState(() {
//     isProcessingAnswer = true;
//     selectedAnswer = selectedOption;
//     isCorrect = selectedOption == currentQuestion!.correctAnswer;
//     showFeedback = true;
//   });

//   // อัพเดทคะแนนและจำนวนผิดต่อเนื่อง
//   if (isCorrect) {
//     score++;
//     consecutiveWrong = 0;
//   } else {
//     consecutiveWrong++;
//   }

//   feedbackTimer = Timer(Duration(seconds: 2), () {
//     setState(() {
//       showFeedback = false;
//       selectedAnswer = null;
//       isProcessingAnswer = false;
//     });

//     if (remainingTime <= 0 || consecutiveWrong >= 3) {
//       endGame();
//     } else {
//       generateNewQuestion();
//     }
//   });
// }

//   void endGame() {
//     timer?.cancel();
//     feedbackTimer?.cancel();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Game Over'),
//         content: Text('Your Score: $score'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('OK'),
//           )
//         ],
//       ),
//     );
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       title: Text('ภาษาไทย Quiz'),
//   //       actions: [
//   //         IconButton(
//   //           icon: Icon(Icons.refresh),
//   //           onPressed: initializeGame,
//   //         )
//   //       ],
//   //     ),
//   //     body: currentQuestion == null
//   //         ? Center(child: CircularProgressIndicator())
//   //         : Column(
//   //             children: [
//   //               LinearProgressIndicator(
//   //                 value: remainingTime / 180,
//   //               ),
//   //               Padding(
//   //                 padding: EdgeInsets.all(16),
//   //                 child: Column(
//   //                   children: [
//   //                     Text(
//   //                       'คะแนน: $score',
//   //                       style: TextStyle(fontSize: 24),
//   //                     ),
//   //                     Text(
//   //                       'เวลาเหลือ: ${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}',
//   //                       style: TextStyle(fontSize: 20),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ),
//   //               // Expanded(
//   //               //   child: Center(
//   //               //     child: Column(
//   //               //       mainAxisAlignment: MainAxisAlignment.center,
//   //               //       children: [
//   //               //         Text(
//   //               //           currentQuestion!.text,
//   //               //           style: TextStyle(fontSize: 24),
//   //               //           textAlign: TextAlign.center,
//   //               //         ),
//   //               //         SizedBox(height: 20),
//   //               //         ...currentQuestion!.options.map((option) => Padding(
//   //               //           padding: EdgeInsets.symmetric(vertical: 8),
//   //               //           child: ElevatedButton(
//   //               //             style: ElevatedButton.styleFrom(
//   //               //               minimumSize: Size(200, 50),
//   //               //             ),
//   //               //             onPressed: () => handleAnswer(option),
//   //               //             child: Text(option),
//   //               //           ),
//   //               //         )),
//   //               //       ],
//   //               //     ),
//   //               //   ),
//   //               // ),
                
//   //             ],
//   //           ),
//   //   );
//   // }
// //adding
// Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('เกมทายมาตราตัวสะกด', 
//                 style: TextStyle(
//                   fontFamily: 'Kanit',
//                   fontSize: 24,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 )),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blue[800]!, Colors.blue[400]!],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh, color: Colors.white),
//             onPressed: startGame,
//             tooltip: 'เริ่มเกมใหม่',
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Colors.blue[50]!],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           children: [
//             _buildGameHeader(),
//             _buildQuestionCard(),
//             _buildOptionsGrid(),
//             if (showFeedback) _buildFeedbackBanner(),
//           ],
//         ),
//       ),
//     );
//   }

//     Widget _buildGameHeader() {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildInfoCard(Icons.timer, 'เวลาเหลือ', 
//               '${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}',
//               Colors.blue),
//           _buildInfoCard(Icons.star, 'คะแนน', '$score', Colors.orange),
//           _buildInfoCard(Icons.close, 'ผิดติดกัน', '${consecutiveWrong}/3', Colors.red),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCard(IconData icon, String title, String value, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 28),
//           SizedBox(height: 4),
//           Text(title, style: TextStyle(fontFamily: 'Kanit', color: Colors.grey[600])),
//           Text(value, style: TextStyle(fontFamily: 'Kanit', fontSize: 18, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestionCard() {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//         gradient: LinearGradient(
//           colors: [Colors.blue[50]!, Colors.white],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Text(
//         currentQuestion?.text ?? 'กำลังโหลด...',
//         style: TextStyle(
//           fontFamily: 'Kanit',
//           fontSize: 22,
//           color: Colors.blue[900],
//           height: 1.4,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   Widget _buildOptionsGrid() {
//     return Expanded(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         child: GridView.count(
//           crossAxisCount: 2,
//           childAspectRatio: 1.5,
//           mainAxisSpacing: 12,
//           crossAxisSpacing: 12,
//           padding: EdgeInsets.only(bottom: 20),
//           children: currentQuestion?.options.map((option) => _buildOptionButton(option)).toList() ?? [],
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionButton(String option) {
//     final bool isSelected = selectedAnswer == option;
//     final bool isCorrectAnswer = option == currentQuestion?.correctAnswer;

//     Color buttonColor = Colors.white;
//     if (showFeedback) {
//       if (isCorrectAnswer) {
//         buttonColor = Colors.green[100]!;
//       } else if (isSelected) {
//         buttonColor = Colors.red[100]!;
//       }
//     }

//     return AnimatedContainer(
//       duration: Duration(milliseconds: 200),
//       decoration: BoxDecoration(
//         color: buttonColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: showFeedback && isCorrectAnswer 
//               ? Colors.green 
//               : Colors.grey[300]!,
//           width: 2,
//         ),
//         boxShadow: [
//           if (!isProcessingAnswer && !showFeedback)
//             BoxShadow(
//               color: Colors.blue[100]!,
//               blurRadius: 8,
//               offset: Offset(0, 2),
//             ),
//         ],
//       ),
//       child: Material(
//         type: MaterialType.transparency,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(10),
//           onTap: isProcessingAnswer ? null : () => handleAnswer(option),
//           child: Stack(
//             children: [
//               Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(8),
//                   child: Text(
//                     option,
//                     style: TextStyle(
//                       fontFamily: 'Kanit',
//                       fontSize: 20,
//                       color: Colors.blue[900],
//                       fontWeight: FontWeight.w500,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               if (showFeedback && isSelected)
//                 Positioned(
//                   right: 8,
//                   top: 8,
//                   child: Icon(
//                     isCorrect ? Icons.check_circle : Icons.cancel,
//                     color: isCorrect ? Colors.green : Colors.red,
//                     size: 24,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFeedbackBanner() {
//     return Material(
//       color: isCorrect ? Colors.green : Colors.red,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 12),
//         width: double.infinity,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isCorrect ? Icons.check : Icons.close,
//               color: Colors.white,
//               size: 28,
//             ),
//             SizedBox(width: 8),
//             Text(
//               isCorrect 
//                   ? 'เยี่ยมมาก! คำตอบถูกต้อง'
//                   : 'เสียใจด้วย! คำตอบที่ถูกคือ ${currentQuestion?.correctAnswer}',
//               style: TextStyle(
//                 fontFamily: 'Kanit',
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //   @override
// //   void dispose() {
// //     timer?.cancel();
// //     super.dispose();
// //   }
// // }

// class QuizQuestion {
//   final String text;
//   final String correctAnswer;
//   final List<String> options;

//   QuizQuestion({
//     required this.text,
//     required this.correctAnswer,
//     required this.options,
//   });
// }