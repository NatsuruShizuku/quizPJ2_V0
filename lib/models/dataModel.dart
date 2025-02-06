import 'package:flutter_application_0/screens/quiz_game.dart';

class Matra {
  final int matraID;
  final String matraText;

  Matra({required this.matraID, required this.matraText});
}

//old ver
// class QuestionM {
//   final int questionID;
//   final String questionText;

//   QuestionM({required this.questionID, required this.questionText});
  
//   // เพิ่มเมธอดเพื่อสร้างคำถามตามรูปแบบ
//   String generateQuestionText(Map<String, dynamic> data) {
//     switch (questionID) {
//       case 1:
//         return "${data['vocab']} $questionText?";
//       case 2:
//         return "$questionText ${data['randomWord']}?";
//       case 3:
//       case 4:
//         return "$questionText ${data['matraText']}?";
//       case 5:
//       case 6:
//         return "$questionText?";
//       default:
//         return questionText;
//     }
//   }
// }
class QuestionM {
  final int questionID;
  final String questionText;

  QuestionM({required this.questionID, required this.questionText});

  AnswerType get answerType {
    switch (questionID) {
      case 1:
        return AnswerType.matraText;
      default:
        return AnswerType.vocab;
    }
  }

  String generateQuestionText(Vocabulary vocabulary, Vocabulary randomWord) {
    switch (questionID) {
      case 1:
        return "${vocabulary.vocab} $questionText?";
      case 2:
        return "$questionText ${vocabulary.vocab}?";
      case 3:
        return "$questionText ${vocabulary.matraText}?";
      case 4:
        return "$questionText ${vocabulary.matraText}?";
      case 5:
      case 6:
        return "$questionText?";
      default:
        return questionText;
    }
  }
}

class Vocabulary {
  final int vocabID;
  final int syllable;
  final String vocab;
  final String matraText;

  Vocabulary({
    required this.vocabID,
    required this.syllable,
    required this.vocab,
    required this.matraText,
  });

  static fromMap(map) {}
}