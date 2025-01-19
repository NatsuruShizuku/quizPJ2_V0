// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/database/Grade1Helper.dart';
// import 'package:flutter_application_0/database/db_helper.dart';
// import 'package:flutter_application_0/models/word.dart';
// import 'package:flutter_application_0/state/state_management.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page'),
//       ),
//       body: FutureBuilder<List<Word>>(
//         future: getWord(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             return GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 1.0,
//                 mainAxisSpacing: 4.0,
//                 crossAxisSpacing: 4.0,
//               ),
//               padding: const EdgeInsets.all(4.0),
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final word = snapshot.data![index];
//                 return WordCard(word: word);
//               },
//             );
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<List<Word>> getWord() async {
//     var db = await copyDB();
//     var result = await Grade1Helper().getWord(db);
//     wordListState.value = result;
//     return result;
//   }
// }

// // Separate widget for the card to improve code organization
// class WordCard extends StatelessWidget {
//   final Word word;

//   const WordCard({
//     Key? key,
//     required this.word,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: word.id == -1 ? Colors.green : Colors.white,
//       elevation: 2,
//       child: InkWell(
//         onTap: () {
//           // Add your navigation logic here
//         },
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (word.vocab != null && word.vocab.isNotEmpty)
//                   Text(
//                     word.vocab,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: word.id == -1 ? Colors.white : Colors.black,
//                       fontSize: 18,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 if (word.syllable != null && word.vocab.isNotEmpty)
//                   Text(
//                     word.vocab,
//                     style: TextStyle(
//                       color: word.id == -1 ? Colors.white70 : Colors.black54,
//                       fontSize: 14,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//Test Database