
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_0/database/database_helper.dart';
import 'package:flutter_application_0/models/dataModel.dart';
import 'package:intl/intl.dart';

class HighScoreTableScreen extends StatefulWidget {
  final String mode;

  const HighScoreTableScreen({Key? key, required this.mode}) : super(key: key);

  @override
  _HighScoreTableScreenState createState() => _HighScoreTableScreenState();
}

class _HighScoreTableScreenState extends State<HighScoreTableScreen> {
  late String currentMode;
  late Future<List<HighScore>> _highScoresFuture;
  final List<String> modes = ['Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();
    currentMode = widget.mode;
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _highScoresFuture = DatabaseHelper.getHighScores(currentMode);
    });
  }

  void _navigateMode(int direction) {
    final currentIndex = modes.indexOf(currentMode);
    int newIndex = currentIndex + direction;

    if (newIndex >= 0 && newIndex < modes.length) {
      setState(() {
        currentMode = modes[newIndex];
        _refreshData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = modes.indexOf(currentMode);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ตารางคะแนน - ${_getModeText(currentMode)}',
          style: GoogleFonts.chakraPetch(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        // ลูกศรย้อนกลับอยู่ทางซ้าย (leading)
        leading: currentIndex > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 30, color: Colors.white),
                onPressed: () => _navigateMode(-1),
              )
            : null,
        // ลูกศรไปข้างหน้าและปุ่มรีเฟรชอยู่ทางขวา (actions)
        actions: [
          if (currentIndex < modes.length - 1)
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 30, color: Colors.white),
              onPressed: () => _navigateMode(1),
            ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<HighScore>>(
          future: _highScoresFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'เกิดข้อผิดพลาด: ${snapshot.error}',
                  style: GoogleFonts.chakraPetch(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            final highScores = snapshot.data ?? [];

            if (highScores.isEmpty) {
              return Center(
                child: Text(
                  'ยังไม่มีคะแนนสูงสุด',
                  style: GoogleFonts.chakraPetch(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 40,
                  dataRowHeight: 60,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.deepPurple),
                  columns: [
                    DataColumn(
                      label: Text('อันดับ',
                          style: GoogleFonts.chakraPetch(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    DataColumn(
                      label: Text('ชื่อผู้เล่น',
                          style: GoogleFonts.chakraPetch(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    DataColumn(
                      label: Text('คะแนน',
                          style: GoogleFonts.chakraPetch(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    DataColumn(
                      label: Text('วันที่ทำได้',
                          style: GoogleFonts.chakraPetch(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ],
                  rows: highScores.asMap().entries.map((entry) {
                    final index = entry.key;
                    final score = entry.value;
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color>(
                        (states) => index.isEven
                            ? Colors.deepPurple.shade50
                            : Colors.white,
                      ),
                      cells: [
                        DataCell(Center(
                          child: Text('${index + 1}',
                              style: GoogleFonts.chakraPetch(fontSize: 16)),
                        )),
                        DataCell(Center(
                          child: Text(score.name,
                              style: GoogleFonts.chakraPetch(fontSize: 16)),
                        )),
                        DataCell(Center(
                          child: Text(score.score.toString(),
                              style: GoogleFonts.chakraPetch(fontSize: 16)),
                        )),
                        DataCell(Center(
                          child: Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(score.timeStamp),
                            style: GoogleFonts.chakraPetch(fontSize: 16),
                          ),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getModeText(String mode) {
    switch (mode.toLowerCase()) {
      case 'easy':
        return 'ง่าย';
      case 'medium':
        return 'ปานกลาง';
      case 'hard':
        return 'ยาก';
      default:
        return 'ง่าย';
    }
  }
}
