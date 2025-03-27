

import 'package:flutter/material.dart';
import 'package:flutter_application_0/screens/quiz_game.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // เพิ่ม import นี้

class SelectQuiz extends StatefulWidget {
  const SelectQuiz({super.key});

  @override
  State<SelectQuiz> createState() => _SelectQuizState();
}

class _SelectQuizState extends State<SelectQuiz> {
  Future<void> _saveSelectedMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastMode', mode);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/pic/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: screenSize.height * 0.25,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/pic/button3.png',
                    width: screenSize.width * 0.925,
                    height: screenSize.height * 0.25,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                InkWell(
                  onTap: () async {
                    await _saveSelectedMode('Easy');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizGame(
                          mode: 'Easy',
                          initialTime: 310,
                          scorePerCorrect: 10,
                          modeText: 'ระดับง่าย',
                          timeperminite: (310 / 60).toInt(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.redAccent,
                            width: 10.0,
                          ),
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          "ง่าย",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.chakraPetch(
                            color: Colors.black87,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                InkWell(
                  onTap: () async {
                    await _saveSelectedMode('Medium');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizGame(
                          mode: 'Medium',
                          initialTime: 250,
                          scorePerCorrect: 15,
                          modeText: 'ระดับปานกลาง',
                          timeperminite: (250 / 60).toInt(),
                        ),
                      ),
                    );
                  },
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.redAccent,
                          width: 10.0,
                        ),
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        "ปานกลาง",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.chakraPetch(
                          color: Colors.black87,
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -60,
                  right: -70,
                  child: Image.asset(
                    "assets/pic/x1.5.png",
                    height: 160,
                    width: 160,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                InkWell(
                  onTap: () async {
                    await _saveSelectedMode('Hard');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizGame(
                          mode: 'Hard',
                          initialTime: 210,
                          scorePerCorrect: 20,
                          modeText: 'ระดับยาก',
                          timeperminite: (210 / 60).toInt(),
                        ),
                      ),
                    );
                  },
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.redAccent,
                          width: 10.0,
                        ),
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        "ยาก",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.chakraPetch(
                          color: Colors.black87,
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -60,
                  right: -70,
                  child: Image.asset(
                    "assets/pic/x2.png",
                    height: 160,
                    width: 160,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.1),
          ],
        ),
      ),
    );
  }
}