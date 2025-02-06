import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/database/database_helper.dart';
import 'package:flutter_application_0/models/dataModel.dart';
import 'package:flutter_application_0/screens/gamesummary.dart'; // import GameSummaryScreen

class QuizGame extends StatefulWidget {
  @override
  _QuizGameState createState() => _QuizGameState();
}

enum AnswerType { matraText, vocab }

class _QuizGameState extends State<QuizGame> {
  List<QuestionM> questions = [];
  List<Vocabulary> vocabularies = [];
  List<Matra> matras = [];
  int score = 0;
  int consecutiveWrong = 0;
  int remainingTime = 180;
  int totalQuestions = 0; // นับจำนวนคำถามที่ตอบไปแล้ว
  Timer? timer;
  QuizQuestion? currentQuestion;
  QuestionM? currentQuestionM; // เก็บข้อมูล QuestionM ของคำถามปัจจุบัน
  bool showFeedback = false;
  String? selectedAnswer;
  bool isCorrect = false;
  Timer? feedbackTimer;
  bool isProcessingAnswer = false;
  int lives = 3;
  int timeElapsed = 0;
  late Vocabulary vocabulary;
  late Vocabulary partner;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  Future<void> initializeGame() async {
    final questions = await DatabaseHelper.getQuestions();
    final vocabularies = await DatabaseHelper.getVocabularies();
    final matras = await DatabaseHelper.getMatras();

    setState(() {
      this.questions = questions;
      this.vocabularies = vocabularies;
      this.matras = matras;
    });

    startGame();
  }

  // เริ่มเกมใหม่
  void startGame() {
    timer?.cancel();
    feedbackTimer?.cancel();

    setState(() {
      score = 0;
      consecutiveWrong = 0;
      totalQuestions = 0;
      remainingTime = 180;
      showFeedback = false;
      selectedAnswer = null;
      isCorrect = false;
      isProcessingAnswer = false;
    });

    generateNewQuestion();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() => remainingTime--);
      } else {
        timer.cancel();
        endGame(); // หมดเวลา
      }
    });
  }

  void generateNewQuestion() {
    final random = Random();
    final question = questions[random.nextInt(questions.length)];
    final vocabulary = vocabularies[random.nextInt(vocabularies.length)];
    Vocabulary randomWord = _getRandomWord(vocabulary.vocabID);

    final questionText = question.generateQuestionText(vocabulary, randomWord);
    final correctAnswer = _getCorrectAnswer(question, vocabulary);
    final options = _generateOptions(question, vocabulary, correctAnswer);

    setState(() {
      currentQuestion = QuizQuestion(
        text: questionText,
        correctAnswer: correctAnswer,
        options: options,
      );
      currentQuestionM = question; // เก็บข้อมูลคำถามจริงไว้ที่นี่
    });
  }

  String _getCorrectAnswer(QuestionM question, Vocabulary vocabulary) {
    switch (question.answerType) {
      case AnswerType.matraText:
        return vocabulary.matraText;
      case AnswerType.vocab:
        return vocabulary.vocab;
    }
  }

  // List<String> _generateOptions(QuestionM question, Vocabulary vocabulary, String correctAnswer) {
  //   final usedIds = {vocabulary.vocabID};
  //   final options = <String>[correctAnswer];
  //   final answerType = question.answerType;

  //   while (options.length < 4) {
  //     final randomWord = vocabularies[Random().nextInt(vocabularies.length)];
  //     if (!usedIds.contains(randomWord.vocabID)) {
  //       usedIds.add(randomWord.vocabID);
  //       final value = answerType == AnswerType.matraText
  //           ? randomWord.matraText
  //           : randomWord.vocab;
  //       if (!options.contains(value)) {
  //         options.add(value);
  //       }
  //     }
  //   }

  //   return options..shuffle();
  // }

List<String> _generateOptions(QuestionM question, Vocabulary vocabulary, String correctAnswer) {
 if (question.questionID == 5) {
  List<String> options = [];

  // --- สร้างตัวเลือกที่ถูกต้อง ---
  Vocabulary? partner;
  for (var word in vocabularies) {
    if (word.vocabID != vocabulary.vocabID && word.matraText == vocabulary.matraText) {
      partner = word;
      break;
    }
  }
  partner ??= vocabulary;
  String correctOption = "${vocabulary.vocab} ${partner.vocab}";
  options.add(correctOption);
  List<Widget> buildOptions(List<String> options) {
  return options.map((option) {
    return ElevatedButton(
      onPressed: () {
        checkAnswer(option); // ส่งตัวเลือกที่ผู้ใช้เลือกไปตรวจสอบ
      },
      child: Text(
        option,
        style: TextStyle(fontSize: 18),
      ),
    );
  }).toList();
}


  // --- สร้างตัวเลือกที่ผิด ---
  Set<String> usedOptions = {correctOption};
  while (options.length < 4) {
    Vocabulary word1 = vocabularies[Random().nextInt(vocabularies.length)];
    Vocabulary word2 = vocabularies[Random().nextInt(vocabularies.length)];
    if (word1.vocabID == word2.vocabID) continue;
    if (word1.matraText == word2.matraText) continue;
    String optionStr = "${word1.vocab} ${word2.vocab}";
    if (usedOptions.contains(optionStr)) continue;
    options.add(optionStr);
    usedOptions.add(optionStr);
  }
  

  options.shuffle();
  return options;
}

 else if (question.questionID == 6) {
  final answerType = question.answerType;
  
  // correct answer: เลือกจากคำที่สุ่มมา (vocabulary)
  // โดยต้องใช้ค่าที่แสดงออกมาตาม answerType
  String currentCorrect = (answerType == AnswerType.matraText) ? vocabulary.matraText : vocabulary.vocab;
  
  // สำหรับตัวเลือกที่ผิด เราต้องการให้คำทั้งหมดมี matraText เดียวกัน
  // และต้องแน่ใจว่า matraText ของตัวเลือกที่ผิด (wrongMatra) ไม่ตรงกับ matraText ของคำที่ถูก (vocabulary)
  
  // สร้างชุด candidate matraText ที่ไม่เท่ากับ vocabulary.matraText
  List<String> candidateMatraTexts = vocabularies
      .map((w) => w.matraText)
      .where((mt) => mt != vocabulary.matraText)
      .toSet()
      .toList();
  if (candidateMatraTexts.isEmpty) {
    // กรณีไม่มี candidate ให้ใช้ค่าเริ่มต้น (ไม่ควรเกิดขึ้นถ้าข้อมูลครบ)
    candidateMatraTexts = ['default'];
  }
  // เลือก candidate หนึ่งแบบสุ่มเพื่อเป็น wrongMatra
  String wrongMatra = candidateMatraTexts[Random().nextInt(candidateMatraTexts.length)];
  
  // เก็บคำจาก vocabularies ที่มี matraText ตรงกับ wrongMatra
  List<String> wrongOptions = vocabularies
      .where((w) => w.matraText == wrongMatra)
      .map((w) => (answerType == AnswerType.matraText) ? w.matraText : w.vocab)
      .toSet()
      .toList();
  
  // หากคำที่ได้มีไม่ถึง 3 ตัว เลือก candidate อื่นเพิ่มเติม
  if (wrongOptions.length < 3) {
    for (String candidate in candidateMatraTexts) {
      wrongMatra = candidate;
      wrongOptions = vocabularies
          .where((w) => w.matraText == candidate)
          .map((w) => (answerType == AnswerType.matraText) ? w.matraText : w.vocab)
          .toSet()
          .toList();
      if (wrongOptions.length >= 3) break;
    }
  }
  wrongOptions.shuffle();
  List<String> finalWrongOptions = wrongOptions.take(3).toList();

  // สร้าง options list โดยผสมตัวเลือกที่ถูกและตัวเลือกที่ผิด
  List<String> options = [currentCorrect];
  options.addAll(finalWrongOptions);
  return options..shuffle();
}
else if (question.questionID == 4) {
  final answerType = question.answerType;

  // ตัวเลือกที่ผิดทั้ง 3 ตัว ต้องมาจากคำที่มี matraText เดียวกันกับคำถาม (vocabulary.matraText)
  List<String> wrongOptions = vocabularies
      .where((w) => w.matraText == vocabulary.matraText)
      .map((w) => (answerType == AnswerType.matraText) ? w.matraText : w.vocab)
      .toSet()
      .toList();
  wrongOptions.shuffle();
  List<String> finalWrongOptions = wrongOptions.take(3).toList();

  // ตัวเลือกที่ถูกต้อง ต้องมาจากคำที่มี matraText ต่างจาก vocabulary.matraText
  List<String> candidateCorrects = vocabularies
      .where((w) => w.matraText != vocabulary.matraText)
      .map((w) => (answerType == AnswerType.matraText) ? w.matraText : w.vocab)
      .toSet()
      .toList();
  candidateCorrects.shuffle();
  String correctOption = candidateCorrects.first;

  // สร้าง options list และสับลำดับ
  List<String> options = [correctOption];
  options.addAll(finalWrongOptions);
  return options..shuffle();
}

  else {

    int requiredOptionsCount = 4;
    final usedIds = {vocabulary.vocabID};
    final options = <String>[correctAnswer];
    final answerType = question.answerType;

    while (options.length < requiredOptionsCount) {
      final randomWord = vocabularies[Random().nextInt(vocabularies.length)];
      if (usedIds.contains(randomWord.vocabID)) continue;
      // สำหรับ AnswerType.matraText ไม่สุ่มคำที่มี matraText ตรงกับ vocabulary.matraText
      if (answerType == AnswerType.matraText && randomWord.matraText == vocabulary.matraText) {
        continue;
      }
      usedIds.add(randomWord.vocabID);
      final value = answerType == AnswerType.matraText ? randomWord.matraText : randomWord.vocab;
      if (!options.contains(value)) {
        options.add(value);
      }
    }
    return options..shuffle();
  }
}


  Vocabulary _getRandomWord(int excludeId) {
    final random = Random();
    Vocabulary randomWord;
    do {
      randomWord = vocabularies[random.nextInt(vocabularies.length)];
    } while (randomWord.vocabID == excludeId);
    return randomWord;
  }

  // getter answerType ที่ใช้อ้างอิงจาก currentQuestionM
  AnswerType get answerType {
    if (currentQuestionM == null) return AnswerType.vocab;
    switch (currentQuestionM!.questionID) {
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
        return AnswerType.matraText;
      default:
        return AnswerType.vocab;
    }
  }

  // เมื่อผู้เล่นตอบคำถาม
  void handleAnswer(String selectedOption) {
    if (isProcessingAnswer || currentQuestion == null) return;

    setState(() {
      isProcessingAnswer = true;
      selectedAnswer = selectedOption;
      isCorrect = selectedOption == currentQuestion!.correctAnswer;
      showFeedback = true;
      totalQuestions++; // เพิ่มจำนวนคำถามที่ตอบไปแล้ว
    });

    // อัพเดทคะแนนและจำนวนผิดติดต่อกัน
    if (isCorrect) {
      score++;
      consecutiveWrong = 0;
    } else {
      consecutiveWrong++;
    }

    feedbackTimer = Timer(Duration(seconds: 2), () {
      setState(() {
        showFeedback = false;
        selectedAnswer = null;
        isProcessingAnswer = false;
      });

      // จบเกมเมื่อหมดเวลา หรือถ้าตอบผิดครบ 3 ครั้ง
      if (remainingTime <= 0 || consecutiveWrong >= 3) {
        endGame();
      } else {
        generateNewQuestion();
      }
    });
  }

  // เมื่อเกมจบ ให้ไปที่หน้าสรุปคะแนน
  void endGame() {
    timer?.cancel();
    feedbackTimer?.cancel();
    // คำนวณเวลาเล่นไป (เริ่มที่ 180 วินาที ลบด้วย remainingTime)
    final int timeElapsed = 180 - remainingTime;

    // ใช้ Navigator.pushReplacement เพื่อแทนที่หน้าจอเกมด้วยหน้าสรุปคะแนน
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameSummaryScreen(
          score: score,
          totalQuestions: totalQuestions,
          timeElapsed: timeElapsed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เกมทายมาตราตัวสะกด',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[800]!, Colors.blue[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: startGame,
            tooltip: 'เริ่มเกมใหม่',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildGameHeader(),
            _buildQuestionCard(),
            _buildOptionsGrid(),
            if (showFeedback) _buildFeedbackBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoCard(
            Icons.timer,
            'เวลาเหลือ',
            '${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}',
            Colors.blue,
          ),
          _buildInfoCard(Icons.star, 'คะแนน', '$score', Colors.orange),
          _buildInfoCard(Icons.close, 'ผิดติดกัน', '${consecutiveWrong}/3', Colors.red),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontFamily: 'Kanit', color: Colors.grey[600])),
          Text(value, style: TextStyle(fontFamily: 'Kanit', fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        currentQuestion?.text ?? 'กำลังโหลด...',
        style: TextStyle(
          fontFamily: 'Kanit',
          fontSize: 22,
          color: Colors.blue[900],
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionsGrid() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          padding: EdgeInsets.only(bottom: 20),
          children: currentQuestion?.options
                  .map((option) => _buildOptionButton(option))
                  .toList() ??
              [],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    final bool isSelected = selectedAnswer == option;
    final bool isCorrectAnswer = option == currentQuestion?.correctAnswer;

    Color buttonColor = Colors.white;
    if (showFeedback) {
      if (isCorrectAnswer) {
        buttonColor = Colors.green[100]!;
      } else if (isSelected) {
        buttonColor = Colors.red[100]!;
      }
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: showFeedback && isCorrectAnswer ? Colors.green : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          if (!isProcessingAnswer && !showFeedback)
            BoxShadow(
              color: Colors.blue[100]!,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: isProcessingAnswer ? null : () => handleAnswer(option),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 20,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (showFeedback && isSelected)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackBanner() {
    return Material(
      color: isCorrect ? Colors.green : Colors.red,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCorrect ? Icons.check : Icons.close,
              color: Colors.white,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              isCorrect
                  ? 'เยี่ยมมาก! คำตอบถูกต้อง'
                  : 'เสียใจด้วย! คำตอบที่ถูกคือ ${currentQuestion?.correctAnswer}',
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void checkAnswer(String selectedAnswer) {
  // คำตอบที่ถูกต้อง
  String correctAnswer = "${vocabulary.vocab} ${partner.vocab}";
  
  // ตรวจสอบคำตอบ
  if (validateAnswer(selectedAnswer, correctAnswer)) {
    // ตอบถูก
    setState(() {
      score += 1;
    });
  } else {
    // ตอบผิด
    setState(() {
      lives -= 1;
      if (lives == 0) {
        // แสดงหน้าสรุปคะแนน
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameSummaryScreen(
              score: score,
              totalQuestions: totalQuestions,
              timeElapsed: timeElapsed,
            ),
          ),
        );
      }
    });
  }
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
bool validateAnswer(String selectedAnswer, String correctAnswer) {
  return selectedAnswer.trim() == correctAnswer.trim();
}
