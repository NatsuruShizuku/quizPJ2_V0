import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HowToPlay extends StatefulWidget {
  const HowToPlay({super.key});
  @override
  State<HowToPlay> createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
              Column(
                children: [
                  SizedBox(
                    height: screenSize.height * 0.25,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/pic/button2.png',
                          width: screenSize.width * 0.925,
                          height: screenSize.height * 0.25,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  Container(
              height: height * 0.625,
              width: width,
              decoration: BoxDecoration(
                color: Color(0xFFfcd8c9),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    Text("ในการเล่นเกมนี้จะมีคำถามและตัวเลือก", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),
                    Text("แสดงขึ้นมา คุณจะต้องเลือกคำตอบ", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),
                    Text("ที่ถูกต้องในเวลาที่กำหนดเพื่อรับคะแนน", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),
                    Text("เมื่อเล่นจบหรือตอบผิดติดกันครบ 3 ครั้ง", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),
                    Text("จะทำการแสดงข้อมูลที่ทำได้ในรอบนั้นๆ", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),
                    Text("และสามารถบันทึกคะแนนที่ทำได้", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),
                    Text("โดยการกรอกชื่อและกดบันทึกคะแนน", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),

                  ],
                ),
              ),
            ),
                  
                ],
              ),

              // Spacing
              SizedBox(height: screenSize.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
