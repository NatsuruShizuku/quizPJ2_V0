
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
  //new code
String getMatraTextFromID(int matraID) {
  return matras.firstWhere(
    (m) => m.matraID == matraID,
    orElse: () => Matra(matraID: matraID, matraText: ''),
  ).matraText;
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
  final random = Random();
  if (question.questionID == 2) {
    // สำหรับ QID 2: คำตอบที่ถูกต้องต้องมาจากคำศัพท์ที่มี matraText เดียวกับ vocabulary แต่ไม่ใช่คำเดิม
    List<Vocabulary> sameMatraWords = vocabularies
        .where((v) => v.matraText == vocabulary.matraText && v.vocabID != vocabulary.vocabID)
        .toList();
    return sameMatraWords.isNotEmpty 
      ? sameMatraWords[random.nextInt(sameMatraWords.length)].vocab 
      : vocabulary.vocab;
  } else if (question.questionID == 4) {
    // สำหรับ QID 4: คำตอบที่ถูกต้องต้องมาจากคำศัพท์ที่มี matraText ต่างจาก vocabulary
    List<Vocabulary> differentMatraWords = vocabularies
        .where((v) => v.matraText != vocabulary.matraText)
        .toList();
    return differentMatraWords.isNotEmpty 
      ? differentMatraWords[random.nextInt(differentMatraWords.length)].vocab 
      : vocabulary.vocab;
  } else if (question.questionID == 5) {
    Vocabulary? partner;
    for (var word in vocabularies) {
      if (word.vocabID != vocabulary.vocabID && word.matraText == vocabulary.matraText) {
        partner = word;
        break;
      }
    }
    partner ??= vocabulary;
    return "${vocabulary.vocab} ${partner.vocab}";
  }
  return question.answerType == AnswerType.matraText 
      ? vocabulary.matraText 
      : vocabulary.vocab;
}


// --- ฟังก์ชันสร้างตัวเลือก (options) ---
List<String> _generateOptions(QuestionM question, Vocabulary vocabulary, String correctAnswer) {
  final random = Random();
  
  if (question.questionID == 2) {
    // QID 2: 
    // - ตัวเลือกที่ถูกต้องต้องมาจากคำศัพท์ที่มี matraText เดียวกับ vocabulary แต่ไม่ใช่คำเดิม
    List<Vocabulary> sameMatraWords = vocabularies
        .where((v) => v.matraText == vocabulary.matraText && v.vocabID != vocabulary.vocabID)
        .toList();
    // String correct = sameMatraWords.isNotEmpty 
    //     ? sameMatraWords[random.nextInt(sameMatraWords.length)].vocab 
    //     : vocabulary.vocab;
     String correct = correctAnswer;
    // - ตัวเลือกที่ผิดต้องมาจากคำศัพท์ที่มี matraText ต่างจาก vocabulary
    List<String> wrongOptions = vocabularies
        .where((v) => v.matraText != vocabulary.matraText)
        .map((v) => v.vocab)
        .toSet()
        .toList();
    wrongOptions.shuffle();
    
    List<String> options = [correct];
    for (String option in wrongOptions) {
      if (options.length >= 4) break;
      if (!options.contains(option)) {
        options.add(option);
      }
    }
    options.shuffle();
    return options;
    
  } else if (question.questionID == 4) {
    // QID 4:
    // - ตัวเลือกที่ผิดต้องมาจากคำศัพท์ที่มี matraText เดียวกับ vocabulary 
    //   แต่ให้ตัดคำศัพท์ที่อยู่ในคำถาม (vocabulary) ออกไป
    List<String> wrongOptions = vocabularies
        .where((w) => w.matraText == vocabulary.matraText && w.vocabID != vocabulary.vocabID)
        .map((w) => w.vocab)
        .toSet()
        .toList();
    wrongOptions.shuffle();
    wrongOptions = wrongOptions.take(3).toList();
    
    String correct = correctAnswer;
    List<String> options = [correct, ...wrongOptions];
    options.shuffle();
    return options;
    
  } else if (question.questionID == 5) {
    // สำหรับ QID 5 (คู่คำศัพท์)
    List<String> options = [correctAnswer];
    Set<String> usedOptions = {correctAnswer};
    while (options.length < 4) {
      Vocabulary word1 = vocabularies[random.nextInt(vocabularies.length)];
      Vocabulary word2 = vocabularies[random.nextInt(vocabularies.length)];
      if (word1.matraText == word2.matraText && word1.matraID == word2.matraID) continue;
      String option = "${word1.vocab} ${word2.vocab}";
      if (!usedOptions.contains(option)) {
        options.add(option);
        usedOptions.add(option);
      }
    }
    options.shuffle();
    return options..shuffle();
    
  } else if (question.questionID == 6) {
    // QID 6: (ส่วนนี้ไม่เปลี่ยนแปลง)
    final answerType = question.answerType;
    String currentCorrect = (answerType == AnswerType.matraText) ? vocabulary.matraText : vocabulary.vocab;
    List<String> candidateMatraTexts = vocabularies
        .map((w) => w.matraText)
        .where((mt) => mt != vocabulary.matraText)
        .toSet()
        .toList();
    if (candidateMatraTexts.isEmpty) {
      candidateMatraTexts = ['default'];
    }
    String wrongMatra = candidateMatraTexts[random.nextInt(candidateMatraTexts.length)];
    List<String> wrongOptions = vocabularies
        .where((w) => w.matraText == wrongMatra)
        .map((w) => (answerType == AnswerType.matraText) ? w.matraText : w.vocab)
        .toSet()
        .toList();
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
    List<String> options = [currentCorrect];
    options.shuffle();
    options.addAll(finalWrongOptions);
    return options;
    
  } else {
    // Default case (ตัวเลือกผิดต้องมีมาตราตัวสะกดต่างจากคำตอบที่ถูก)
    String correctMatra = (question.answerType == AnswerType.matraText)
        ? correctAnswer
        : vocabulary.matraText;
    Set<int> usedVocabIds = {vocabulary.vocabID};
    List<String> options = [correctAnswer];
    while (options.length < 4) {
      Vocabulary word = vocabularies[random.nextInt(vocabularies.length)];
      if (usedVocabIds.contains(word.vocabID)) continue;
      if (word.matraText == correctMatra) continue;
      String value = (question.answerType == AnswerType.matraText)
          ? word.matraText
          : word.vocab;
      if (!options.contains(value)) {
        options.add(value);
        usedVocabIds.add(word.vocabID);
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

  AnswerType get answerType {
  if (currentQuestionM == null) return AnswerType.vocab;
  switch (currentQuestionM!.questionID) {
    case 2:
    case 3:
    case 4:
    case 6:  return AnswerType.matraText;
    case 5:  return AnswerType.vocab;
    default: return AnswerType.vocab;
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
