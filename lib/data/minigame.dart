import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/screens/quiz_game.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_0/database/database_helper.dart';
import 'package:flutter_application_0/models/dataModel.dart';

class MiniGame extends StatefulWidget {
  final int fcID;

  const MiniGame({Key? key, required this.fcID}) : super(key: key);

  @override
  _MiniGameState createState() => _MiniGameState();
}

class _MiniGameState extends State<MiniGame> {
  int currentQuestionIndex = 0;
  int score = 0;
  String? selectedAnswer;
  bool showFeedback = false;

  List<Vocabulary> vocabularies = [];
  List<QuestionM> questions = [];
  List<FinalConsonants> fcList = [];
  List<Vocabulary> fullVocabularies = [];

  @override
  void initState() {
    super.initState();
    if (widget.fcID != 0) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final vocab = await DatabaseHelper.getVocabularies();
    final questions = await DatabaseHelper.getQuestions();
    final fc = await DatabaseHelper.getFinalConsonants();
    final allQuestions = await DatabaseHelper.getQuestions();

    final filteredVocab = vocab.where((v) => v.fcID == widget.fcID).toList();
    final filteredQuestions = allQuestions
        .where((q) => q.questionID == 3)
        .toList();

    setState(() {
      vocabularies = filteredVocab;
      fullVocabularies = vocab;
      this.questions = filteredQuestions;
      fcList = fc;
    });

    if (filteredVocab.isNotEmpty && filteredQuestions.isNotEmpty) {
      generateNewQuestion();
    }
  }

  void checkAnswer(String answer) {
    if (vocabularies.isEmpty) return;

    setState(() {
      selectedAnswer = answer;
      showFeedback = true;
      if (answer == currentQuestion?.correctAnswer) {
        score += 10;
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showFeedback = false;
        selectedAnswer = null;
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
        } else {
          currentQuestionIndex = 0;
        }
        generateNewQuestion();
      });
    });
  }

  QuizQuestion? currentQuestion;

  void generateNewQuestion() {
    if (vocabularies.isEmpty || questions.isEmpty) return;

    final random = Random();
    final question = questions[random.nextInt(questions.length)];
    Vocabulary vocabulary;
    Vocabulary? partner;


    vocabulary = vocabularies[random.nextInt(vocabularies.length)];
    partner = _getPartnerWord(vocabulary.vocabID);

    final questionText =
        question.generateQuestionText(vocabulary, partner);
    final correctAnswer = vocabulary.vocab;
    final options = _generateOptions(question, vocabulary, correctAnswer);

    setState(() {
      currentQuestion = QuizQuestion(
        text: questionText,
        correctAnswer: correctAnswer,
        options: options,
      );
    });
  }

  List<String> _generateOptions(
      QuestionM question, Vocabulary vocabulary, String correctAnswer) {
    final random = Random();
    Set<String> options = {correctAnswer};

      // ตัวเลือกผิดจาก fcID อื่น
      List<Vocabulary> differentFC = fullVocabularies
          .where((v) => v.fcID != widget.fcID && v.vocab != correctAnswer)
          .toList();
      while (options.length < 3 && differentFC.isNotEmpty) {
        final wrong =
            differentFC.removeAt(random.nextInt(differentFC.length)).vocab;
        options.add(wrong);
      }

    while (options.length < 3) {
      final randomWord =
          fullVocabularies[random.nextInt(fullVocabularies.length)].vocab;
      // ตรวจสอบว่าไม่ใช่คำตอบที่ถูก และไม่ใช่คำจาก fcID เดียวกัน (เพื่อคงเงื่อนไขคำตอบถูกต้อง)
      if (randomWord != correctAnswer &&
          fullVocabularies.firstWhere((v) => v.vocab == randomWord).fcID !=
              widget.fcID) {
        options.add(randomWord);
      }
    }
    return options.toList()..shuffle();
  }

  Vocabulary _getPartnerWord(int excludeId) {
    final random = Random();
    Vocabulary partner;
    do {
      partner = vocabularies[random.nextInt(vocabularies.length)];
    } while (partner.vocabID == excludeId);
    return partner;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fcID == 0) {
      return SizedBox.shrink();
    }

    if (vocabularies.isEmpty || questions.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(
                currentQuestion?.text ?? 'กำลังโหลด...',
                style: GoogleFonts.chakraPetch(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5),
              ...(currentQuestion?.options.map((option) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedAnswer == option
                                ? (option == currentQuestion?.correctAnswer
                                    ? Colors.green.shade300
                                    : Colors.red.shade300)
                                : Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed:
                              showFeedback ? null : () => checkAnswer(option),
                          child: Text(
                            option,
                            style: GoogleFonts.chakraPetch(
                              fontSize: 18,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      )) ??
                  []),
              if (showFeedback)
                Text(
                  selectedAnswer == currentQuestion?.correctAnswer
                      ? '✓ ถูกต้องครับ!'
                      : '✗ ยังไม่ถูกนะ! คำตอบที่ถูกคือ: ${currentQuestion?.correctAnswer}',
                  style: GoogleFonts.chakraPetch(
                      fontSize: 18,
                      color: selectedAnswer == currentQuestion?.correctAnswer
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                      fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class QuizQuestion {
  final String text;
  final String correctAnswer;
  final List<String> options;

  QuizQuestion({
    required this.text,
    required this.correctAnswer,
    required this.options,
  });
}
