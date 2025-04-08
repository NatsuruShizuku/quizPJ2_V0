import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_0/match_game/match_page/gameboard.dart';
import 'package:flutter_application_0/match_game/match_page/gamehelper.dart';

import 'package:shared_preferences/shared_preferences.dart';


class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // เพิ่มเมธอดตรวจสอบสถานะการเล่น
  Future<bool> _getLevelCompletionStatus(int rows, int cols) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('level_${rows}x${cols}') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('เกมจับคู่คำศัพท์',
            style: TextStyle(
                fontFamily: 'BubblegumSans',
                fontSize: 24,
                color: Colors.white)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF96C5), Color(0xFF7BD3FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE1F5FE), Color(0xFFF0F4C3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/background2.png"),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isPortrait ? 16.0 : 8.0),
          child: GridView.count(
            crossAxisCount: isPortrait ? 2 : 4,
            mainAxisSpacing: isPortrait ? 20 : 10,
            crossAxisSpacing: isPortrait ? 20 : 10,
            children: [
              _buildSizeButton('2x2 🐾', 2, 2),
              _buildSizeButton('2x3 🌸', 2, 3),
              _buildSizeButton('2x4 🎨', 2, 4),
              _buildSizeButton('3x4 🍭', 3, 4),
              _buildSizeButton('4x4 🚀', 4, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSizeButton(String label, int rows, int cols) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 3,
          )
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 25),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF7BD3FF),
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        onPressed: () async {
          try {
            final pictures = await GameHelper.generateGamePairs(rows, cols);
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GameBoard(
                  rows: rows,
                  cols: cols,
                  pictures: pictures,
                ),
              ),
            ).then((_) {
              setState(() {});
            });
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: FutureBuilder<bool>(
          future: _getLevelCompletionStatus(rows, cols),
          builder: (context, snapshot) {
            bool isComplete = snapshot.data ?? false;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label.split(' ')[0],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DigitalDisco',
                    shadows: [
                      Shadow(
                        color: Colors.pink,
                        blurRadius: 5,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                Text(
                  label.split(' ')[1],
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Icon(
                      isComplete ? Icons.star : Icons.star_border,
                      size: 28,
                      color: isComplete ? Colors.amber : Colors.grey[400],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
