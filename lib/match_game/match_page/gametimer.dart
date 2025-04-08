import 'package:flutter/material.dart';

class GameTimerMobile extends StatelessWidget {
  const GameTimerMobile({
    required this.time,
    super.key,
  });

  final Duration time;

  String _formatTime(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0");

@override
Widget build(BuildContext context) {
  final isPortrait =
      MediaQuery.of(context).orientation == Orientation.portrait;
  return Card(
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:  [Colors.orange[400]!, Colors.yellow[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 3,
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.hourglass_bottom,
              size: isPortrait ? 26 : 22,
              color: Colors.white,
            ),
            SizedBox(width: 4),
            Text(
              _formatTime(time),
              style: TextStyle(
                fontSize: isPortrait ? 20 : 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'DigitalDisco',
                shadows: [
                  Shadow(
                    color: Colors.purple[800]!,
                    blurRadius: 6,
                    offset: Offset(2, 2),
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