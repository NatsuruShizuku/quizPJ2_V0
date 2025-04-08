import 'package:flutter/material.dart';

class GameBestTimeMobile extends StatelessWidget {
  const GameBestTimeMobile({
    required this.bestTime,
    required this.rows,
    required this.cols,
    super.key,
  });

  final int bestTime;
  final int rows;
  final int cols;

  String _formatBestTime(int seconds) =>
      Duration(seconds: seconds).toString().split('.').first.padLeft(8, "0");

//  @override
// Widget build(BuildContext context) {
//   final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//   return Card(
//     margin: EdgeInsets.symmetric(
//       vertical: isPortrait ? 8 : 4,
//       horizontal: isPortrait ? 20 : 10,
//     ),
//     elevation: 8,
//     shadowColor: Colors.green[800],
//     clipBehavior: Clip.antiAlias,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(16),
//     ),
//     child: Container(
//       constraints: BoxConstraints(
//         maxWidth: isPortrait ? 180 : 140, // ปรับขนาดสูงสุด
//         minHeight: 60, // กำหนดความสูงขั้นต่ำ
//       ),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.green[700]!, Colors.green[900]!],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//           vertical: isPortrait ? 6 : 4, horizontal: isPortrait ? 10 : 6),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // ปรับส่วนแสดงขนาดกริด
//             FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(
//                 // '${rows}x${cols}',
//                 'เวลาที่ดีที่สุด',
//                 style: TextStyle(
//                   fontSize: isPortrait ? 14 : 12,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   shadows: [Shadow(color: Colors.black, blurRadius: 1)],
//                 ),
//               ),
//             ),
//             SizedBox(height: isPortrait ? 2 : 1),
//             // ปรับส่วนเวลา
//             Flexible(
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.emoji_events,
//                     size: isPortrait ? 18 : 14,
//                     color: Colors.amber[300],
//                   ),
//                   SizedBox(width: isPortrait ? 6 : 3),
//                   Flexible(
//                     child: FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Text(
//                         bestTime > 0 ? _formatBestTime(bestTime) : "--:--:--",
//                         style: TextStyle(
//                           fontSize: isPortrait ? 18 : 16,
//                           color: Colors.amber[100],
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.8,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
// }
@override
Widget build(BuildContext context) {
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  return Card(
    margin: EdgeInsets.symmetric(
      vertical: isPortrait ? 8 : 4,
      horizontal: isPortrait ? 20 : 10,
    ),
    elevation: 10,
    shadowColor: Colors.orange[800],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Container(
      constraints: BoxConstraints(
        maxWidth: isPortrait ? 200 : 160,
        minHeight: 70,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[400]!, Colors.yellow[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 3,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: isPortrait ? 24 : 18,
                color: Colors.white,
              ),
              SizedBox(width: 4),
              Text(
                'สถิติเวลา',
                style: TextStyle(
                  fontSize: isPortrait ? 16 : 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BubblegumSans',
                  shadows: [
                    Shadow(
                      color: Colors.purple,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // SizedBox(height: 4),
          Text(
            bestTime > 0 ? _formatBestTime(bestTime) : "--:--:--",
            style: TextStyle(
              fontSize: isPortrait ? 19 : 17,
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontFamily: 'DigitalDisco',
              shadows: [
                  Shadow(
                    color: Colors.purple[800]!,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    ),
  );
}
}