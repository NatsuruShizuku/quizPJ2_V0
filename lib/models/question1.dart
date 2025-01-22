class Question1 {
  final int model_num;
  final String setQuestion;
  final String wordQuestion;
  final List<Options> options;
  final String endingSound;

  Question1( {
    required this.model_num, // เลขโมเดล
    required this.setQuestion,
    required this.wordQuestion, //Textคำถาม
    required this.options, //
    required this.endingSound,
  });
}

class Options {
  final String optionTEXT;
  final bool isCorrect;

  Options({
    required this.optionTEXT,
    required this.isCorrect,
  });
}
