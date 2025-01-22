import 'dart:math';
import 'package:flutter_application_0/models/question1.dart';
import 'package:flutter_application_0/utills/thai_word_utils.dart';
import 'package:sqflite/sqflite.dart';

class QuestionService {
  final Database database;

  QuestionService(this.database);

  // Future<List<String>> getRandomVocabs({
  //   required int count,
  //   required String excludeWord,
  //   int? gradeID,
  // }) async {
  //   // Query to get random words excluding the question word
  //   final List<Map<String, dynamic>> results = await database.query(
  //     'Vocabulary',
  //     where: 'vocab != ? ${gradeID != null ? 'AND gradeID = ?' : ''}',
  //     whereArgs: gradeID != null ? [excludeWord, gradeID] : [excludeWord],
  //     orderBy: 'RANDOM()',
  //     limit: count,
  //   );

  //   return results.map((map) => map['vocab'] as String).toList();
  // }

//   Future<String> getRandomWord({int? gradeID}) async {
//     final List<Map<String, dynamic>> result = await database.query(
//       'Vocabulary',
//       where: gradeID != null ? 'gradeID = ?' : null,
//       whereArgs: gradeID != null ? [gradeID] : null,
//       orderBy: 'RANDOM()',
//       limit: 1,
//     );
    
//     if (result.isEmpty) {
//       throw Exception('ไม่พบคำศัพท์ในฐานข้อมูล');
//     }
    
//     return result.first['vocab'] as String;
//   }

//   Future<List<String>> getWordsWithSameEnding({
//     required String targetWord,
//     required int count,
//     int? gradeID,
//   }) async {
//     // TODO: ในอนาคตควรเพิ่มลอจิกสำหรับตรวจสอบมาตราตัวสะกด
//     // สำหรับตอนนี้จะใช้การสุ่มคำมาก่อน
//     final List<Map<String, dynamic>> results = await database.query(
//       'Vocabulary',
//       where: 'vocab != ? ${gradeID != null ? 'AND gradeID = ?' : ''}',
//       whereArgs: gradeID != null ? [targetWord, gradeID] : [targetWord],
//       orderBy: 'RANDOM()',
//       limit: count,
//     );

//     return results.map((map) => map['vocab'] as String).toList();
//   }

//   // เพิ่มเมธอดสำหรับสร้างคำถามแบบ Dynamic
//   Future<Question1> createDynamicQuestion({
//     required int modelNum,
//     required int gradeID,
//   }) async {
//     final String wordQuestion = await getRandomWord(gradeID: gradeID);
    
//     switch (modelNum) {
//       case 1:
//         return Question1(
//           model_num: 1,
//           setQuestion: "{wordQuestion}เป็นคำที่มีตัวสะกดมาตราใด?",
//           wordQuestion: wordQuestion,
//           options: [
//             Options(optionTEXT: "แม่กม", isCorrect: false),
//             Options(optionTEXT: "แม่กน", isCorrect: true),
//             Options(optionTEXT: "แม่เกย", isCorrect: false),
//             Options(optionTEXT: "แม่กบ", isCorrect: false),
//           ],
//         );
        
//       case 2:
//         final List<String> similarWords = await getWordsWithSameEnding(
//           targetWord: wordQuestion,
//           count: 4,
//           gradeID: gradeID,
//         );
        
//         return Question1(
//           model_num: 2,
//           setQuestion: "ข้อใดมีมาตราตัวสะกดคำท้ายตรงกับคำว่า {wordQuestion}?",
//           wordQuestion: wordQuestion,
//           options: similarWords.map((word) => 
//             Options(
//               optionTEXT: word,
//               isCorrect: false, // TODO: ต้องเพิ่มลอจิกตรวจสอบมาตราตัวสะกด
//             )
//           ).toList(),
//         );
        
//       default:
//         throw Exception('ไม่พบรูปแบบคำถามที่ต้องการ');
//     }
//   }
// }
Future<String> getRandomWord({int? gradeID}) async {
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

    return results.first['vocab'] as String;
  }

 Future<List<String>> getWordsWithSameEnding({
    required String targetWord,
    required int count,
    int? gradeID,
  }) async {
    String? targetEnding = ThaiWordUtils.getEndingSound(targetWord);
    if (targetEnding == null) {
      throw Exception('ไม่สามารถระบุมาตราตัวสะกดของคำว่า "$targetWord" ได้');
    }

    final List<Map<String, dynamic>> results = await database.query(
      'Vocabulary',
      where: 'endingSound = ? AND vocab != ? ${gradeID != null ? 'AND gradeID = ?' : ''}',
      whereArgs: gradeID != null ? [targetEnding, targetWord, gradeID] : [targetEnding, targetWord],
      orderBy: 'RANDOM()',
      limit: count,
    );

    if (results.isEmpty) {
      throw Exception('ไม่พบคำที่มีมาตราตัวสะกดเดียวกับ "$targetWord"');
    }

    return results.map((map) => map['vocab'] as String).toList();
  }

 Future<void> checkDatabaseConnection() async {
    try {
      await getRandomWord();
      print('เชื่อมต่อกับฐานข้อมูลสำเร็จ');
    } catch (e) {
      print('เกิดข้อผิดพลาดในการเชื่อมต่อฐานข้อมูล: $e');
    }
  }
  // สร้างคำถามแบบ Dynamic
  Future<Question1> createDynamicQuestion({
    required int modelNum,
    required int gradeID,
  }) async {
    final String wordQuestion = await getRandomWord(gradeID: gradeID);
    String? endingSound = ThaiWordUtils.getEndingSound(wordQuestion);
    
    switch (modelNum) {
      case 1:
        // คำถามเกี่ยวกับมาตราตัวสะกด
        return Question1(
          model_num: 1,
          setQuestion: "{wordQuestion}เป็นคำที่มีตัวสะกดมาตราใด?",
          wordQuestion: wordQuestion,
          options: [
            Options(
              optionTEXT: endingSound ?? "ไม่มีตัวสะกด",
              isCorrect: true
            ),
            ...await _getRandomWrongEndingSounds(
              correctEnding: endingSound,
              count: 3,
            ),
          ], endingSound: endingSound.toString(),
        );
        
      case 2:
        // คำถามหาคำที่มีมาตราตัวสะกดเดียวกัน
        final List<String> correctWords = await getWordsWithSameEnding(
          targetWord: wordQuestion,
          count: 1,
          gradeID: gradeID,
        );
        
        final List<String> wrongWords = await getWordsWithDifferentEnding(
          targetWord: wordQuestion,
          count: 3,
          gradeID: gradeID,
        );

        List<Options> options = [
          Options(optionTEXT: correctWords[0], isCorrect: true),
          ...wrongWords.map((word) => Options(optionTEXT: word, isCorrect: false)),
        ];
        
        // สลับตำแหน่งตัวเลือก
        options.shuffle();
        
        return Question1(
          model_num: 2,
          setQuestion: "ข้อใดมีมาตราตัวสะกดตรงกับคำว่า {wordQuestion}?",
          wordQuestion: wordQuestion,
          options: options, endingSound: '',
        );

      case 3:
        // คำถามจับคู่คำที่มีมาตราตัวสะกดเดียวกัน
        final List<String> words = await getMultipleWordsWithSameEnding(
          count: 2,
          gradeID: gradeID,
        );
        
        return Question1(
          model_num: 3,
          setQuestion: "คำคู่ใดมีมาตราตัวสะกดเดียวกัน?",
          wordQuestion: "",
          options: [
            Options(
              optionTEXT: "${words[0]} - ${words[1]}",
              isCorrect: true
            ),
            ...await _getRandomWrongWordPairs(
              count: 3,
              gradeID: gradeID,
            ),
          ], endingSound: endingSound.toString(),
        );
        
      default:
        throw Exception('ไม่พบรูปแบบคำถามที่ต้องการ');
    }
  }

  // ดึงมาตราตัวสะกดที่ไม่ตรงกับคำตอบที่ถูกต้อง
  Future<List<Options>> _getRandomWrongEndingSounds({
    required String? correctEnding,
    required int count,
  }) async {
    List<String> allEndings = ThaiWordUtils.endingSoundMap.values.toList();
    allEndings.remove(correctEnding);
    allEndings.shuffle();
    
    return allEndings.take(count).map((ending) =>
      Options(optionTEXT: ending, isCorrect: false)
    ).toList();
  }

  // ดึงคำที่มีมาตราตัวสะกดต่างกัน
  Future<List<String>> getWordsWithDifferentEnding({
    required String targetWord,
    required int count,
    int? gradeID,
  }) async {
    String? targetEnding = ThaiWordUtils.getEndingSound(targetWord);
    
    final List<Map<String, dynamic>> results = await database.query(
      'Vocabulary',
      where: 'endingSound != ? AND vocab != ? ${gradeID != null ? 'AND gradeID = ?' : ''}',
      whereArgs: gradeID != null ? [targetEnding, targetWord, gradeID] : [targetEnding, targetWord],
      orderBy: 'RANDOM()',
      limit: count,
    );

    return results.map((map) => map['vocab'] as String).toList();
  }

  // ดึงคู่คำที่มีมาตราตัวสะกดเดียวกัน
  Future<List<String>> getMultipleWordsWithSameEnding({
    required int count,
    int? gradeID,
  }) async {
    final List<Map<String, dynamic>> results = await database.rawQuery('''
      SELECT v1.vocab as word1, v2.vocab as word2
      FROM Vocabulary v1
      JOIN Vocabulary v2 ON v1.endingSound = v2.endingSound
      WHERE v1.vocab != v2.vocab
      ${gradeID != null ? 'AND v1.gradeID = ? AND v2.gradeID = ?' : ''}
      ORDER BY RANDOM()
      LIMIT 1
    ''', gradeID != null ? [gradeID, gradeID] : []);

    if (results.isEmpty) return [];
    return [results[0]['word1'] as String, results[0]['word2'] as String];
  }

  // สร้างคู่คำที่มีมาตราตัวสะกดต่างกัน
  Future<List<Options>> _getRandomWrongWordPairs({
    required int count,
    int? gradeID,
  }) async {
    final List<Map<String, dynamic>> results = await database.rawQuery('''
      SELECT v1.vocab as word1, v2.vocab as word2
      FROM Vocabulary v1
      JOIN Vocabulary v2 ON v1.endingSound != v2.endingSound
      WHERE v1.vocab != v2.vocab
      ${gradeID != null ? 'AND v1.gradeID = ? AND v2.gradeID = ?' : ''}
      ORDER BY RANDOM()
      LIMIT ?
    ''', gradeID != null ? [gradeID, gradeID, count] : [count]);

    return results.map((result) => 
      Options(
        optionTEXT: "${result['word1']} - ${result['word2']}",
        isCorrect: false,
      )
    ).toList();
  }
}

