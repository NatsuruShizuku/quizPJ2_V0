import 'package:flutter/material.dart';

class GameSummaryScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int timeElapsed;

  const GameSummaryScreen({super.key, 
    required this.score,
    required this.totalQuestions,
    required this.timeElapsed,
  });

  @override
  Widget build(BuildContext context) {
    final accuracy = totalQuestions > 0 ? (score / totalQuestions * 100).round() : 0;

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
                    SizedBox(height: 30),
                    _buildStatRow('คะแนนได้', '$score คะแนน'),
                    _buildStatRow('ความแม่นยำ', '$accuracy%'),
                    _buildStatRow('เวลาใช้ไป', '$timeElapsed วินาที'),
                    _buildStatRow('ตอบถูก', '$score/$totalQuestions'),
                    SizedBox(height: 40),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
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