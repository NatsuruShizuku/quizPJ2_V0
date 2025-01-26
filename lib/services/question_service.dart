// import 'dart:math';
// import 'package:flutter_application_0/models/matraModel.dart';

// import '../models/question1.dart';
// import '../models/wordModel.dart';
// import '../models/questionModel.dart';
// import 'package:sqflite/sqflite.dart';

// class QuestionService {
//   final Database database;

//   QuestionService(this.database);

//   Future<Vocabulary> getRandomWord({int? gradeID}) async {

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

//     return Vocabulary.fromMap(results.first);
//   }

//   Future<Matramodel> getRandomMatra({int? matraID}) async {
//     final List<Map<String, dynamic>> results = await database.query(
//       'Matra',
//       where: matraID != null ? 'matraID = ?' : null,
//       whereArgs: matraID != null ? [matraID] : null,
//       orderBy: 'RANDOM()',
//       limit: 1,
//     );

//     if (results.isEmpty) {
//       throw Exception('ไม่พบมาตราในฐานข้อมูล');
//     }

//     return Matramodel.fromMap(results.first);
//   }

//   Future<Question1> createDynamicQuestion({
//     required int modelNum,
//     required int gradeID,
//     required int matraID,
//   }) async {
//     final Vocabulary randomWord = await getRandomWord(gradeID: gradeID);
//     final Matramodel randomMatra = await getRandomMatra(matraID: matraID);

//     // void set setRandomWord(Vocabulary randomWord){

//     // }

//     switch (modelNum) {
//       case 1:
//         return Question1(
//           modelnum: modelNum,
//           modelWord: randomWord,
//           modelMatra: randomMatra.matraDetail,
//           modelQuestion: QuestionModels(
//             questionID: modelNum,
//             questionTEXT: "คำว่า '${randomWord.vocab}' มีมาตราใด?",
//           ),
//           options: await _createSameEndingWordOptions(randomWord, gradeID),
//         );

//       case 2:
//         return Question1(
//           modelnum: modelNum,
//           modelWord: randomWord,
//           modelMatra: randomMatra.matraDetail,
//           modelQuestion: QuestionModels(
//             questionID: modelNum,
//             questionTEXT: "คำใดมีมาตราตัวสะกดเดียวกับ '${randomWord.vocab}'?",
//           ),
//           options: await _createSameEndingWordOptions(randomWord, gradeID),
//         );

//       default:
//         throw Exception('ไม่พบรูปแบบคำถามที่ต้องการ');

//     }

//   }

/*
  Future<List<Options>> _createEndingSoundOptions(String? correctEnding, int gradeID) async {
    final List<Map<String, dynamic>> endingSounds = await database.rawQuery(
      '''
      SELECT DISTINCT endingSound 
      FROM Vocabulary 
      WHERE endingSound IS NOT NULL AND endingSound != ? AND gradeID = ? 
      ORDER BY RANDOM() LIMIT 3
      ''',
      [correctEnding, gradeID],
    );

    List<Options> options = [
      Options(optionTEXT: correctEnding ?? "ไม่มีตัวสะกด", isCorrect: true),
      ...endingSounds.map((e) => Options(optionTEXT: e['endingSound'] as String, isCorrect: false)),
    ];

    options.shuffle();
    return options;
  }

//ส่วนสุุ่มคำถูก

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
*/
import 'package:flutter_application_0/models/matraModel.dart';
import 'package:flutter_application_0/models/question1.dart';
import 'package:flutter_application_0/models/questionModel.dart';
import 'package:flutter_application_0/models/wordModel.dart';
import 'package:sqflite/sqflite.dart';

class QuestionService {
  final Database database;

  QuestionService(this.database);

  static String processThaiWordEnding(String word) {
    if (word.isEmpty) return 'ไม่มีพยัญชนะ';

    final List<String> consonants = [
     'ก', 'ข', 'ค', 'ฆ',
    'ง',
    'ด', 'ต', 'ถ', 'ท', 'ธ', 'จ', 'ธ', 'ฎ', 'ฏ', 'ฑ', 'ฒ', 'ช', 'ซ', 'ศ', 'ษ', 'ส',
    'น', 'ณ', 'ญ', 'ร', 'ล', 'ฬ',
    'บ', 'ป', 'พ', 'ฟ', 'ภ',
    'ม',
    'ย',
    'ว',
    ];

    final List<String> vowels = [
      'ะ',
      'ั',
      'า',
      'ิ',
      'ี',
      'ึ',
      'ื',
      'ุ',
      'ู',
      'เ',
      'แ',
      'โ',
      'ใ',
      'ไ',
      'อ'
    ];

    final List<String> specialMarks = ['์']; // การันต์
    final List<String> toneMarks = ['่', '้', '๊', '๋']; // วรรณยุกต์

    String? lastConsonant;
    bool isLastVowel = false;

    for (int i = word.length - 1; i >= 0; i--) {
      String currentChar = word[i];

      if (vowels.contains(currentChar)) {
        isLastVowel = true;
        break;
      }

      if (toneMarks.contains(currentChar)) {
        isLastVowel = true;
        break;
      }

      if (i > 0 &&
          specialMarks.contains(currentChar) &&
          vowels.contains(word[i - 1])) {
        i--;
        continue;
      }

      if (i < word.length - 1 && specialMarks.contains(word[i + 2])) continue;

      if (consonants.contains(currentChar)) {
        lastConsonant = currentChar;
        break;
      }
    }

    return isLastVowel ? 'แม่ ก กา' : (lastConsonant ?? 'ไม่มีพยัญชนะ');
  }

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

  static String identifyThaiCategory(String consonant) {
    if (consonant == 'แม่ ก กา') {
      return 'แม่ ก กา';
    }

    final Map<String, String> categories = {
      'ก': 'แม่กก',
    'ข': 'แม่กก',
    'ค': 'แม่กก',
    'ฆ': 'แม่กก',
    'ง': 'แม่กง',
    'จ': 'แม่กด',
    'ช': 'แม่กด',
    'ญ': 'แม่กน',
    'ด': 'แม่กด',
    'ต': 'แม่กด',
    'ถ': 'แม่กด',
    'ท': 'แม่กด',
    'ธ': 'แม่กด',
    'น': 'แม่กน',
    'ณ': 'แม่กน',
    'บ': 'แม่กบ',
    'ป': 'แม่กบ',
    'พ': 'แม่กบ',
    'ฟ': 'แม่กบ',
    'ภ': 'แม่กบ',
    'ม': 'แม่กม',
    'ย': 'แม่เกย',
    'ร': 'แม่กน',
    'ล': 'แม่กน',
    'ว': 'แม่เกอว',
    'ส': 'แม่กด',
    'ศ': 'แม่กด',
    'ษ': 'แม่กด',
    'ฬ': 'แม่กน',
    };

    return categories[consonant] ?? 'ไม่พบมาตราตัวสะกด';
  }

  Future<List<Options>> _createEndingSoundOptions(Vocabulary word, int gradeID) async {
  final lastConsonant = processThaiWordEnding(word.vocab);
  final correctCategory = identifyThaiCategory(lastConsonant);

  final List<Map<String, dynamic>> similarWords = await database.query(
    'Vocabulary',
    columns: ['vocab'],
    where: 'syllable != ? AND gradeID = ?',
    whereArgs: [word.syllable, gradeID],
    orderBy: 'RANDOM()',
    limit: 3,
  );

  List<Options> options = [
    Options(optionTEXT: correctCategory, isCorrect: true),
    ...similarWords.map((e) {
      final tempLastConsonant = processThaiWordEnding(e['vocab']);
      final tempCategory = identifyThaiCategory(tempLastConsonant);
      return Options(optionTEXT: tempCategory, isCorrect: false);
    }),
  ];

  options.shuffle();
  return options;
}

Future<List<Options>> _createSameEndingWordOptions(Vocabulary word, int gradeID) async {
  final lastConsonant = processThaiWordEnding(word.vocab);
  final correctCategory = identifyThaiCategory(lastConsonant);

  final Set<String> uniqueCategories = {correctCategory};
  List<Options> options = [
    Options(optionTEXT: correctCategory, isCorrect: true)
  ];

  while (options.length < 4) {
    final List<Map<String, dynamic>> wrongWords = await database.query(
      'Vocabulary',
      where: 'vocab != ? AND gradeID = ?',
      whereArgs: [word.vocab, gradeID],
      orderBy: 'RANDOM()',
      limit: 1,
    );

    if (wrongWords.isEmpty) break;

    final wrongCategory = identifyThaiCategory(processThaiWordEnding(wrongWords.first['vocab']));
    
    if (!uniqueCategories.contains(wrongCategory)) {
      uniqueCategories.add(wrongCategory);
      options.add(Options(optionTEXT: wrongCategory, isCorrect: false));
    }
  }

  options.shuffle();
  return options;
}
}