import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingMenuQ extends StatefulWidget {
  const SettingMenuQ({super.key});

  @override
  State<SettingMenuQ> createState() => _SettingMenuQState();
}

class _SettingMenuQState extends State<SettingMenuQ> {
  bool isMuted = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/pic/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height * 0.25,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/pic/button4.png',
                      width: screenSize.width * 0.925,
                      height: screenSize.height * 0.25,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isMuted = !isMuted;
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            isMuted ? Icons.volume_off : Icons.volume_up,
                            size: 40,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'เพลงประกอบ',
                    style: GoogleFonts.chakraPetch(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.person, size: 40, color: Colors.blue[700]),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Icon(Icons.settings, size: 20, color: Colors.blue[700]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'ผู้ดูแลระบบ',
                    style: GoogleFonts.chakraPetch(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'ออกจากเกม',
                    style: GoogleFonts.chakraPetch(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}