import 'package:flutter_application_0/screens/quiz_game.dart';

class Matra {
  final int matraID;
  final String matraText;

  Matra({required this.matraID, required this.matraText});
}

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
  final int matraID;

  Vocabulary({
    required this.vocabID,
    required this.syllable,
    required this.vocab,
    required this.matraText,
    required this.matraID,
  });

}

class HighScore {
  final int scoreID;
  final String mode;
  final String name;
  final int score;
  final DateTime timeStamp;

  HighScore({
    this.scoreID = 0,
    required this.mode,
    required this.name,
    required this.score,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'scoreID': scoreID,
      'mode': mode,
      'name': name,
      'score': score,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }

  factory HighScore.fromMap(Map<String, dynamic> map) {
    return HighScore(
      scoreID: map['scoreID'],
      mode: map['mode'],
      name: map['name'],
      score: map['score'],
      timeStamp: DateTime.parse(map['timeStamp']),
    );
  }
}