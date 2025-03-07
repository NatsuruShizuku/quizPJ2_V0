import 'package:flutter/material.dart';
import 'package:flutter_application_0/match_game/pages/game_level.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchMenu extends StatefulWidget {
  const MatchMenu({super.key});
  
  @override
  State<MatchMenu> createState() => _MatchMenuState();
}

class _MatchMenuState extends State<MatchMenu> {

void _navigateToPage(String buttonType) async {
  switch (buttonType) {
    case 'เล่น':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GameLevel()),
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
                'assets/images/button6.png',
                fit: BoxFit.fill,
              ),
              Center(
                child: Text(
                  text,
                  style: GoogleFonts.chakraPetch(
                    color: Colors.black,
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
            image: AssetImage("assets/images/background3.png"),
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
                            'assets/images/sign4.png',
                            width: screenSize.width * 0.925,
                            height: screenSize.height * 0.25,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            top: screenSize.height * 0.078,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                Text(
                                  "เกม",
                                  style: GoogleFonts.chakraPetch(
                                    color: Colors.black,
                                    fontSize: screenSize.width * 0.08,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "จับคู่คำศัพท์",
                                  style: GoogleFonts.chakraPetch(
                                    color: Colors.black,
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
                        children: ['เล่น']
                            .map((text) => _buildButton(text, screenSize))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}