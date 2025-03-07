

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/main.dart';
import 'package:flutter_application_0/match_game/animation/spin_animation.dart';
import 'package:flutter_application_0/match_game/pages/game_level.dart';

const messages = ['ยอดเยี่ยม!', 'สุดยอด!', 'เยี่ยม!', 'ดี!'];

class ReplayPopUp extends StatelessWidget {
  final int matchedPairs; // จำนวนคู่ที่จับคู่สำเร็จในรอบนี้

  const ReplayPopUp({Key? key, required this.matchedPairs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final r = Random().nextInt(messages.length);
    String message = messages[r];

    return SpinAnimation(
      child: AlertDialog(
        title: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             SizedBox(
              width: 160,
              height: 160,
              child: Image.asset("assets/images/ending.png"),
            ),
            Text(
              '+ จับคู่สำเร็จ $matchedPairs คู่',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lime[300],
                elevation: 5,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const GameLevel(),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.replay, size: 24,color: Colors.white,),
              label: const Text(
                'เล่นอีกครั้ง!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
