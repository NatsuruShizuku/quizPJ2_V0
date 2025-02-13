import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/database/database_helper.dart';
import 'package:flutter_application_0/models/dataModel.dart';
import 'package:flutter_application_0/screens/gamesummary.dart';
import 'package:shared_preferences/shared_preferences.dart'; // import GameSummaryScreen

class QuizGame extends StatefulWidget {
  final String mode;

  const QuizGame({required this.mode});

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
  int totalTime = 180;
  bool showPopup = true; // ค่าตั้งต้นให้แสดง Popup
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPaused = false;
  int timeLeft = 60; // เวลาที่เหลือในวินาที
  bool isMusicOn = true; // ควบคุมสถานะเพลงประกอบ

  @override
  void initState() {
    super.initState();
    initializeGame();
    _checkPopupPreference();
  }

  void _pauseGame() {
    setState(() {
      isPaused = true;
    });

    // แสดง Popup
    showPauseDialog();
  }

  void _resumeGame() {
    setState(() {
      isPaused = false;
    });
  }

  void _restartGame() {
    setState(() {
      timeLeft = 60;
      isPaused = false;
    });
    Navigator.pop(context);
  }

  void _toggleMusic() {
    setState(() {
      isMusicOn = !isMusicOn;
    });
  }

  void showPauseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิดโดยกดด้านนอก
      builder: (context) => AlertDialog(
        title: Center(
          child: Text("เกมหยุดชั่วคราว"),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconButton(
                  Icons.home,
                  "หน้าหลัก",
                  () {
                    Navigator.pop(context);
                    Navigator.pop(context); // กลับไปหน้าหลัก
                  },
                  Colors.redAccent,
                ),
                _buildIconButton(
                  Icons.refresh,
                  "เล่นใหม่",
                  () {
                    initializeGame();
                    Navigator.pop(context); // กลับไปหน้าหลัก
                  },
                  Colors.blueAccent,
                ),
                _buildIconButton(
                  Icons.play_circle,
                  "เล่นต่อ",
                  () {
                    _resumeGame();
                    Navigator.pop(context); // กลับไปหน้าหลัก
                  },
                  Colors.yellow.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, String label, VoidCallback onTap, Color color) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 40, color: color),
          onPressed: onTap,
        ),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
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

  void playSound(String fileName) async {
    await _audioPlayer.play(AssetSource("sounds/$fileName"));
  }

  // ตรวจสอบว่าผู้ใช้ต้องการให้แสดง Popup หรือไม่
  Future<void> _checkPopupPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool shouldShowPopup = prefs.getBool('show_popup') ?? true;

    if (shouldShowPopup) {
      Future.delayed(Duration(milliseconds: 500), () {
        showGameSettingsPopup(context);
      });
    }
  }

  //new code
  String getMatraTextFromID(int matraID) {
    return matras
        .firstWhere(
          (m) => m.matraID == matraID,
          orElse: () => Matra(matraID: matraID, matraText: ''),
        )
        .matraText;
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
      if (!isPaused) {
        if (remainingTime > 0) {
          setState(() {
            remainingTime--;
          });
        } else {
          timer.cancel();
          endGame(); // หมดเวลา
        }
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
          .where((v) =>
              v.matraText == vocabulary.matraText &&
              v.vocabID != vocabulary.vocabID)
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
          ? differentMatraWords[random.nextInt(differentMatraWords.length)]
              .vocab
          : vocabulary.vocab;
    } else if (question.questionID == 5) {
      Vocabulary? partner;
      for (var word in vocabularies) {
        if (word.vocabID != vocabulary.vocabID &&
            word.matraText == vocabulary.matraText) {
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
  List<String> _generateOptions(
      QuestionM question, Vocabulary vocabulary, String correctAnswer) {
    final random = Random();

    if (question.questionID == 2) {
      // QID 2:
      // - ตัวเลือกที่ถูกต้องต้องมาจากคำศัพท์ที่มี matraText เดียวกับ vocabulary แต่ไม่ใช่คำเดิม
      List<Vocabulary> sameMatraWords = vocabularies
          .where((v) =>
              v.matraText == vocabulary.matraText &&
              v.vocabID != vocabulary.vocabID)
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
          .where((w) =>
              w.matraText == vocabulary.matraText &&
              w.vocabID != vocabulary.vocabID)
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
        if (word1.matraText == word2.matraText &&
            word1.matraID == word2.matraID) continue;
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
      String currentCorrect = (answerType == AnswerType.matraText)
          ? vocabulary.matraText
          : vocabulary.vocab;
      List<String> candidateMatraTexts = vocabularies
          .map((w) => w.matraText)
          .where((mt) => mt != vocabulary.matraText)
          .toSet()
          .toList();
      if (candidateMatraTexts.isEmpty) {
        candidateMatraTexts = ['default'];
      }
      String wrongMatra =
          candidateMatraTexts[random.nextInt(candidateMatraTexts.length)];
      List<String> wrongOptions = vocabularies
          .where((w) => w.matraText == wrongMatra)
          .map((w) =>
              (answerType == AnswerType.matraText) ? w.matraText : w.vocab)
          .toSet()
          .toList();
      if (wrongOptions.length < 3) {
        for (String candidate in candidateMatraTexts) {
          wrongMatra = candidate;
          wrongOptions = vocabularies
              .where((w) => w.matraText == candidate)
              .map((w) =>
                  (answerType == AnswerType.matraText) ? w.matraText : w.vocab)
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
      options.shuffle();
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
      case 6:
        return AnswerType.matraText;
      case 5:
        return AnswerType.vocab;
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
      playSound("Correct_Answer.mp3");
      score++;
      consecutiveWrong = 0;
    } else {
      playSound("Wrong_answer.mp3");
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

  void endGame() {
    timer?.cancel();
    feedbackTimer?.cancel();

    playSound("Celebration_Sound.mp3");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameSummaryScreen(
          score: score,
          totalQuestions: totalQuestions,
          timeElapsed: 180 - remainingTime,
          mode: widget.mode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [Colors.white, Colors.blue[50]!],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //   ),
          // ),
          width: screenSize.width,
          height: screenSize.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/pic/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              _buildpauseIcon(),
              _buildGameHeader(),
              _buildQuestionCard(),
              _buildOptionsGrid(),
              if (showFeedback) _buildFeedbackBanner(),
            ],
          ),
        ),
      ),
    );
  }

// Container(
//                           decoration: BoxDecoration(
//                             color: Colors.red.withOpacity(0.9),
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 2),
//                           ),
//                           child: IconButton(
//                             icon: Icon(Icons.close,
//                                 color: Colors.white, size: 35),
//                             onPressed: () {
//                               _savePopupPreference(showPopupNextTime);
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ),
  Widget _buildpauseIcon() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.9),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: IconButton(
              icon: Icon(Icons.pause, color: Colors.white, size: 35),
              onPressed: _pauseGame,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameHeader() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoCard(Icons.star, 'คะแนน', '$score', Colors.orange),
          _buildInfoCardWithProgress(
            Icons.timer,
            'เวลาเหลือ',
            '${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}',
            Colors.blue,
            remainingTime / totalTime, // คำนวณเป็นเปอร์เซ็นต์
          ),
          _buildInfoCard(
              Icons.close, 'ผิดติดกัน', '${consecutiveWrong}/3', Colors.red),
        ],
      ),
    );
  }

// Card ปกติ
  Widget _buildInfoCard(
      IconData icon, String title, String value, Color color) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: color),
          SizedBox(height: 5),
          Text(title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

// Card ที่มี CircularProgressIndicator สำหรับเวลา
  Widget _buildInfoCardWithProgress(
      IconData icon, String title, String value, Color color, double progress) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: 5,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 30),
              Text(value,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlueAccent.shade100, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        currentQuestion?.text ?? 'กำลังโหลด...',
        style: TextStyle(
          fontFamily: 'Kanit',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade900,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionsGrid() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
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

    // กำหนดสีพื้นหลังสำหรับสถานะต่าง ๆ
    Color buttonColor = Colors.white;
    if (showFeedback) {
      if (isCorrectAnswer) {
        buttonColor = Colors.green.shade200;
      } else if (isSelected) {
        buttonColor = Colors.red.shade200;
      }
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        // เมื่อมีการเลือกให้เปลี่ยนเป็น gradient เล็กน้อย
        gradient: isSelected
            ? LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isSelected ? null : buttonColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: showFeedback && isCorrectAnswer
              ? Colors.green
              : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          if (!isProcessingAnswer && !showFeedback)
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isProcessingAnswer ? null : () => handleAnswer(option),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade900,
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
                    size: 26,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackBanner() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCorrect
              ? [Colors.green.shade400, Colors.green.shade600]
              : [Colors.red.shade400, Colors.red.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isCorrect ? Icons.check : Icons.close,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              isCorrect
                  ? 'เยี่ยมมาก! คำตอบถูกต้อง'
                  : 'เสียใจด้วย! คำตอบที่ถูกคือ ${currentQuestion?.correctAnswer}',
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
                mode: 'Easy',
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

void showGameSettingsPopup(BuildContext context) {
  bool showPopupNextTime = true;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // แถบด้านบน
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red.withOpacity(0.3),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        _buildCircle(Colors.pinkAccent),
                        _buildCircle(Colors.yellowAccent),
                        _buildCircle(Colors.green),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.9),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.close,
                                color: Colors.white, size: 35),
                            onPressed: () {
                              _savePopupPreference(showPopupNextTime);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // ชื่อระดับ
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade600,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'ระดับง่าย',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15),

                  // รายการการตั้งค่า
                  _buildSettingItem('กำหนดเวลา', '3 นาที'),
                  _buildSettingItem('ตอบถูกข้อละ', '10 คะแนน'),
                  _buildSettingItem('ตอบผิดติดกันได้', '3 ครั้ง'),

                  SizedBox(height: 10),

                  // Checkbox สำหรับการตั้งค่า
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: showPopupNextTime,
                        onChanged: (value) {
                          setState(() {
                            showPopupNextTime = value!;
                          });
                        },
                      ),
                      Text(
                        'เปิดข้อความนี้เมื่อเริ่มเกมทุกครั้ง',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// ฟังก์ชันบันทึกค่าความต้องการของผู้ใช้
Future<void> _savePopupPreference(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('show_popup', value);
}

// ฟังก์ชันสร้างกล่องแสดงข้อมูล
Widget _buildSettingItem(String title, String value) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    constraints: BoxConstraints(
      minHeight: 60,
      maxHeight: 100,
      minWidth: double.infinity,
    ),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue.shade200, Colors.purple.shade200],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(35),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(fontSize: 20, color: Colors.black)),
        SizedBox(height: 5),
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
      ],
    ),
  );
}

// ฟังก์ชันสร้างวงกลมสีด้านบน
Widget _buildCircle(Color color) {
  return Container(
    width: 40,
    height: 25,
    margin: EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.7),
      shape: BoxShape.circle,
    ),
  );
}
