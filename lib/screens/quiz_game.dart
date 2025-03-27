import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/database/database_helper.dart';
import 'package:flutter_application_0/models/dataModel.dart';
import 'package:flutter_application_0/screens/gamesummary.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizGame extends StatefulWidget {
  final String mode;
  final int initialTime;     
  final int scorePerCorrect;
  final String modeText;
  final int timeperminite;

  const QuizGame({
    required this.mode,
    required this.initialTime,
    required this.scorePerCorrect,
    required this.modeText,
    required this.timeperminite,
  });

  int get modeID {
    switch (mode) {
      case 'Easy':
        return 1;
      case 'Medium':
        return 2;
      case 'Hard':
        return 3;
      default:
        return 1;
    }
  }

  @override
  _QuizGameState createState() => _QuizGameState();
}

enum AnswerType { fcText, vocab }

class _QuizGameState extends State<QuizGame> {
  List<QuestionM> questions = [];
  List<Vocabulary> vocabularies = [];
  List<FinalConsonants> fc = [];
  int score = 0;
  int consecutiveWrong = 0;
  int totalQuestions = 0;
  Timer? timer;
  QuizQuestion? currentQuestion;
  QuestionM? currentQuestionM;
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
  bool showPopup = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPaused = false;
  int timeLeft = 60; 
  bool isMusicOn = true; 
  late int remainingTime;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.initialTime;

    initializeGame();
    _checkPopupPreference();
  }

  void _pauseGame() {
    setState(() {
      isPaused = true;
    });

    showPauseDialog();
  }

  void _resumeGame() {
    setState(() {
      isPaused = false;
    });
  }

  void showPauseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                    Navigator.pop(context);
                  },
                  Colors.redAccent,
                ),
                _buildIconButton(
                  Icons.refresh,
                  "เล่นใหม่",
                  () {
                    initializeGame();
                    Navigator.pop(context);
                  },
                  Colors.blueAccent,
                ),
                _buildIconButton(
                  Icons.play_circle,
                  "เล่นต่อ",
                  () {
                    _resumeGame();
                    Navigator.pop(context);
                  },
                  Colors.yellow.shade700,
                ),
                _buildIconButton(
                  Icons.question_mark,
                  "ดูข้อมูล",
                  () {
                    showGameSettingsPopup(context);
                  },
                  Colors.black45,
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
        Text(label, style: GoogleFonts.chakraPetch(fontSize: 14)),
      ],
    );
  }

  Future<void> initializeGame() async {
    final questions = await DatabaseHelper.getQuestions();
    final vocabularies = await DatabaseHelper.getVocabularies();
    final fc = await DatabaseHelper.getFinalConsonants();

final filteredVocabularies = vocabularies
      .where((v) => v.syllable == widget.modeID)
      .toList();

    setState(() {
      this.questions = questions;
      this.vocabularies = filteredVocabularies;
      this.fc = fc;
    });

    startGame();
  }

  void playSound(String fileName) async {
    await _audioPlayer.play(AssetSource("sounds/$fileName"));
  }

  Future<void> _checkPopupPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool shouldShowPopup = prefs.getBool('show_popup') ?? true;

    if (shouldShowPopup) {
      Future.delayed(Duration(milliseconds: 350), () {
        showGameSettingsPopup(context);
      });
    }
  }

  String getFinalConsonantTextFromID(int fcID) {
    return fc
        .firstWhere(
          (m) => m.fcID == fcID,
          orElse: () => FinalConsonants(fcID: fcID, fcText: ''),
        )
        .fcText;
  }

  void startGame() {
    timer?.cancel();
    feedbackTimer?.cancel();

    setState(() {
      score = 0;
      consecutiveWrong = 0;
      totalQuestions = 0;
      showFeedback = false;
      selectedAnswer = null;
      isCorrect = false;
      isProcessingAnswer = false;
      remainingTime = widget.initialTime;
      isPaused = false;
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
      currentQuestionM = question;
    });
  }

  String _getCorrectAnswer(QuestionM question, Vocabulary vocabulary) {
    final random = Random();
    if (question.questionID == 2) {

      List<Vocabulary> sameFCWords = vocabularies
          .where((v) =>
              v.fcText == vocabulary.fcText &&
              v.vocabID != vocabulary.vocabID)
          .toList();
      return sameFCWords.isNotEmpty
          ? sameFCWords[random.nextInt(sameFCWords.length)].vocab
          : vocabulary.vocab;
    } else if (question.questionID == 4) {

      List<Vocabulary> differentFCWords = vocabularies
          .where((v) => v.fcText != vocabulary.fcText)
          .toList();
      return differentFCWords.isNotEmpty
          ? differentFCWords[random.nextInt(differentFCWords.length)]
              .vocab
          : vocabulary.vocab;
    } else if (question.questionID == 5) {
      Vocabulary? partner;
      for (var word in vocabularies) {
        if (word.vocabID != vocabulary.vocabID &&
            word.fcText == vocabulary.fcText) {
          partner = word;
          break;
        }
      }
      partner ??= vocabulary;
      return "${vocabulary.vocab} ${partner.vocab}";
    }
    return question.answerType == AnswerType.fcText
        ? vocabulary.fcText
        : vocabulary.vocab;
  }


  List<String> _generateOptions(
      QuestionM question, Vocabulary vocabulary, String correctAnswer) {
    final random = Random();

    if (question.questionID == 2) {

      List<Vocabulary> sameFCWords = vocabularies
          .where((v) =>
              v.fcText == vocabulary.fcText &&
              v.vocabID != vocabulary.vocabID)
          .toList();

      String correct = correctAnswer;

      List<String> wrongOptions = vocabularies
          .where((v) => v.fcText != vocabulary.fcText)
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

      List<String> wrongOptions = vocabularies
          .where((w) =>
              w.fcText == vocabulary.fcText &&
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

      List<String> options = [correctAnswer];
      Set<String> usedOptions = {correctAnswer};
      while (options.length < 4) {
        Vocabulary word1 = vocabularies[random.nextInt(vocabularies.length)];
        Vocabulary word2 = vocabularies[random.nextInt(vocabularies.length)];
        if (word1.fcText == word2.fcText &&
            word1.fcID == word2.fcID) continue;
        String option = "${word1.vocab} ${word2.vocab}";
        if (!usedOptions.contains(option)) {
          options.add(option);
          usedOptions.add(option);
        }
      }
      options.shuffle();
      return options..shuffle();
    } else if (question.questionID == 6) {

      final answerType = question.answerType;
      String currentCorrect = (answerType == AnswerType.fcText)
          ? vocabulary.fcText
          : vocabulary.vocab;
      List<String> candidateFCTexts = vocabularies
          .map((w) => w.fcText)
          .where((mt) => mt != vocabulary.fcText)
          .toSet()
          .toList();
      if (candidateFCTexts.isEmpty) {
        candidateFCTexts = ['default'];
      }
      String wrongFC =
          candidateFCTexts[random.nextInt(candidateFCTexts.length)];
      List<String> wrongOptions = vocabularies
          .where((w) => w.fcText == wrongFC)
          .map((w) =>
              (answerType == AnswerType.fcText) ? w.fcText : w.vocab)
          .toSet()
          .toList();
      if (wrongOptions.length < 3) {
        for (String candidate in candidateFCTexts) {
          wrongFC = candidate;
          wrongOptions = vocabularies
              .where((w) => w.fcText == candidate)
              .map((w) =>
                  (answerType == AnswerType.fcText) ? w.fcText : w.vocab)
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

      String correctFC = (question.answerType == AnswerType.fcText)
          ? correctAnswer
          : vocabulary.fcText;
      Set<int> usedVocabIds = {vocabulary.vocabID};
      List<String> options = [correctAnswer];
      while (options.length < 4) {
        Vocabulary word = vocabularies[random.nextInt(vocabularies.length)];
        if (usedVocabIds.contains(word.vocabID)) continue;
        if (word.fcText == correctFC) continue;
        String value = (question.answerType == AnswerType.fcText)
            ? word.fcText
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
        return AnswerType.fcText;
      case 5:
        return AnswerType.vocab;
      default:
        return AnswerType.vocab;
    }
  }


  void handleAnswer(String selectedOption) {
    if (isProcessingAnswer || currentQuestion == null) return;

    setState(() {
      isProcessingAnswer = true;
      selectedAnswer = selectedOption;

      isCorrect = (selectedOption == currentQuestion!.correctAnswer);
      showFeedback = true;
      totalQuestions++; 
    });

    if (isCorrect) {
      playSound("Correct_Answer.mp3");
      score+=widget.scorePerCorrect;
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
          timeElapsed: widget.initialTime - remainingTime,
          mode: widget.mode,
          scorePerCorrect: widget.scorePerCorrect,
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
              style: GoogleFonts.chakraPetch(fontSize: 14, fontWeight: FontWeight.bold)),
          Text(value,
              style: GoogleFonts.chakraPetch(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

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
                  style: GoogleFonts.chakraPetch(
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
      duration: Duration(milliseconds: 260),
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
    String correctAnswer = "${vocabulary.vocab} ${partner.vocab}";

    if (validateAnswer(selectedAnswer, correctAnswer)) {
      setState(() {
        score += widget.scorePerCorrect;
      });
    } else {
      setState(() {
        lives -= 1;
        if (lives == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameSummaryScreen(
                score: score,
                totalQuestions: totalQuestions,
                timeElapsed: timeElapsed,
                mode: widget.mode,
                scorePerCorrect: widget.scorePerCorrect,
              ),
            ),
          );
        }
      });
    }
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
                      widget.modeText,
                      style: GoogleFonts.chakraPetch(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15),

                  // รายการการตั้งค่า
                  _buildSettingItem('กำหนดเวลา', widget.timeperminite.toString(),' นาที'),
                  _buildSettingItem('ตอบถูกข้อละ',widget.scorePerCorrect.toString() ,' คะแนน'),
                  _buildSettingItem('ตอบผิดติดกันได้', '3',' ครั้ง'),

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
                        style: GoogleFonts.chakraPetch(fontSize: 16),
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


Future<void> _savePopupPreference(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('show_popup', value);
}

Widget _buildSettingItem(String title,String scoreText ,String value) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    constraints: BoxConstraints(
      minHeight: 60,
      maxHeight: 100,
      minWidth: 300,
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
        Text(title, style: GoogleFonts.chakraPetch(fontSize: 22, color: Colors.black)),
        SizedBox(height: 5),
        Text(
                overflow: TextOverflow.ellipsis, '$scoreText $value',style: GoogleFonts.chakraPetch(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),

      ],
    ),
  );
}

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
