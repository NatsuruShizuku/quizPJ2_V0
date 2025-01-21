import 'package:flutter/material.dart';
import 'package:flutter_application_0/models/question1.dart';
import 'package:flutter_application_0/models/quiz_data.dart';

class QuizScreen extends StatefulWidget {
  final QuizData quizData;

  const QuizScreen({Key? key, required this.quizData}) : super(key: key);

  @override
   State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question1>> _questionsFuture;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _hasAnswered = false;

  @override
  void initState() {
    super.initState();
    _questionsFuture = widget.quizData.getQuestions();
  }

  void _checkAnswer(bool isCorrect) {
    if (!_hasAnswered) {
      setState(() {
        // if (isCorrect) _score++;
        // _hasAnswered = true;
        if (isCorrect) {
          _score++;
          _showFeedback('เก่งมาก! 🎉', Colors.green);
        } else {
          _showFeedback('ลองใหม่นะ! 💪', Colors.orange);
        }
        _hasAnswered = true;
      });

      // แสดง feedback และเลื่อนไปข้อถัดไปหลังจาก delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _currentQuestionIndex++;
          _hasAnswered = false;
        });
      });
    }
  }

void _showFeedback(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('แบบทดสอบ'),
//         actions: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: Text(
//                 'คะแนน: $_score',
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Question1>>(
//         future: _questionsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
//           }

//           final questions = snapshot.data;
//           if (questions == null || questions.isEmpty) {
//             return const Center(child: Text('ไม่พบคำถาม'));
//           }


//           if (_currentQuestionIndex >= questions.length) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'จบแบบทดสอบแล้ว!\nคะแนนของคุณ: $_score/${questions.length}',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 24),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _currentQuestionIndex = 0;
//                         _score = 0;
//                       });
//                     },
//                     child: const Text('เริ่มใหม่'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return SingleChildScrollView(
//             child: _buildQuestionCard(questions[_currentQuestionIndex]),
//           );
//         },
//       ),
//     );
//   }
// }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[200]!, Colors.purple[100]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildQuestionContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'คะแนน: $_score',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//  Widget _buildQuestionCard(Question1 question) {

//     // แทนที่ placeholder ในคำถาม
//     final displayQuestion = question.setQuestion.replaceAll(
//       '{wordQuestion}',
//       question.wordQuestion,
//     );

//     return Card(
//       margin: const EdgeInsets.all(16.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'คำถามข้อที่ ${_currentQuestionIndex + 1}',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               displayQuestion,
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 24),
//             ...question.options.map((option) {
//               final bool isAnswered = _hasAnswered;
//               final bool isCorrect = option.isCorrect;

//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: isAnswered
//                         ? (isCorrect ? Colors.green : Colors.red)
//                         : null,
//                     padding: const EdgeInsets.all(16),
//                   ),
//                   onPressed: () => _checkAnswer(option.isCorrect),
//                   child: Text(option.optionTEXT),
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );

Widget _buildQuestionContent() {
    return FutureBuilder<List<Question1>>(
      future: _questionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'เกิดข้อผิดพลาด: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        final questions = snapshot.data;
        if (questions == null || questions.isEmpty) {
          return const Center(
            child: Text(
              'ไม่พบคำถาม',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        if (_currentQuestionIndex >= questions.length) {
          return _buildCompletionScreen(questions.length);
        }

        return _buildQuestionCard(questions[_currentQuestionIndex]);
      },
    );
  }

  Widget _buildQuestionCard(Question1 question) {
    final displayQuestion = question.setQuestion.replaceAll(
      '{wordQuestion}',
      question.wordQuestion,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'คำถามที่ ${_currentQuestionIndex + 1}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      displayQuestion,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: question.options.map((option) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: _hasAnswered ? null : () => _checkAnswer(option.isCorrect),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    option.optionTEXT,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.purple[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  Widget _buildCompletionScreen(int totalQuestions) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.celebration,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 24),
              Text(
                'ยอดเยี่ยมมาก! 🎉',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[700],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'คะแนนของคุณ: $_score/$totalQuestions',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex = 0;
                    _score = 0;
                    _hasAnswered = false;
                  });
                },
                icon: const Icon(Icons.replay),
                label: const Text('เล่นอีกครั้ง',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.purple[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}