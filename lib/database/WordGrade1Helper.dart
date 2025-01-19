// import 'package:sqflite/sqflite.dart';

// import '../const/const.dart';

// class WordGrade1Helper {
//   Future<List<Grade1>> getQuestionByModule(
//       Database db, columnQuizId) async {
//     var maps = await db.query(tableQuizName,
//         columns: [
          
//         ],
//         where: '$columnQuizId = ?',
//         whereArgs: [columnQuizId]);
//     if (maps.isNotEmpty) {
//       return maps.map((grade1) => grade1.fromMap(grade1)).toList();
//     }
//     return List<Question>.empty();
//   }

//   Future<List<Grade1>> getQuestion(Database db) async {
//     var maps = await db.query(tableName,
//         columns: [
//           columnId,
//           columnCategoryId,
//           columnText,
//           columnImage,
//           columnAnswerA,
//           columnAnswerB,
//           columnAnswerC,
//           columnAnswerD,
//           columnCorrectAnswer,
//           columnIsImageQuestion
//         ],
//         limit: 10,
//         orderBy: "RANDOM()");
//     if (maps.isNotEmpty) {
//       return maps.map((question) => Question.fromMap(question)).toList();
//     }
//     return List<Question>.empty();
//   }

//   Future<Question> getQuestionById(Database db, int columnMainCategoryId) async {
//     var maps = await db.query(tableName,
//         columns: [
//           columnId,
//           columnCategoryId,
//           columnText,
//           columnImage,
//           columnAnswerA,
//           columnAnswerB,
//           columnAnswerC,
//           columnAnswerD,
//           columnCorrectAnswer,
//           columnIsImageQuestion
//         ],
//         where: '$columnId = ?',
//         whereArgs: [questionId]);
//     if (maps.isNotEmpty) {
//       return Question.fromMap(maps.first);
//     }
//     return Question();
//   }
// }
