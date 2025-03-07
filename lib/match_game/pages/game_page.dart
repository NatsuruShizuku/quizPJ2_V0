import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_0/database/database_helper_matchcard.dart';
import 'package:flutter_application_0/match_game/animation/confetti_animation.dart';
import 'package:flutter_application_0/match_game/manager/game_manager.dart';
import 'package:flutter_application_0/match_game/models/word.dart';
import 'package:flutter_application_0/match_game/pages/match_menu.dart';
import 'package:flutter_application_0/match_game/replay_popup.dart';
import 'package:flutter_application_0/match_game/word_tile.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'error_page.dart';
import 'loading_page.dart';

class GamePage extends StatefulWidget {
  final int rows;
  final int columns;

  const GamePage({
    super.key,
    required this.rows,
    required this.columns,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Future<int>? _futureCachedImages;
  List<Word> _gridWords = [];
  late final DatabaseHelper _dbHelper;
  List<Word> sourceWords = [];
  late final GameManager _gameManager;
  bool _startPopupShown = false; // flag สำหรับตรวจสอบการแสดง popup เริ่มเกม

  @override
  void initState() {
    super.initState();
    _gameManager = GameManager(totalTiles: widget.rows * widget.columns);
    _dbHelper = DatabaseHelper.instance;
    _loadWordsFromDB().then((_) {
      _setUp();
      _futureCachedImages = _cacheImages();
    });
  }

  _loadWordsFromDB() async {
    try {
      List<Map<String, dynamic>> maps = await _dbHelper.queryAllWords();
      if (maps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่พบข้อมูลในฐานข้อมูล')),
        );
        return;
      }
      sourceWords = maps.map((map) {
        final contents = map['contents'] as List<int>? ?? [];
        if (contents.isEmpty) {
          print('คำเตือน: รูปภาพสำหรับคำศัพท์ ${map['descrip']} ไม่มีข้อมูล');
        }
        return Word.fromMap(map);
      }).toList();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  _setUp() {
    if (sourceWords.isEmpty) return;

    final totalPairs = (widget.rows * widget.columns) ~/ 2;
    Map<int, List<Word>> groups = {};
    for (Word word in sourceWords) {
      groups.putIfAbsent(word.matraID, () => []).add(word);
    }
    List<List<Word>> validPairs = [];
    groups.forEach((matraID, wordsList) {
      if (wordsList.length >= 2) {
        wordsList.shuffle();
        int numPairs = wordsList.length ~/ 2;
        for (int i = 0; i < numPairs; i++) {
          validPairs.add([wordsList[2 * i], wordsList[2 * i + 1]]);
        }
      }
    });
    if (validPairs.length < totalPairs) {
      throw Exception(
          'ไม่พบคำศัพท์เพียงพอในฐานข้อมูลที่มี matraID เดียวกันสำหรับจับคู่');
    }
    validPairs.shuffle();
    List<List<Word>> selectedPairs = validPairs.take(totalPairs).toList();
    _gridWords.clear();
    for (List<Word> pair in selectedPairs) {
      _gridWords.addAll(pair);
    }
    _gridWords.shuffle();
  }

  Widget _buildImage(List<int> bytes) {
    return Image.memory(
      Uint8List.fromList(bytes),
      fit: BoxFit.contain,
    );
  }

  Future<void> _saveLevelCompletionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('level_${widget.rows}x${widget.columns}', true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameManager>.value(
      value: _gameManager,
      child: FutureBuilder(
        future: _futureCachedImages,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const ErrorPage();
          final isDataReady = snapshot.connectionState == ConnectionState.done;
          if (isDataReady) {
            // แสดง Popup เริ่มเกม ครั้งเดียวเมื่อข้อมูลพร้อม
            if (!_startPopupShown && _gridWords.isNotEmpty) {
              _startPopupShown = true;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                // โหลด asset image เป็น ByteData แล้วแปลงเป็น Uint8List
                final byteData =
                    await rootBundle.load("assets/images/Tips.png");
                final assetBytes = byteData.buffer.asUint8List();

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => StartGamePopup(
                    imageBytes:
                        assetBytes, // ส่ง assetBytes แทนข้อมูลจากฐานข้อมูล
                  ),
                );
              });
            }
            return Scaffold(
              backgroundColor: Colors.blueGrey[50],
              body: _buildGameGrid(),
            );
          }
          return const LoadingPage();
        },
      ),
    );
  }

  Widget _buildGameGrid() {
    return Selector<GameManager, bool>(
      selector: (_, gameManager) => gameManager.roundCompleted,
      builder: (_, roundCompleted, __) {
        // เมื่อจบรอบเกมให้บันทึกสถานะด่านและแสดง ReplayPopUp พร้อมกับ Confetti Animation
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          if (roundCompleted) {
            await _saveLevelCompletionStatus();
            await showDialog(
              barrierColor: Colors.transparent,
              barrierDismissible: false,
              context: context,
              builder: (context) => ReplayPopUp(
                matchedPairs: _gameManager.successfulMatches,
              ),
            );
          }
        });
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue.shade100, Colors.blue.shade50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Positioned(
            //   top: 40,
            //   right: 20,
            //   child: _buildPauseButton(),
            // ),
            Column(
              children: [
                _buildStatsHeader(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _gridWords.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: widget.columns,
                            childAspectRatio: 1,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            return Selector<GameManager, List<int>>(
                              selector: (_, gm) => gm.answeredWords,
                              builder: (_, answeredWords, __) {
                                final isMatched = answeredWords.contains(index);
                                return WordTile(
                                  key: ValueKey(index),
                                  index: index,
                                  word: _gridWords[index],
                                  isMatched: isMatched,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (roundCompleted)
              Positioned.fill(
                child: IgnorePointer(
                  child: ConfettiAnimation(animate: roundCompleted),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPauseButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: IconButton(
        icon: const Icon(Icons.pause, color: Colors.white, size: 25),
        onPressed: _showPauseDialog,
      ),
    );
  }

  void _showPauseDialog() {
    setState(() {
      _gameManager.isPaused = true;
    });

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      // ใช้ shape เพื่อกำหนดขอบโค้งมน
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // ใช้ child เพื่อใส่ Widget หลัก
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.pink.shade300,
              Colors.purple.shade400,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
                  child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'เกมหยุดชั่วคราว',
              style: GoogleFonts.chakraPetch(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFancyIconButton(
                  icon: Icons.home,
                  label: "หน้าหลัก",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MatchMenu()),
                    );
                  },
                  color: Colors.redAccent,
                ),
                _buildFancyIconButton(
                  icon: Icons.refresh,
                  label: "เริ่มใหม่",
                  onTap: () {
                    Navigator.pop(context);
                    _restartGame();
                  },
                  color: Colors.orangeAccent,
                ),
                _buildFancyIconButton(
                  icon: Icons.play_arrow,
                  label: "เล่นต่อ",
                  onTap: () {
                    setState(() => _gameManager.isPaused = false);
                    Navigator.pop(context);
                  },
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


 Widget _buildFancyIconButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  required Color color,
}) {
  return Column(
    children: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
      SizedBox(height: 8),
      Text(
        label,
        style: GoogleFonts.chakraPetch(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

  Widget _buildIconButton(
      IconData icon, String label, VoidCallback onTap, Color color) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 40, color: color),
          onPressed: onTap,
        ),
        Text(label, style: GoogleFonts.chakraPetch(fontSize: 14)),
      ],
    );
  }

  void _restartGame() {
    _gameManager.resetGame();
    _setUp();
    setState(() {});
  }

  Widget _buildStatsHeader(BuildContext context) {
    return Container(
      // เปลี่ยน padding เพื่อให้มีพื้นที่มากขึ้น
      padding: const EdgeInsets.only(top: 24, bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        // ใช้ gradient ที่มีโทนสีสดใสออกแนว Mobile Game
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 56, 159, 243), // ม่วง
            Color.fromARGB(255, 5, 83, 239), // น้ำเงินอมม่วง
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // แถวแรก: แสดงหัวใจ, เหรียญ หรืออื่น ๆ (ตามสไตล์เกม)
          Selector<GameManager, ({int moves, int successfulMatches})>(
            selector: (_, gm) =>
                (moves: gm.moves, successfulMatches: gm.successfulMatches),
            shouldRebuild: (previous, next) =>
                previous.moves != next.moves ||
                previous.successfulMatches != next.successfulMatches,
            builder: (_, stats, __) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.autorenew_rounded,
                        color: Colors.pinkAccent,
                        size: 28,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${stats.moves}", // จำนวนหัวใจ
                        style: GoogleFonts.chakraPetch(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // ตัวอย่างแสดงเหรียญ (Coin)
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.amber,
                        size: 28,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${stats.successfulMatches}", // จำนวนเหรียญ
                        style: GoogleFonts.chakraPetch(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  _buildPauseButton(),
                ],
              );
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

// ดึงค่าคู่ที่จับสำเร็จสะสมจาก SharedPreferences
  Future<int> _getPersistentMatches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('persistentMatchedPairs') ?? 0;
  }

  Widget _buildPersistentMatchStatCard() {
    return FutureBuilder<int>(
      future: _getPersistentMatches(),
      builder: (context, snapshot) {
        final persistentMatches = snapshot.data ?? 0;
        return _buildStatCard("จับคู่ทั้งหมด", "$persistentMatches คู่");
      },
    );
  }

// สร้างการ์ดแสดงสถิติ
  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.chakraPetch(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.chakraPetch(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<int> _cacheImages() async {
    final assetImage = AssetImage("assets/images/Tips.png");
    await precacheImage(assetImage, context);
    return 1;
  }
}

// Widget สำหรับ Popup เริ่มเกม
class StartGamePopup extends StatelessWidget {
  final Uint8List imageBytes;

  const StartGamePopup({Key? key, required this.imageBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                imageBytes,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            // child: IconButton(
            //   icon: const Icon(Icons.close, color: Colors.black,size: 35,),
            //   onPressed: () => Navigator.of(context).pop(),
            // ),
            child: Container(
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: IconButton(
        icon: const Icon(Icons.close, color: Colors.black, size: 35),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
          ),
        ],
      ),
    );
  }
}
