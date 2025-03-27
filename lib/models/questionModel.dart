class QuestionModels {
  final int questionID;
  final String questionTEXT;
  

  QuestionModels( {
    required this.questionID, 
    required this.questionTEXT,
  });

  factory QuestionModels.fromMap(Map<String, dynamic> map) {
    return QuestionModels(
      questionID: map['questionID'],
      questionTEXT: map['questionTEXT'],
    );
  }
}

