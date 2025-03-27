
import 'package:flutter/material.dart';
import 'package:flutter_application_0/database/database_helper.dart';
import 'package:flutter_application_0/models/dataModel.dart';
import 'package:flutter_application_0/screens/highscorescreen.dart';
import 'package:google_fonts/google_fonts.dart';

class GameSummaryScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int timeElapsed;
  final String mode;
  final int scorePerCorrect;

  const GameSummaryScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.timeElapsed,
    required this.mode,
    required this.scorePerCorrect,
  });

  @override
  _GameSummaryScreenState createState() => _GameSummaryScreenState();
}

class _GameSummaryScreenState extends State<GameSummaryScreen> {
  final TextEditingController _nameController = TextEditingController();
  List<HighScore> highScores = [];
  bool isHighScore = false;

  @override
  void initState() {
    super.initState();
    _checkHighScore();
  }

  void _checkHighScore() async {
    highScores = await DatabaseHelper.getHighScores(widget.mode);
    if (highScores.length < 10 || widget.score > highScores.last.score) {
      setState(() => isHighScore = true);
    }
  }

  void _saveHighScore() async {
    if (_nameController.text.isEmpty) return;

    final newScore = HighScore(
      mode: widget.mode,
      name: _nameController.text,
      score: widget.score,
      timeStamp: DateTime.now(),
    );

    await DatabaseHelper.insertHighScore(newScore);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HighScoreTableScreen(mode: widget.mode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = widget.totalQuestions > 0
        ? ((widget.score / widget.scorePerCorrect).toInt() /
                widget.totalQuestions *
                100)
            .round()
        : 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade200, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              30,
              30,
              30,
              MediaQuery.of(context).viewInsets.bottom + 30,
            ),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('สรุปผลเกม 🏆',
                        style: GoogleFonts.chakraPetch(
                            fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildStatRow('คะแนนได้', '${widget.score} คะแนน'),
                    _buildStatRow('ความแม่นยำ', '$accuracy%'),
                    _buildStatRow('เวลาที่ใช้', _formatTime(widget.timeElapsed)),
                    _buildStatRow(
                        'ตอบถูก',
                        '${(widget.score / widget.scorePerCorrect).toInt()}/${widget.totalQuestions} ข้อ'),
                    if (isHighScore) ...[
                      const SizedBox(height: 20),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'บันทึกชื่อผู้เล่น',
                          labelStyle: GoogleFonts.chakraPetch(fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.deepPurple, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _saveHighScore,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('บันทึกคะแนน',
                            style: GoogleFonts.chakraPetch(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildIconButton(
                            Icons.refresh,
                            "เล่นใหม่",
                            () {
                              Navigator.pop(context);
                            
                            },
                            Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildIconButton(
                            Icons.home,
                            "หน้าหลัก",
                            () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.chakraPetch(
                  fontSize: 18, color: Colors.grey.shade700)),
          Text(value,
              style: GoogleFonts.chakraPetch(
                  fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  
  String _formatTime(int totalSeconds) {
  int minutes = totalSeconds ~/ 60;
  int seconds = totalSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')} นาที';
}
}

Widget _buildIconButton(
    IconData icon, String label, VoidCallback onTap, Color color) {
  return Column(
    children: [
      IconButton(
        icon: Icon(icon, size: 40, color: color),
        onPressed: onTap,
      ),
      Text(label,
          style: GoogleFonts.chakraPetch(
            fontSize: 18,
          )),
    ],
  );
}
