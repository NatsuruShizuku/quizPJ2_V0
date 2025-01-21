// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/models/category.dart';
// import 'package:flutter_application_0/screens/quiz_screen.dart';

// class CategoryCard extends StatelessWidget {
//   final Category category;

//   const CategoryCard({super.key, required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => QuizScreen(category: category),
//           ),
//         );
//       },
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               category.icon,
//               style: const TextStyle(fontSize: 40),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               category.name,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }