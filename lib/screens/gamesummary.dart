import 'package:flutter/material.dart';
import 'package:flutter_application_0/database/database_helper.dart';
import 'package:flutter_application_0/models/dataModel.dart';

class GameSummaryScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int timeElapsed;
  final String mode;

  const GameSummaryScreen({super.key,
    required this.score,
    required this.totalQuestions,
    required this.timeElapsed,
    required this.mode,
  });

  @override
  _GameSummaryScreenState createState() => _GameSummaryScreenState();
}

class _GameSummaryScreenState extends State<GameSummaryScreen> {
  TextEditingController _nameController = TextEditingController();
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = widget.totalQuestions > 0 
        ? (widget.score / widget.totalQuestions * 100).round() 
        : 0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade200, Colors.white],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
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
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    _buildStatRow('คะแนนได้', '${widget.score} คะแนน'),
                    _buildStatRow('ความแม่นยำ', '$accuracy%'),
                    _buildStatRow('เวลาที่ใช้', '${widget.timeElapsed} วินาที'),
                    _buildStatRow('ตอบถูก', '${widget.score}/${widget.totalQuestions}'),
                    
                    if (isHighScore) ...[
                      SizedBox(height: 20),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'บันทึกชื่อผู้เล่น'),
                      ),
                      ElevatedButton(
                        onPressed: _saveHighScore,
                        child: Text('บันทึกคะแนน'),
                        
                      ),
                    ],
                    
                    SizedBox(height: 20),
                    FutureBuilder<List<HighScore>>(
                      future: DatabaseHelper.getHighScores(widget.mode),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return CircularProgressIndicator();
                        return Column(
                          children: snapshot.data!.map((score) => ListTile(
                            title: Text(score.name),
                            subtitle: Text('${score.score} คะแนน - ${score.timeStamp}'),
                          )).toList(),
                        );
                      },
                    ),
                    
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.replay),
                          label: Text('เล่นอีกครั้ง'),
                          style: _summaryButtonStyle(Colors.green),
                          onPressed: () => Navigator.pop(context),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.exit_to_app),
                          label: Text('ออกจากเกม'),
                          style: _summaryButtonStyle(Colors.red),
                          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
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
          Text(label, style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  ButtonStyle _summaryButtonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
