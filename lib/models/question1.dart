import 'package:flutter_application_0/models/questionModel.dart';
import 'package:flutter_application_0/models/wordModel.dart';

class Question1 {
  final int modelnum; // หมายเลขคำถาม
  final Vocabulary modelWord; // โมเดลคำศัพท์
  final String modelMatra; // มาตราหรือหมวดหมู่
  final QuestionModels modelQuestion; // โมเดลคำถาม
  final List<Options> options; // ตัวเลือกคำตอบ

  Question1({
    required this.modelnum,
    required this.modelWord,
    required this.modelMatra,
    required this.modelQuestion,
    required this.options,
  });

  factory Question1.fromMap(Map<String, dynamic> map) {
    return Question1(
      modelnum: map['modelnum'],
      modelWord: Vocabulary.fromMap(map['modelWord']),
      modelMatra: map['modelMatra'],
      modelQuestion: QuestionModels.fromMap(map['modelQuestion']),
      options: List<Options>.from(
        map['options'].map((option) => Options.fromMap(option)),
      ),
    );
  }
} 




class Options {
  final String optionTEXT;
  final bool isCorrect;

  Options({
    required this.optionTEXT,
    required this.isCorrect,
  });

  factory Options.fromMap(Map<String, dynamic> map) {
    return Options(
      optionTEXT: map['optionTEXT'],
      isCorrect: map['isCorrect'],
    );
  }
}
