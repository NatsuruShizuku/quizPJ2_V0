import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HowToPlay_Matchgame extends StatefulWidget {
  const HowToPlay_Matchgame({super.key});
  @override
  State<HowToPlay_Matchgame> createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay_Matchgame> {
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
                    Text("ในการเล่นเกมนี้จะมีส่วนของบัตรคำ", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),
                    Text("คว่ำไว้โดยจะต้องทำการเปิดบัตรคำ", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),
                    Text("ให้ตรงกันสองใบ หากเป็นคำที่อยู่", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),
                    Text("ในมาตราตัวสะกดเดียวกันจะหงาย", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),
                    Text("หากไม่ใช่จะคว่ำไว้ตามเดิม", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),
                    Text("คุณจะต้องจับคู่ให้ครบทุกคำ", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),
                    Text("และทำเวลาให้ดีที่สุดในการเล่น", style: GoogleFonts.chakraPetch(fontSize: 22,color: Colors.black87,fontWeight: FontWeight.bold),),

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
