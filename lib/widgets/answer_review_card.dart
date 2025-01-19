// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/models/question.dart';

// class AnswerReviewCard extends StatelessWidget {
//   final Question question;
//   final int? userAnswer;
//   final int index;

//   const AnswerReviewCard({
//     super.key,
//     required this.question,
//     required this.userAnswer,
//     required this.index,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isCorrect = userAnswer == question.correctAnswerIndex;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ExpansionTile(
//         leading: Container(
//           width: 32,
//           height: 32,
//           decoration: BoxDecoration(
//             color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Icon(
//             isCorrect ? Icons.check : Icons.close,
//             color: isCorrect ? Colors.green : Colors.red,
//             size: 20,
//           ),
//         ),
//         title: Text(
//           'Question ${index + 1}',
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Text(
//           question.questionText,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Details',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 ...List.generate(
//                   question.options.length,
//                   (i) => Container(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: _getOptionColor(i),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Text(
//                           String.fromCharCode(65 + i),
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: _getOptionTextColor(i),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             question.options[i],
//                             style: TextStyle(
//                               color: _getOptionTextColor(i),
//                             ),
//                           ),
//                         ),
//                         if (i == question.correctAnswerIndex)
//                           Icon(
//                             Icons.check_circle,
//                             color: Colors.green.shade700,
//                             size: 20,
//                           ),
//                         if (i == userAnswer && i != question.correctAnswerIndex)
//                           Icon(
//                             Icons.cancel,
//                             color: Colors.red.shade700,
//                             size: 20,
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getOptionColor(int index) {
//     if (index == question.correctAnswerIndex) {
//       return Colors.green.shade50;
//     }
//     if (index == userAnswer && userAnswer != question.correctAnswerIndex) {
//       return Colors.red.shade50;
//     }
//     return Colors.grey.shade50;
//   }

//   Color _getOptionTextColor(int index) {
//     if (index == question.correctAnswerIndex) {
//       return Colors.green.shade700;
//     }
//     if (index == userAnswer && userAnswer != question.correctAnswerIndex) {
//       return Colors.red.shade700;
//     }
//     return Colors.grey.shade700;
//   }
// }