
import 'package:flutter/material.dart';
import 'package:flutter_application_0/match_game/pages/game_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameLevel extends StatelessWidget {
  // final bool hasImage; // รับค่าจาก SelectGame
  // const GameLevel({super.key, required this.hasImage});
  const GameLevel({super.key});

  // ฟังก์ชันสำหรับดึงสถานะของด่านจาก SharedPreferences
  Future<bool> _getLevelCompletionStatus(int rows, int columns) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('level_${rows}x${columns}') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, int>> levelSettings = [
      {'rows': 2, 'columns': 2}, // 4 tiles
      {'rows': 2, 'columns': 3}, // 6 tiles
      {'rows': 2, 'columns': 4}, // 8 tiles
      {'rows': 3, 'columns': 4}, // 12 tiles
      {'rows': 4, 'columns': 4}, // 16 tiles
    ];

    // กำหนดชุดสีให้แต่ละปุ่ม (ถ้ามีปุ่มมากกว่าจำนวนสี จะวนกลับ)
    final List<Color> buttonColors = [
      Colors.redAccent,
      Colors.pinkAccent,
      Colors.blueAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกระดับเกม'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFF81D4FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // กำหนดให้ Grid แสดงผลเป็น 2 คอลัมน์
            const int crossAxisCount = 2;
            final int totalItems = levelSettings.length; // จำนวนรายการ
            final int rowCount = (totalItems / crossAxisCount).ceil(); // จำนวนแถว

            // กำหนด spacing ระหว่างปุ่ม
            const double crossAxisSpacing = 10;
            const double mainAxisSpacing = 10;

            // คำนวณความสูงที่มีอยู่จริงหลังจากหัก spacing และ padding แนวตั้ง
            double totalSpacingHeight = mainAxisSpacing * (rowCount - 1);
            double availableHeight = constraints.maxHeight - totalSpacingHeight - 20; // หัก padding แนวตั้ง
            double itemHeight = availableHeight / rowCount;

            // คำนวณความกว้างของแต่ละปุ่ม
            double totalCrossSpacing = crossAxisSpacing * (crossAxisCount - 1);
            double availableWidth = constraints.maxWidth - 20 - totalCrossSpacing; // หัก padding แนวนอน
            double itemWidth = availableWidth / crossAxisCount;

            // childAspectRatio สำหรับ GridView
            double ratio = itemWidth / itemHeight;

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: ratio,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
              ),
              itemCount: totalItems,
              itemBuilder: (context, index) {
                final level = levelSettings[index];
                final label = '${level['rows']}x${level['columns']}';
                // เลือกสีจาก buttonColors โดยวนกลับตาม index
                final Color buttonColor = buttonColors[index % buttonColors.length];
                return _buildLevelButton(
                  context,
                  label,
                  level['rows']!,
                  level['columns']!,
                  buttonColor,
                );
              },
            );
          },
        ),
      ),
    );
  }

Widget _buildLevelButton(
  BuildContext context,
  String label,
  int rows,
  int columns,
  Color buttonColor,
) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GamePage(
              rows: rows,
              columns: columns,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage('assets/images/button6.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              buttonColor.withOpacity(0.6),
              BlendMode.multiply,
            ),
          ),
        ),
        child: FutureBuilder<bool>(
          future: _getLevelCompletionStatus(rows, columns),
          builder: (context, snapshot) {
            bool isComplete = snapshot.data ?? false;
            return Stack(
              children: [
                // ข้อความและดาว
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 5,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => Icon(
                            isComplete ? Icons.star : Icons.star_border,
                            size: 34,
                            color: isComplete ? Colors.amber : Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Overlay สี
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
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