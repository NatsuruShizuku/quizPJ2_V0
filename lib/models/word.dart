import '../const/const.dart';

class Word {
  int vocabID = 0;
  int syllable = 1;
  String vocab = "";
  int gradeID = 1;


  Word();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      vocabID.toString(): vocabID,
      syllableQuiz: syllable,
      vocabQuiz: vocab,
      gradeID.toString(): gradeID,
    };
  }

  Word.fromMap(Map<String, dynamic> map) {
    vocabID = map[vocabID];
    syllable = map[syllableQuiz];
    vocab = map[vocabQuiz];
    gradeID = map[gradeID.toString()];
  }
}
