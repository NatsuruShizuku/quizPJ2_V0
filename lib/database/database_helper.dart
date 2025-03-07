
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_0/models/dataModel.dart';

class DatabaseHelper {
  static const String _dbName = 'new_word4.db';


   static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    if (!await databaseExists(path)) {
      await copyDatabaseFromAssets(path);
    }

    final db = await openDatabase(path);

    // สร้างตาราง HighScores หากไม่มี
    await db.execute('''
      CREATE TABLE IF NOT EXISTS HighScores (
        mode TEXT NOT NULL,
        name TEXT NOT NULL,
        score INTEGER NOT NULL,
        timeStamp TEXT NOT NULL
      )
    ''');

    return db;
  }

  static Future<void> insertHighScore(HighScore highScore) async {
    final db = await _initDatabase();
    await db.insert(
      'HighScores',
      highScore.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<HighScore>> getHighScores(String mode) async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'HighScores',
      where: 'mode = ?',
      whereArgs: [mode],
      orderBy: 'score DESC, timeStamp DESC',
    );
    return maps.map(HighScore.fromMap).toList();
  }

  /// Copy the database from assets to the device

  static Future<void> copyDatabaseFromAssets(String destinationPath) async {
    try {
      ByteData data = await rootBundle.load('assets/$_dbName');
      List<int> bytes = data.buffer.asUint8List();
      await File(destinationPath).writeAsBytes(bytes, flush: true);
    } catch (e) {
      throw Exception("Error copying database from assets: $e");
    }
  }

  /// Fetch all vocabularies with their corresponding matra text
  static Future<List<Vocabulary>> getVocabularies() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT Vocabulary.*, Matra.matraTEXT 
      FROM Vocabulary 
      INNER JOIN Matra ON Vocabulary.matraID = Matra.matraID
    ''');

    return maps.map((map) => Vocabulary(
      vocabID: map['vocabID'],
      syllable: map['syllable'],
      vocab: map['vocab'],
      matraText: map['matraTEXT'],
      matraID: map['matraID'],
    )).toList();
  }

  /// Fetch all questions from the QuestionM table
  static Future<List<QuestionM>> getQuestions() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('QuestionM');

    return maps.map((map) => QuestionM(
      questionID: map['questionID'],
      questionText: map['questionTEXT'],
    )).toList();
  }

  /// Fetch all matras from the Matra table
  static Future<List<Matra>> getMatras() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('Matra');

    return maps.map((map) => Matra(
      matraID: map['matraID'],
      matraText: map['matraTEXT'],
    )).toList();
  }

}
