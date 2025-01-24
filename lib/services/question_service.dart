// import 'dart:math';
// import 'package:flutter_application_0/models/question1.dart';
// import 'package:sqflite/sqflite.dart';

// class QuestionService {
//   final Database database;

//   QuestionService(this.database);

//   Future<String> getRandomWord({int? gradeID}) async {
//     final List<Map<String, dynamic>> results = await database.query(
//       'Vocabulary',
//       where: gradeID != null ? 'gradeID = ?' : null,
//       whereArgs: gradeID != null ? [gradeID] : null,
//       orderBy: 'RANDOM()',
//       limit: 1,
//     );

//     if (results.isEmpty) {
//       throw Exception('ไม่พบคำศัพท์ในฐานข้อมูล');
//     }

//     return results.first['vocab'] as String;
//   }

//   Future<List<String>> getWordsWithSameEnding({
//     required String targetWord,
//     required int count,
//     int? gradeID,
//   }) async {
//     // Query to get the ending sound of target word
//     final List<Map<String, dynamic>> targetResult = await database.query(
//       'Vocabulary',
//       columns: ['endingSound'],
//       where: 'vocab = ?',
//       whereArgs: [targetWord],
//       limit: 1,
//     );

//     if (targetResult.isEmpty) {
//       throw Exception('ไม่พบคำที่ระบุในฐานข้อมูล');
//     }

//     String? targetEnding = targetResult.first['endingSound'] as String?;

//     // Get words with same ending sound
//     final List<Map<String, dynamic>> results = await database.query(
//       'Vocabulary',
//       where: 'endingSound = ? AND vocab != ? ${gradeID != null ? 'AND gradeID = ?' : ''}',
//       whereArgs: gradeID != null ? [targetEnding, targetWord, gradeID] : [targetEnding, targetWord],
//       orderBy: 'RANDOM()',
//       limit: count,
//     );

//     return results.map((map) => map['vocab'] as String).toList();
//   }
//  Future<void> checkDatabaseConnection() async {
//     try {
//       await getRandomWord();
//       print('เชื่อมต่อกับฐานข้อมูลสำเร็จ');
//     } catch (e) {
//       print('เกิดข้อผิดพลาดในการเชื่อมต่อฐานข้อมูล: $e');
//     }
//   }

//   Future<Question1> createDynamicQuestion({
//     required int modelNum,
//     required int gradeID,
//   }) async {
//     final String wordQuestion = await getRandomWord(gradeID: gradeID);
    
//     // Get the ending sound from database
//     final List<Map<String, dynamic>> wordData = await database.query(
//       'Vocabulary',
//       columns: ['endingSound'],
//       where: 'vocab = ?',
//       whereArgs: [wordQuestion],
//       limit: 1,
//     );

//     String? endingSound = wordData.first['endingSound'] as String?;
    
//     switch (modelNum) {
//       case 1:

//         return Question1(
//           modelnum: 1,
//           setQuestion: "${wordQuestion}เป็นคำที่มีตัวสะกดมาตราใด?",
//           wordQuestion: wordQuestion,
//           options: await _createEndingSoundOptions(endingSound, gradeID),
//           endingSound: endingSound ?? '',
//         );
        
//       case 2:

//         return Question1(
//           modelnum: 2,
//           setQuestion: "คำใดมีมาตราตัวสะกดเดียวกับคำว่า ${wordQuestion}?",
//           wordQuestion: wordQuestion,
//           options: await _createSameEndingWordOptions(wordQuestion, endingSound, gradeID),
//           endingSound: endingSound ?? '',
//         );
        
//         case 3:

//         return Question1(
//           modelnum: 3,
//           setQuestion: "ข้อใดเป็นมาตราตัวสะกด ${endingSound}?",
//           wordQuestion: endingSound.toString(),
//           options: await _createSameEndingWordOptions(wordQuestion, endingSound, gradeID),
//           endingSound: endingSound ?? '',
//         );

//         case 4:

//         return Question1(
//           modelnum: 4,
//           setQuestion: "ข้อใดไม่ใช่มาตราตัวสะกด ${endingSound}?",
//           wordQuestion: endingSound.toString(),
//           options: await _createSameEndingWordOptions(wordQuestion, endingSound, gradeID),
//           endingSound: endingSound ?? '',
//         );

//       default:
//         throw Exception('ไม่พบรูปแบบคำถามที่ต้องการ');
//     }
//   }

//   Future<List<Options>> _createEndingSoundOptions(String? correctEnding, int gradeID) async {
//     // Get distinct ending sounds from database
//     final List<Map<String, dynamic>> endingSounds = await database.rawQuery('''
//       SELECT DISTINCT endingSound 
//       FROM Vocabulary 
//       WHERE endingSound IS NOT NULL 
//       AND endingSound != ? 
//       AND gradeID = ?
//       ORDER BY RANDOM() 
//       LIMIT 3
//     ''', [correctEnding, gradeID]);

//     List<Options> options = [
//       Options(optionTEXT: correctEnding ?? "ไม่มีตัวสะกด", isCorrect: true),
//       ...endingSounds.map((e) => Options(
//         optionTEXT: e['endingSound'] as String,
//         isCorrect: false,
//       )),
//     ];

//     options.shuffle();
//     return options;
//   }

//   Future<List<Options>> _createSameEndingWordOptions(
//   String questionWord,
//   String? endingSound,
//   int gradeID,
// ) async {
//   try {
//     // Get one correct word (same ending)
//     final List<String> correctWords = await getWordsWithSameEnding(
//       targetWord: questionWord,
//       count: 1,
//       gradeID: gradeID,
//     );

//     // Fallback if no correct words found
//     if (correctWords.isEmpty) {
//       // Fetch a random word as fallback
//       correctWords.add(await getRandomWord(gradeID: gradeID));
//     }

//     // Get three words with different endings
//     final List<Map<String, dynamic>> wrongWords = await database.query(
//       'Vocabulary',
//       where: 'endingSound != ? AND vocab != ? AND gradeID = ?',
//       whereArgs: [endingSound, questionWord, gradeID],
//       orderBy: 'RANDOM()',
//       limit: 3,
//     );

//     while (wrongWords.length < 3) {
//       final additionalWord = await database.query(
//         'Vocabulary',
//         where: 'vocab != ? AND gradeID = ?',
//         whereArgs: [questionWord, gradeID],
//         orderBy: 'RANDOM()',
//         limit: 1,
//       );
//       wrongWords.addAll(additionalWord);
//     }

//     List<Options> options = [
//       Options(optionTEXT: correctWords[0], isCorrect: true),
//       ...wrongWords.map((word) => Options(
//         optionTEXT: word['vocab'] as String,
//         isCorrect: false,
//       )),
//     ];

//     options.shuffle();
//     return options;
//   } catch (e) {
//     print('Error creating options: $e');
//     // Fallback to random words if everything fails
//     return await _createRandomWordOptions(gradeID);
//   }
// }

// Future<List<Options>> _createRandomWordOptions(int gradeID) async {
//   final randomWords = await database.query(
//     'Vocabulary',
//     where: 'gradeID = ?',
//     whereArgs: [gradeID],
//     orderBy: 'RANDOM()',
//     limit: 4,
//   );

//   List<Options> options = randomWords.map((word) => 
//     Options(
//       optionTEXT: word['vocab'] as String, 
//       isCorrect: false
//     )
//   ).toList();

//   // Mark first word as correct
//   options[0] = Options(
//     optionTEXT: options[0].optionTEXT, 
//     isCorrect: true
//   );

//   options.shuffle();
//   return options;
// }

// }
// old version
import 'dart:math';
import 'package:flutter_application_0/models/matraModel.dart';

import '../models/question1.dart';
import '../models/wordModel.dart';
import '../models/questionModel.dart';
import 'package:sqflite/sqflite.dart';

class QuestionService {
  final Database database;

  QuestionService(this.database);

  Future<Vocabulary> getRandomWord({int? gradeID}) async {
    final List<Map<String, dynamic>> results = await database.query(
      'Vocabulary',
      where: gradeID != null ? 'gradeID = ?' : null,
      whereArgs: gradeID != null ? [gradeID] : null,
      orderBy: 'RANDOM()',
      limit: 1,
    );

    if (results.isEmpty) {
      throw Exception('ไม่พบคำศัพท์ในฐานข้อมูล');
    }

    return Vocabulary.fromMap(results.first);
  }

//   Future<Vocabulary> getRandomWord({int? gradeID}) async {
//   final List<Map<String, dynamic>> results = await database.query(
//     'Vocabulary',
//     where: gradeID != null ? 'gradeID = ?' : null,
//     whereArgs: gradeID != null ? [gradeID] : null,
//     orderBy: 'RANDOM()',
//     limit: 1,
//   );

//   if (results.isEmpty) {
//     throw Exception('ไม่พบคำศัพท์ในฐานข้อมูล');
//   }

//   return Vocabulary.fromMap(results.first); // อ่าน matraDetail พร้อมกับข้อมูลอื่น
// }


  Future<Matramodel> getRandomMatra({int? matraID}) async {
    final List<Map<String, dynamic>> results = await database.query(
      'Matra',
      where: matraID != null ? 'matraID = ?' : null,
      whereArgs: matraID != null ? [matraID] : null,
      orderBy: 'RANDOM()',
      limit: 1,
    );

    if (results.isEmpty) {
      throw Exception('ไม่พบมาตราในฐานข้อมูล');
    }

    return Matramodel.fromMap(results.first);
  }

  Future<Question1> createDynamicQuestion({
    required int modelNum,
    required int gradeID,
    required int matraID,
  }) async {
    final Vocabulary randomWord = await getRandomWord(gradeID: gradeID);
    final Matramodel randomMatra = await getRandomMatra(matraID: matraID);

    switch (modelNum) {
      case 1:
        return Question1(
          modelnum: modelNum,
          modelWord: randomWord,
          modelMatra: randomMatra.matraDetail,
          modelQuestion: QuestionModels(
            questionID: modelNum,
            questionTEXT: "คำว่า '${randomWord.vocab}' มีมาตราใด?",
          ),
          options: await _createSameEndingWordOptions(randomWord, gradeID),
        );

      case 2:
        return Question1(
          modelnum: modelNum,
          modelWord: randomWord,
          modelMatra: randomMatra.matraDetail,
          modelQuestion: QuestionModels(
            questionID: modelNum,
            questionTEXT: "คำใดมีมาตราตัวสะกดเดียวกับ '${randomWord.vocab}'?",
          ),
          options: await _createSameEndingWordOptions(randomWord, gradeID),
        );

      default:
        throw Exception('ไม่พบรูปแบบคำถามที่ต้องการ');
    }
  }

  




  // Future<List<Options>> _createEndingSoundOptions(String? correctEnding, int gradeID) async {
  //   final List<Map<String, dynamic>> endingSounds = await database.rawQuery(
  //     '''
  //     SELECT DISTINCT endingSound 
  //     FROM Vocabulary 
  //     WHERE endingSound IS NOT NULL AND endingSound != ? AND gradeID = ? 
  //     ORDER BY RANDOM() LIMIT 3
  //     ''',
  //     [correctEnding, gradeID],
  //   );

  //   List<Options> options = [
  //     Options(optionTEXT: correctEnding ?? "ไม่มีตัวสะกด", isCorrect: true),
  //     ...endingSounds.map((e) => Options(optionTEXT: e['endingSound'] as String, isCorrect: false)),
  //   ];

  //   options.shuffle();
  //   return options;
  // }

  Future<List<Options>> _createSameEndingWordOptions(Vocabulary word, int gradeID) async {
    final List<Map<String, dynamic>> correctWords = await database.query(
      'Vocabulary',
      where: 'vocab = ? AND syllable != ? AND gradeID = ?',
      whereArgs: [word.vocab, word.syllable, gradeID],
      orderBy: 'RANDOM()',
      limit: 1,
    );

    final List<Map<String, dynamic>> wrongWords = await database.query(
      'Vocabulary',
      where: 'vocab != ? AND gradeID = ?',
      whereArgs: [word.vocab, gradeID],
      orderBy: 'RANDOM()',
      limit: 3,
    );

    List<Options> options = [
      ...correctWords.map((w) => Options(optionTEXT: w['vocab'] as String, isCorrect: true)),
      ...wrongWords.map((w) => Options(optionTEXT: w['vocab'] as String, isCorrect: false)),
    ];

    options.shuffle();
    return options;
  }
}
