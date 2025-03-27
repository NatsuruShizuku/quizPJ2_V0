
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

  static Future<void> copyDatabaseFromAssets(String destinationPath) async {
    try {
      ByteData data = await rootBundle.load('assets/$_dbName');
      List<int> bytes = data.buffer.asUint8List();
      await File(destinationPath).writeAsBytes(bytes, flush: true);
    } catch (e) {
      throw Exception("Error copying database from assets: $e");
    }
  }

  static Future<List<Vocabulary>> getVocabularies() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT Vocabulary.*, FinalConsonants.fcTEXT 
      FROM Vocabulary 
      INNER JOIN FinalConsonants ON Vocabulary.fcID = FinalConsonants.fcID
    ''');

    return maps.map((map) => Vocabulary(
      vocabID: map['vocabID'],
      syllable: map['syllable'],
      vocab: map['vocab'],
      fcText: map['fcTEXT'],
      fcID: map['fcID'],
      modeID: map['modeID'],
    )).toList();
  }

  static Future<List<QuestionM>> getQuestions() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('QuestionM');

    return maps.map((map) => QuestionM(
      questionID: map['questionID'],
      questionText: map['questionTEXT'],
    )).toList();
  }

  static Future<List<FinalConsonants>> getFinalConsonants() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('FinalConsonants');

    return maps.map((map) => FinalConsonants(
      fcID: map['fcID'],
      fcText: map['fcTEXT'],
    )).toList();
  }


}
