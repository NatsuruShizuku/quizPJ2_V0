import 'package:flutter/material.dart';
import 'package:flutter_application_0/screens/highscore.dart';
import 'package:flutter_application_0/screens/highscorescreen.dart';
import 'package:flutter_application_0/screens/howtoplay.dart';
import 'package:flutter_application_0/screens/select_quiz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizMenu extends StatefulWidget {
  const QuizMenu({super.key});
  
  get mode => 'Medium';
  @override
  State<QuizMenu> createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {
  // void _navigateToPage(String buttonType) {
  //   switch (buttonType) {
  //     case 'เล่น':
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const SelectQuiz()),
  //       );
  //       break;
  //     case 'วิธีการเล่น':
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const HowToPlay()),
  //       );
  //       break;
  //     case 'คะแนนสูงสุด':
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => HighScoreTableScreen(mode: widget.mode,), ),
  //       );
  //       break;
  //   }
  // }
void _navigateToPage(String buttonType) async {
  switch (buttonType) {
    case 'เล่น':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SelectQuiz()),
      );
      break;
    case 'วิธีการเล่น':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HowToPlay()),
      );
      break;
    case 'คะแนนสูงสุด':
      final prefs = await SharedPreferences.getInstance();
      String mode = prefs.getString('lastMode') ?? 'Medium'; // ดึงโหมดที่บันทึกไว้
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HighScoreTableScreen(mode: mode),
        ),
      );
      break;
  }
}

  Widget _buildButton(String text, Size screenSize) {
    return Container(
      width: screenSize.width * 0.725,
      height: screenSize.height * 0.15,
      margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToPage(text),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/pic/button1.png',
                fit: BoxFit.fill,
              ),
              Center(
                child: Text(
                  text,
                  style: GoogleFonts.chakraPetch(
                    color: Colors.white,
                    fontSize: screenSize.width * 0.071,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Main Content
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
                child: Column(
                  children: [
                    // Title Section
                    SizedBox(
                      height: screenSize.height * 0.25,
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/pic/sign1.png',
                            width: screenSize.width * 0.925,
                            height: screenSize.height * 0.25,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            top: screenSize.height * 0.08,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                Text(
                                  "เกม",
                                  style: GoogleFonts.chakraPetch(
                                    color: Colors.white,
                                    fontSize: screenSize.width * 0.08,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "ตอบคำถาม",
                                  style: GoogleFonts.chakraPetch(
                                    color: Colors.white,
                                    fontSize: screenSize.width * 0.08,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Spacing
                    SizedBox(height: screenSize.height * 0.02),
                    
                    // Buttons Section
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ['เล่น', 'วิธีการเล่น', 'คะแนนสูงสุด']
                            .map((text) => _buildButton(text, screenSize))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Settings Icon Button
              // Positioned(
              //   bottom: screenSize.height * 0.02,
              //   right: screenSize.width * 0.05,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.black.withOpacity(0.3),
              //       shape: BoxShape.circle,
              //     ),
              //     child: IconButton(
              //       icon: Icon(
              //         Icons.settings,
              //         color: Colors.white,
              //         size: screenSize.width * 0.08,
              //       ),
              //       onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => const SettingMenuQ(),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}