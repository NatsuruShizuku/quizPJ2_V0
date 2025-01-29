import 'dart:math';

import 'package:flutter/material.dart';
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

Future<QuestionModels> getRandomQuestion({int? questionID}) async {
    final List<Map<String, dynamic>> results = await database.query(
      'QuestionM',
      where: questionID != null ? 'questionID = ?' : null,
      whereArgs: questionID != null ? [questionID] : null,
      orderBy: 'RANDOM()',
      limit: 1,
    );

    if (results.isEmpty) {
      throw Exception('ไม่พบคำถามในฐานข้อมูล');
    }

    return QuestionModels.fromMap(results.first);
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

  // Future<Question1> createDynamicQuestion({
  //   required int modelNum,
  //   required int gradeID,
  //   required int matraID, 
  //   required int questionID,
  // }) async {
  //   final Vocabulary randomWord = await getRandomWord(gradeID: gradeID);
  //   final Matramodel randomMatra = await getRandomMatra(matraID: matraID);
  //   final QuestionModels randomQuestion = await getRandomQuestion(questionID: questionID);

  //   switch (modelNum) {
  //     case 1:
  //       return Question1(
  //         modelnum: 1,
  //         modelWord: randomWord,
  //         modelMatra: randomMatra,
  //         modelQuestion: QuestionModels(
  //           questionID: modelNum,
  //           questionTEXT: "'${randomWord.vocab}' ${randomQuestion.questionTEXT}?",
  //         ),
  //         options: await _createSameEndingWordOptions(randomWord, gradeID),
  //       );

  //     case 2:
  //       return Question1(
  //         modelnum: modelNum,
  //         modelWord: randomWord,
  //         modelMatra: randomMatra,
  //         modelQuestion: QuestionModels(
  //           questionID: modelNum,
  //           questionTEXT: "${randomQuestion.questionTEXT} ${randomWord.vocab}",
  //         ),
  //         options: await _createSameEndingWordOptions(randomWord, gradeID),
  //       );

  //     default:
  //       throw Exception('ไม่พบรูปแบบคำถามที่ต้องการ');
  //   }
  // }
  Future<List<Map<String, dynamic>>> fetchAllQuestions() async {
  final List<Map<String, dynamic>> results = await database.query('QuestionM');
  return results;
}
  Future<Question1> createDynamicQuestion({
  required int modelNum,
  required int gradeID,
  required int matraID,
}) async {
  final Vocabulary randomWord = await getRandomWord(gradeID: gradeID);
  final Matramodel randomMatra = await getRandomMatra(matraID: matraID);

  // สุ่ม questionID
  final List<Map<String, dynamic>> results = await database.query(
    'QuestionM',
    orderBy: 'RANDOM()', // ใช้การสุ่ม
    limit: 1,
  );

  if (results.isEmpty) {
    throw Exception('ไม่พบคำถามในฐานข้อมูล');
  }

  final int questionID = results.first['questionID'];
  final String questionText = results.first['questionTEXT'];
   if(questionID == 1) {
          return Question1(
            modelnum: modelNum,
            modelWord: randomWord,
            modelMatra: randomMatra,
            modelQuestion: QuestionModels(
              questionID: questionID, // ส่งค่า questionID ที่สุ่มได้
              questionTEXT: "${randomWord.vocab} $questionText?",
            ),
            options: await _createMatraOptions(randomWord, gradeID),
          );
   }
  else if(questionID == 2) {
          return Question1(
            modelnum: modelNum,
            modelWord: randomWord,
            modelMatra: randomMatra,
            modelQuestion: QuestionModels(
              questionID: questionID, // ส่งค่า questionID ที่สุ่มได้
              questionTEXT: "$questionText ${randomWord.vocab}?",
            ),
            options: await _createEndingSoundOptions(randomWord, gradeID),
          );
   }
   else if(questionID == 3 || questionID == 4 ) {
          return Question1(
            modelnum: modelNum,
            modelWord: randomWord,
            modelMatra: randomMatra,
            modelQuestion: QuestionModels(
              questionID: questionID, // ส่งค่า questionID ที่สุ่มได้
              questionTEXT: "$questionText ${randomMatra.matraDetail}?",
            ),
            options: await _createEndingSoundOptions(randomWord, gradeID),
          );
   }
   else if(questionID == 5 ) {
          return Question1(
            modelnum: modelNum,
            modelWord: randomWord,
            modelMatra: randomMatra,
            modelQuestion: QuestionModels(
              questionID: questionID, // ส่งค่า questionID ที่สุ่มได้
              questionTEXT: "$questionText ?",
            ),
            // options: await _createIndependentOptions(gradeID),
              options: await _createEndingSoundOptions(randomWord, gradeID),
          );
   }
   else if(questionID == 6 ) {
          return Question1(
            modelnum: modelNum,
            modelWord: randomWord,
            modelMatra: randomMatra,
            modelQuestion: QuestionModels(
              questionID: questionID, // ส่งค่า questionID ที่สุ่มได้
              questionTEXT: "$questionText ?",
            ),
            // options: await _createIndependentOptions(gradeID),
            options: await _createEndingSoundOptions(randomWord, gradeID),
          );
   }
   else{
    return Question1(
            modelnum: modelNum,
            modelWord: randomWord,
            modelMatra: randomMatra,
            modelQuestion: QuestionModels(
              questionID: questionID, // ส่งค่า questionID ที่สุ่มได้
              questionTEXT: "ไม่พบคำถาม",
            ),
            options: await _createEndingSoundOptions(randomWord, gradeID),
          );
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

//   Future<List<Options>> _createEndingSoundOptions(Vocabulary word, int gradeID) async {
//   final lastConsonant = processThaiWordEnding(word.vocab);
//   final correctCategory = identifyThaiCategory(lastConsonant);

//   final List<Map<String, dynamic>> similarWords = await database.query(
//     'Vocabulary',
//     columns: ['vocab'],
//     where: 'syllable != ? AND gradeID = ?',
//     whereArgs: [word.syllable, gradeID],
//     orderBy: 'RANDOM()',
//     limit: 3,
//   );

//   List<Options> options = [
//     Options(optionTEXT: correctCategory, isCorrect: true),
//     ...similarWords.map((e) {
//       final tempLastConsonant = processThaiWordEnding(e['vocab']);
//       final tempCategory = identifyThaiCategory(tempLastConsonant);
//       return Options(optionTEXT: tempCategory, isCorrect: false);
//     }),
//   ];

//   options.shuffle();
//   return options;
// }
Future<List<Options>> _createEndingSoundOptions(Vocabulary word, int gradeID) async {
  final String lastConsonant = processThaiWordEnding(word.vocab);
  final String correctCategory = identifyThaiCategory(lastConsonant);

  final Set<String> usedWords = {word.vocab}; // เก็บคำที่ใช้แล้ว
  List<Options> options = [];

  // สร้างตัวเลือกที่ถูกต้อง
  final List<Map<String, dynamic>> correctWords = await database.query(
    'Vocabulary',
    where: 'gradeID = ?',
    whereArgs: [gradeID],
    orderBy: 'RANDOM()',
  );

  for (var correctWord in correctWords) {
    final String currentWord = correctWord['vocab'];
    final String currentCategory = identifyThaiCategory(processThaiWordEnding(currentWord));

    if (currentCategory == correctCategory && !usedWords.contains(currentWord)) {
      options.add(Options(optionTEXT: currentWord, isCorrect: true));
      usedWords.add(currentWord);
      break; // หยุดหลังจากเพิ่มตัวเลือกที่ถูกต้อง
    }
  }

  // สร้างตัวเลือกที่ผิด
  while (options.length < 4) {
    final List<Map<String, dynamic>> wrongWords = await database.query(
      'Vocabulary',
      where: 'gradeID = ?',
      whereArgs: [gradeID],
      orderBy: 'RANDOM()',
      limit: 1,
    );

    if (wrongWords.isEmpty) break;

    final String currentWord = wrongWords.first['vocab'];
    final String currentCategory = identifyThaiCategory(processThaiWordEnding(currentWord));

    if (currentCategory != correctCategory && !usedWords.contains(currentWord)) {
      options.add(Options(optionTEXT: currentWord, isCorrect: false));
      usedWords.add(currentWord);
    }
  }

  // ตรวจสอบว่ามีตัวเลือกครบ 4 ตัวหรือไม่
  while (options.length < 4) {
    options.add(Options(
      optionTEXT: 'คำตอบเพิ่มเติม ${options.length + 1}',
      isCorrect: false,
    ));
  }

  options.shuffle(); // สลับลำดับตัวเลือก
  return options;
}

Future<List<Options>> _createIndependentOptions(int gradeID) async {
  final List<Map<String, dynamic>> allWords = await database.query(
    'Vocabulary',
    where: 'gradeID = ?',
    whereArgs: [gradeID],
    orderBy: 'RANDOM()', // สุ่มคำทั้งหมด
  );

  if (allWords.isEmpty) {
    throw Exception('ไม่พบคำในฐานข้อมูล');
  }

  List<Options> options = [];
  Set<String> usedCategories = {}; // เก็บมาตราตัวสะกดที่ใช้แล้ว

  // เลือกคำที่ถูกต้อง (คำแรก)
  final correctWord = allWords.first;
  final String correctVocab = correctWord['vocab'];
  final String correctCategory = identifyThaiCategory(
    processThaiWordEnding(correctVocab),
  );

  options.add(
    Options(optionTEXT: correctVocab, isCorrect: true), // เพิ่มคำที่ถูกต้อง
  );
  usedCategories.add(correctCategory); // เก็บมาตราตัวสะกดของคำที่ถูกต้อง

  // สร้างตัวเลือกผิด (3 ตัว)
  for (var word in allWords.skip(1)) {
    final String currentVocab = word['vocab'];
    final String currentCategory = identifyThaiCategory(
      processThaiWordEnding(currentVocab),
    );

    // ตรวจสอบว่ามาตราตัวสะกดไม่ซ้ำกับคำที่ถูกต้อง
    if (!usedCategories.contains(currentCategory)) {
      options.add(
        Options(optionTEXT: currentVocab, isCorrect: false),
      );
      usedCategories.add(currentCategory); // เก็บมาตราตัวสะกดใหม่

      // หยุดเมื่อได้ตัวเลือกครบ 4 ตัว
      if (options.length == 4) break;
    }
  }

  // เติมตัวเลือกผิดเพิ่มเติมหากไม่ครบ 4 ตัว
  while (options.length < 4) {
    options.add(
      Options(optionTEXT: 'คำตอบเพิ่มเติม ${options.length + 1}', isCorrect: false),
    );
  }

  options.shuffle(); // สลับลำดับตัวเลือก
  return options;
}

// Future<List<Options>> _createContrastingOptions(int gradeID) async {
//   // ดึงคำทั้งหมดจากฐานข้อมูล
//   final List<Map<String, dynamic>> allWords = await database.query(
//     'Vocabulary',
//     where: 'gradeID = ?',
//     whereArgs: [gradeID],
//     orderBy: 'RANDOM()', // สุ่มคำ
//   );

//   if (allWords.isEmpty) {
//     throw Exception('ไม่พบคำในฐานข้อมูล');
//   }

//   Map<String, List<String>> categorizedWords = {}; // เก็บคำแยกตามมาตราตัวสะกด

//   // แยกคำตามมาตราตัวสะกด
//   for (var word in allWords) {
//     final String vocab = word['vocab'];
//     final String category = identifyThaiCategory(
//       processThaiWordEnding(vocab),
//     );

//     if (!categorizedWords.containsKey(category)) {
//       categorizedWords[category] = [];
//     }
//     categorizedWords[category]?.add(vocab);
//   }

//   // เลือกมาตราตัวสะกดสำหรับตัวเลือกผิด
//   final List<String> allCategories = categorizedWords.keys.toList();
//   if (allCategories.length < 2) {
//     throw Exception('ไม่สามารถสร้างตัวเลือกได้: จำนวนมาตราตัวสะกดไม่เพียงพอ');
//   }

//   final String wrongCategory = allCategories.first; // เลือกมาตราตัวสะกดสำหรับตัวเลือกผิด
//   final String correctCategory =
//       allCategories.firstWhere((cat) => cat != wrongCategory);

//   // ตัวเลือกผิด: เลือก 3 คำจากมาตราตัวสะกดเดียวกัน
//   final List<String> wrongWords = (categorizedWords[wrongCategory] ?? [])
//       .take(3)
//       .toList();

//   if (wrongWords.length < 3) {
//     throw Exception('ไม่สามารถสร้างตัวเลือกผิดได้: จำนวนคำในมาตราตัวสะกดไม่เพียงพอ');
//   }

//   // ตัวเลือกถูก: เลือก 1 คำจากมาตราตัวสะกดที่แตกต่าง
//   final List<String> correctWords = categorizedWords[correctCategory] ?? [];
//   if (correctWords.isEmpty) {
//     throw Exception('ไม่สามารถสร้างตัวเลือกถูกได้: ไม่มีคำในมาตราตัวสะกดที่แตกต่าง');
//   }
//   final String correctWord = correctWords.first;

//   // รวมตัวเลือกและสลับลำดับ
//   List<Options> options = [
//     Options(optionTEXT: correctWord, isCorrect: true),
//     ...wrongWords.map((word) => Options(optionTEXT: word, isCorrect: false)),
//   ];

//   options.shuffle(); // สลับลำดับตัวเลือก
//   return options;
// }

Future<List<Options>> _createMatraOptions(Vocabulary word, int gradeID) async {
  final lastConsonant = processThaiWordEnding(word.vocab);
  print(lastConsonant);
  final correctCategory = identifyThaiCategory(lastConsonant);
  print(correctCategory);

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