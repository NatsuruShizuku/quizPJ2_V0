import 'package:flutter/material.dart';
import 'package:flutter_application_0/learningscreen/learning_screen.dart';
import 'package:flutter_application_0/screens/quizmenu.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // ซ่อน debug banner
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.lightBlueAccent),
      ),
      home: const WelcomeScreen(),
      routes: {
        "/learningMode": (context) => const LearningModeScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // ignore: sized_box_for_whitespace
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.lightBlue,
                        Colors.lightGreenAccent,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(70),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/pic/kids1.png",
                      width: 330,
                      height: 330,
                      scale: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.666,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.lightGreenAccent,
                      Colors.lightBlue,
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.666,
                padding: const EdgeInsets.only(top: 4, bottom: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45),
                      child:
                          Text(
                        "เกมฝึกทักษะภาษาไทย: มาตราตัวสะกด",
                        style: GoogleFonts.chakraPetch(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 80),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.lightBlueAccent,
                            Colors.lightBlue,
                          ],
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(
                                    title: 'Flutter Home Page'),
                              ));
                        },
                        child: Text(
                          "เริ่มเล่น",
                          style: GoogleFonts.chakraPetch(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child:
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9C4),
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "แอปพลิเคชันฝึกทักษะภาษาไทย",
              style: GoogleFonts.chakraPetch(
                  color: Colors.black38,
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5.0,
            ),
            
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    // นำไปยังหน้าถัดไป
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LearningModeScreen()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 20.0, left: 20.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF76BA99),
                                  Color.fromARGB(233, 118, 186, 153),
                                  Color.fromARGB(228, 118, 186, 153),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5.0),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 250, 246, 5)),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.done,
                                color: const Color.fromARGB(255, 250, 246, 5),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "โหมดการเรียนรู้",
                              style: GoogleFonts.chakraPetch(
                                  color: Colors.black87,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/pic/book.png",
                        height: 120,
                        width: 120,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    // นำไปยังหน้าถัดไป
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuizMenu(),),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 20.0, left: 20.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFADCF9F),
                                  Color.fromARGB(160, 173, 207, 159),
                                  Color.fromARGB(192, 173, 207, 159),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5.0),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 227, 118, 55)),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: const Color.fromARGB(255, 227, 118, 55),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "เกมตอบคำถาม",
                              style: GoogleFonts.chakraPetch(
                                  color: Colors.black87,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/pic/quiz1.png",
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    // นำไปยังหน้าถัดไป
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuizMenu()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 20.0, left: 20.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFCDE89E),
                                  Color.fromARGB(227, 205, 232, 158),
                                  Color.fromARGB(199, 205, 232, 158),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5.0),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          240, 235, 60, 60)),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.gamepad,
                                color: const Color.fromARGB(240, 235, 60, 60),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "เกมจับคู่คำศัพท์",
                              style: GoogleFonts.chakraPetch(
                                  color: Colors.black87,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/pic/games.png",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
