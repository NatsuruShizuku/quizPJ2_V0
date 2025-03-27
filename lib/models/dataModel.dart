import 'package:flutter_application_0/screens/quiz_game.dart';

class FinalConsonants {
  final int fcID;
  final String fcText;

  FinalConsonants({required this.fcID, required this.fcText});
}

class QuestionM {
  final int questionID;
  final String questionText;

  QuestionM({required this.questionID, required this.questionText});

  AnswerType get answerType {
    switch (questionID) {
      case 1:
        return AnswerType.fcText;
      default:
        return AnswerType.vocab;
    }
  }

  String generateQuestionText(Vocabulary vocabulary, Vocabulary randomWord) {
    switch (questionID) {
      case 1:
        return "''${vocabulary.vocab}''  $questionText?";
      case 2:
        return "$questionText  ''${vocabulary.vocab}?''";
      case 3:
        return "$questionText  ''${vocabulary.fcText}?''";
      case 4:
        return "$questionText  ''${vocabulary.fcText}?''";
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
  final String fcText;
  final int fcID;
  final int modeID;

  Vocabulary({
    required this.vocabID,
    required this.syllable,
    required this.vocab,
    required this.fcText,
    required this.fcID, 
    required this.modeID,
  });

}


class HighScore {
  final String mode;
  final String name;
  final int score;
  final DateTime timeStamp;

  HighScore({
    required this.mode,
    required this.name,
    required this.score,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'mode': mode,
      'name': name,
      'score': score,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }

  factory HighScore.fromMap(Map<String, dynamic> map) {
    return HighScore(
      mode: map['mode'] ?? '',
      name: map['name'] ?? '',
      score: map['score'] ?? 0,
      timeStamp: DateTime.parse(map['timeStamp']),
    );
  }
}