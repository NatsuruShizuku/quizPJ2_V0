import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/match_game/animation/spin_animation.dart';
import 'package:flutter_application_0/match_game/pages/game_level.dart';
import 'package:flutter_application_0/match_game/pages/match_menu.dart';

const messages = ['ยอดเยี่ยม!', 'สุดยอด!', 'เยี่ยม!', 'ดี!'];

class ReplayPopUp extends StatelessWidget {
  final int matchedPairs;

  const ReplayPopUp({Key? key, required this.matchedPairs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final r = Random().nextInt(messages.length);
    String message = messages[r];

    return SpinAnimation(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 20,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 17, 173, 208),
                Color.fromARGB(255, 2, 123, 245)
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 36),
                  const SizedBox(width: 10),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Colors.white, Color(0xFFFFE7D0)],
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

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
                    "assets/images/ending.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+ จับคู่สำเร็จ $matchedPairs คู่',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black45,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      label: 'เล่นอีกครั้ง!',
                      icon: Icons.replay,
                      color: Colors.lime,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const GameLevel(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      label: 'ออกจากเกม',
                      icon: Icons.home,
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MatchMenu()),
                        );
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

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required MaterialColor color,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
