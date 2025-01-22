import 'package:flutter/material.dart';
import 'package:flutter_application_0/services/question_service.dart';
import 'package:flutter_application_0/models/quiz_data.dart';
import 'package:flutter_application_0/screens/quiz_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Delete existing database to ensure clean slate
    String path = join(await getDatabasesPath(), 'word2.db');
    await deleteDatabase(path);
    
    // Create new database
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        print('Creating database and tables...');
        
        // Create table
        await db.execute('''
          CREATE TABLE Vocabulary (
            vocabID INTEGER PRIMARY KEY AUTOINCREMENT,
            syllable INTEGER NOT NULL,
            vocab TEXT NOT NULL,
            gradeID INTEGER NOT NULL,
            endingSound TEXT
          )
        ''');
        
        print('Table created successfully');

        // Insert initial data
        final List<Map<String, dynamic>> initialData = [
          {'syllable': 2, 'vocab': 'น้ำลึก', 'gradeID': 1, 'endingSound': 'แม่กก'},
          {'syllable': 2, 'vocab': 'เล่นเกม', 'gradeID': 1, 'endingSound': 'แม่กม'},
          {'syllable': 2, 'vocab': 'ร้อนแรง', 'gradeID': 1, 'endingSound': 'แม่กง'},
          {'syllable': 2, 'vocab': 'ท้องฟ้า', 'gradeID': 1, 'endingSound': ''},
          {'syllable': 2, 'vocab': 'สบาย', 'gradeID': 1, 'endingSound': 'แม่เกย'},
          {'syllable': 2, 'vocab': 'ขนมไทย', 'gradeID': 1, 'endingSound': 'แม่เกย'},
          {'syllable': 2, 'vocab': 'บ้านสวน', 'gradeID': 1, 'endingSound': 'แม่กน'},
          {'syllable': 2, 'vocab': 'ขยัน', 'gradeID': 1, 'endingSound': 'แม่กน'},
        ];

        // Insert data one by one and verify
        for (var data in initialData) {
          int id = await db.insert('Vocabulary', data);
          print('Inserted row with ID: $id');
        }
        
        // Verify data insertion
        final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM Vocabulary')
        );
        print('Total records in database: $count');
      },
    );

    // Verify database setup
    final List<Map<String, dynamic>> tables = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'"
    );
    print('Tables in database: ${tables.map((t) => t['name']).toList()}');

    // Initialize services
    final questionService = QuestionService(database);
    
    // Test database connection
    try {
      await questionService.checkDatabaseConnection();
      print('Database connection successful');
    } catch (e) {
      print('Database connection test failed: $e');
      throw e;
    }

    // Create quiz data
    final quizData = QuizData(
      questionService: questionService,
      questionCount: 5,
      gradeID: 1,
    );

    // Run app
    runApp(MaterialApp(
      home: QuizScreen(quizData: quizData),
      debugShowCheckedModeBanner: false,
    ));
    
  } catch (e, stackTrace) {
    print('Error during initialization: $e');
    print('Stack trace: $stackTrace');
    // Run a minimal app to show error
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('เกิดข้อผิดพลาดในการเริ่มต้นแอป: $e'),
        ),
      ),
    ));
  }
}