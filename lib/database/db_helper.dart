
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_application_0/const/const.dart';
import 'package:flutter_application_0/models/question1.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('word6.db');
    return _database!;
  }

 Future<void> copyDatabaseIfNotExists() async {
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, 'word6.db');

  // บังคับให้คัดลอกทับฐานข้อมูลเดิม
  try {
    await File(path).delete();
  } catch (_) {}

  print('Copying database from assets...');
  try {
    final data = await rootBundle.load('assets/db/word6.db');
    final bytes = data.buffer.asUint8List();
    await File(path).writeAsBytes(bytes);
    print('Database copied successfully.');
  } catch (e) {
    print('Error copying database: $e');
  }
}

  // Future<Database> _initDB(String filePath) async {
  //   final path = join(await getDatabasesPath(), filePath);
  //   return await openDatabase(
  //     path,
  //     version: 1,
  //     // onCreate: _createDB,
  //   );
  // }

  // Future<Database> _initDB(String filePath) async {
  //   final path = join(await getDatabasesPath(), filePath);

  //   // เรียกใช้ฟังก์ชันคัดลอกฐานข้อมูลหากยังไม่มี
  //   await copyDatabaseIfNotExists();

  //   // เปิดฐานข้อมูล
  //   return await openDatabase(path, version: 2);
  // }
Future<Database> _initDB(String filePath) async {
  final path = join(await getDatabasesPath(), filePath);
  await copyDatabaseIfNotExists();

  return await openDatabase(path, 
    version: 2,
    // onCreate: (db, version) async {
    //   // สร้างตาราง Vocabulary ถ้าไม่มี
    //   await db.execute('''
    //     CREATE TABLE IF NOT EXISTS Vocabulary (
    //       vocabID INTEGER PRIMARY KEY AUTOINCREMENT,
    //       syllable INTEGER NOT NULL,
    //       vocab TEXT NOT NULL,
    //       gradeID INTEGER NOT NULL,
    //     )
    //   ''');
    // },
  );
}

Future<void> checkDatabaseConnection() async {
  try {
    final db = await database;
    final tables = await db.rawQuery("SELECT vocab FROM Vocabulary WHERE vocab='table'");
    print('Tables in database: $tables');
    
    final vocabCount = await db.rawQuery("SELECT COUNT(*) FROM Vocabulary");
    print('Vocabulary table row count: $vocabCount');
  } catch (e) {
    print('Database connection error: $e');
  }
}

  Future<Database> connectedDatabase() async{
    return openDatabase(join(await getDatabasesPath(), dbName));
  }
  // Future<List<Question1>> readAllDataFromSQLite() async{
  //   Database database = await connectedDatabase();
  //   List<Question1> questionModels = List();

  //   List<Map<String, dynamic>> maps = await database.query(tableQuizName);
  //   for(var map in maps){
  //     Question1 questionModel = Question1.fromMap(Question1).toList;
  //     questionModels.add(questionModel);
  //   }

  //   return questionModels;
  // }

Future<Map<String, dynamic>> getRandomWord() async {
  final db = await database;
  final List<Map<String, dynamic>> words = await db.rawQuery(
    'SELECT vocab FROM Vocabulary ORDER BY RANDOM() LIMIT 1' // Corrected table name
  );
  if (words.isNotEmpty) {
    return words.first;
  } else {
    throw Exception("ไม่พบข้อมูลในฐานข้อมูล");
  }
}

Future<Map<String, dynamic>> getRandomMatra() async {
  final db = await database;
  final List<Map<String, dynamic>> words = await db.rawQuery(
    'SELECT matraDetail FROM Matra ORDER BY RANDOM() LIMIT 1' // Corrected table name
  );
  if (words.isNotEmpty) {
    return words.first;
  } else {
    throw Exception("ไม่พบข้อมูลในฐานข้อมูล");
  }
}

}

//   Future<List<Map<String, dynamic>>> fetchVocabulary() async {
//     final db = await database;
//     return await db.query('Vocabulary');
//   }
// }