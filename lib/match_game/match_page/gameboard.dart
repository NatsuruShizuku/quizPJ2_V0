import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_0/match_game/match_page/audio_manager.dart';
import 'package:flutter_application_0/match_game/match_page/gamebesttime.dart';
import 'package:flutter_application_0/match_game/match_page/gamehelper.dart';
import 'package:flutter_application_0/match_game/match_page/gametimer.dart';
import 'package:flutter_application_0/match_game/match_page/startgamepopup.dart';
import 'package:flutter_application_0/models/picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameBoard extends StatefulWidget {
  final int rows;
  final int cols;
  final List<Picture> pictures;

  const GameBoard({
    super.key,
    required this.rows,
    required this.cols,
    required this.pictures,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<bool> _revealedCards;
  late List<bool> _matchedCards;
  int? _selectedIndex;
  int _matchedPairs = 0;
  late Duration _currentTime = Duration.zero;
  Timer? _gameTimer;
  int _bestTime = 0;
  late List<Picture> _pictures;
  bool _startPopupShown = false;

  @override
  void initState() {
    super.initState();
    _pictures = widget.pictures;
    _loadBestTime();
    // _startTimer();
    _initializeGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartPopup(); // แสดง Popup และจะเริ่ม Timer เมื่อปิด
    });
  }

  void _startTimer() {
    _gameTimer?.cancel(); // ยกเลิก Timer เก่า (หากมี)
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_matchedPairs < widget.pictures.length ~/ 2) {
        setState(() => _currentTime += const Duration(seconds: 1));
      }
    });
  }

  Future<void> _saveLevelCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('level_${widget.rows}x${widget.cols}', true);
  }

  Future<void> _showStartPopup() async {
    if (_startPopupShown) return;
    _startPopupShown = true;

    try {
      final byteData = await rootBundle.load("assets/images/Tips.png");
      final imageBytes = byteData.buffer.asUint8List();
      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StartGamePopup(imageBytes: imageBytes),
      );

      if (mounted) {
        _startTimer();
      }
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  String _getBestTimeKey() => 'best_time_${widget.rows}x${widget.cols}';

  Future<void> _loadBestTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _bestTime = prefs.getInt(_getBestTimeKey()) ?? 0);
  }

  Future<void> _saveBestTime() async {
    final currentBest = _bestTime;
    if (currentBest == 0 || _currentTime.inSeconds < currentBest) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_getBestTimeKey(), _currentTime.inSeconds);
      setState(() => _bestTime = _currentTime.inSeconds);
    }
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
    _gameTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink.shade300, Colors.purple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'เกมหยุดชั่วคราว',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDialogButton(Icons.home, "หน้าหลัก", Colors.red, () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
                  _buildDialogButton(Icons.refresh, "เริ่มใหม่", Colors.orange,
                      () {
                    Navigator.pop(context);
                    _restartGame();
                    _gameTimer?.cancel();
                    _startTimer();
                  }),
                  _buildDialogButton(Icons.play_arrow, "เล่นต่อ", Colors.green,
                      () {
                    Navigator.pop(context);
                    _startTimer();
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: color, size: 40),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _initializeGame() {
    _revealedCards = List<bool>.filled(_pictures.length, false);
    _matchedCards = List<bool>.filled(_pictures.length, false);
    _selectedIndex = null;
    _matchedPairs = 0;
  }

  Future<void> _handleCardTap(int index) async {
    if (_revealedCards[index] || _matchedCards[index]) return;

    // 1. เปิดการ์ด
    setState(() {
      _revealedCards[index] = true;
    });

    if (_selectedIndex == null) {
      _selectedIndex = index;
    } else {
      final firstIndex = _selectedIndex!;
      final secondIndex = index;
      final isMatched =
          _pictures[firstIndex].fcID == _pictures[secondIndex].fcID;

      if (isMatched) {
        // 2. จับคู่ถูกต้อง - ไม่มี async ใน setState
        setState(() {
          _matchedCards[firstIndex] = true;
          _matchedCards[secondIndex] = true;
          _matchedPairs++;
        });
        await AudioManager.playAudio('Correct'); // เล่นเสียงนอก setState
        _selectedIndex = null;

        if (_matchedPairs == widget.pictures.length ~/ 2) {
          await AudioManager.playAudio('Round'); // เล่นเสียงจบเกม
          _showGameOverDialog();
        }
      } else {
        // 3. จับคู่ผิด - แยก async ออก
        await AudioManager.playAudio('Incorrect'); // เล่นเสียงนอก setState
        await Future.delayed(const Duration(milliseconds: 500));

        if (!mounted) return;
        setState(() {
          // เรียก setState หลังจาก delay
          _revealedCards[firstIndex] = false;
          _revealedCards[secondIndex] = false;
          _selectedIndex = null;
        });
      }
    }
  }

  void _showGameOverDialog() {
    _gameTimer?.cancel();
    _saveBestTime();
    _saveLevelCompletion();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 20,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFA0E5), // ชมพู
                Color(0xFF7BD3FF), // ฟ้า
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ส่วนหัว
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.yellow, size: 40),
                  const SizedBox(width: 10),
                  Text(
                    'เกมจบแล้ว!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.pink,
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ภาพการ์ตูน
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFFFE082)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepOrange.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 3,
                    )
                  ],
                ),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    "assets/images/ending.png", // เปลี่ยนเป็นรูปเด็กๆ
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _buildGameButton(
                      icon: Icons.replay,
                      label: 'เล่นอีกครั้ง',
                      color: Colors.green,
                      onPressed: () {
                        Navigator.pop(context);
                        _restartGame();
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildGameButton(
                      icon: Icons.home,
                      label: 'ออก',
                      color: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                       
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _restartGame() async {
    _gameTimer?.cancel();

    try {
      final newPictures =
          await GameHelper.generateGamePairs(widget.rows, widget.cols);
      if (mounted) {
        setState(() {
          _pictures = newPictures;
          _pictures.shuffle();
          _initializeGame();
          _currentTime = Duration.zero;
        });
        await _showStartPopup(); // แสดง Popup ใหม่และเริ่ม Timer เมื่อปิด
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE1F5FE),
              Color(0xFFF0F4C3)
            ],
            stops: [0.3, 0.7],
          ),
        ),
        child: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) {
              final isPortrait = orientation == Orientation.portrait;
              return Column(
                children: [

                  Container(
                    padding: EdgeInsets.only(
                      top: isPortrait ? 8.0 : 4.0,
                      bottom: 4.0,
                      left: 8,
                      right: 8,
                    ),
                    height: isPortrait ? 80 : 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPauseButton(),
                        Row(
                          children: [
                            SizedBox(
                              width: isPortrait ? 160 : 140, 
                              child: GameTimerMobile(time: _currentTime),
                            ),
                            SizedBox(width: isPortrait ? 16 : 8),
                            SizedBox(
                              width: isPortrait ? 160 : 140,
                              child: GameBestTimeMobile(
                                bestTime: _bestTime,
                                rows: widget.rows,
                                cols: widget.cols,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double spacing =
                            isPortrait ? 4.0 : 3.0;

                        double headerHeight = isPortrait ? 80 : 60;
                        double availableHeight = constraints.maxHeight -
                            headerHeight;
                        double availableWidth = constraints.maxWidth;

                        double cardWidth =
                            (availableWidth - (widget.cols - 1) * spacing) /
                                widget.cols;
                        double cardHeight =
                            (availableHeight - (widget.rows - 1) * spacing) /
                                widget.rows;

                        return Center(
                          child: SizedBox(
                            width: cardWidth * widget.cols +
                                spacing * (widget.cols - 1),
                            height: cardHeight * widget.rows +
                                spacing * (widget.rows - 1),
                            child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: widget.cols,
                                  crossAxisSpacing: spacing,
                                  mainAxisSpacing: spacing,
                                  childAspectRatio: (cardWidth / cardHeight)
                                      .clamp(0.8, 1.2),
                                ),
                                itemCount: _pictures.length,

                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => _handleCardTap(index),
                                    onDoubleTap: () {
                                      if (_revealedCards[index]) {
                                        showDialog(
                                          context: context, 
                                          builder: (context) => Dialog(
                                            backgroundColor: Colors.transparent,
                                            insetPadding: EdgeInsets.all(10),
                                            child: Stack(
                                              children: [
                                                InteractiveViewer(
                                                  panEnabled: true,
                                                  boundaryMargin:
                                                      EdgeInsets.all(20),
                                                  minScale: 0.5,
                                                  maxScale: 4,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        _pictures[index].picURL,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  right: 10,
                                                  child: IconButton(
                                                    icon: Icon(Icons.close,
                                                        color: Colors.white,
                                                        size: 30),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: _MemoryCard(
                                      revealed: _revealedCards[index],
                                      imageUrl: _pictures[index].picURL,
                                      isMatched: _matchedCards[index],
                                      picDetail: _pictures[index].picDetail,
                                      index: index,
                                      onCardTap:
                                          _handleCardTap, 
                                    ),
                                  );
                                }),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MemoryCard extends StatelessWidget {
  final bool revealed;
  final bool isMatched;
  final String imageUrl;
  final String picDetail;
  final int index;
  final Function(int) onCardTap; 

  const _MemoryCard({
    required this.revealed,
    required this.isMatched,
    required this.imageUrl,
    required this.picDetail,
    required this.index, 
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
            onTap: () => onCardTap(index),
            onDoubleTap: () {
              if (revealed) {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        InteractiveViewer(
                          panEnabled: true,
                          boundaryMargin: EdgeInsets.all(20),
                          minScale: 0.5,
                          maxScale: 4,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: Icon(Icons.close,
                                color: Colors.white, size: 30),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            child: Card(
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: revealed
                      ? _CardFace(
                          imageUrl: imageUrl,
                          isMatched: isMatched,
                          picDetail: picDetail,
                        )
                      : const _CardBack(),
                ),
              ),
            ));
      },
    );
  }
}

class _CardFace extends StatelessWidget {
  final String imageUrl;
  final bool isMatched;
  final String picDetail;

  const _CardFace(
      {required this.imageUrl,
      required this.isMatched,
      required this.picDetail});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            border:
                isMatched ? Border.all(color: Colors.green, width: 3) : null,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(

                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),

                child: Text.rich(
                  TextSpan(
                    children: picDetail.split(" ").map((word) {
                      final hasUnderline = word.contains("*");
                      final cleanedWord = word.replaceAll("*", ""); 
                      return TextSpan(
                        text: "$cleanedWord",
                        style: hasUnderline
                            ? TextStyle(decoration: TextDecoration.underline)
                            : null,
                      );
                    }).toList(),
                    style: GoogleFonts.chakraPetch(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          color: Colors.yellowAccent.withOpacity(0.2),
                          blurRadius: 5,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/starcard.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
        );
      },
    );
  }
}
