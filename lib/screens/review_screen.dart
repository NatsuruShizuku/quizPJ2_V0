// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/models/category.dart';
// import 'package:flutter_application_0/widgets/answer_review_card.dart';

// class ReviewScreen extends StatelessWidget {
//   final Category category;
//   final List<int?> userAnswers;

//   const ReviewScreen({
//     super.key,
//     required this.category,
//     required this.userAnswers,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text('Question Review'),
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: category.questions.length,
//         itemBuilder: (context, index) {
//           return AnswerReviewCard(
//             question: category.questions[index],
//             userAnswer: userAnswers[index],
//             index: index,
//           );
//         },
//       ),
//     );
//   }
// }
