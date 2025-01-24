class Vocabulary {
  final int vocabID;
  final int syllable;
  final String vocab;
  final int gradeID;
 
  Vocabulary( {
    required this.vocabID,
    required this.syllable,
    required this.vocab,
    required this.gradeID,
  });

  factory Vocabulary.fromMap(Map<String, dynamic> map) {
    return Vocabulary(
      vocabID: map['vocabID'],
      syllable: map['syllable'],
      vocab: map['vocab'],
      gradeID: map['gradeID'],
    );
  }
}


