// import 'package:flutter_application_0/models/newModel.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';

// class DatabaseHelper {
//   static const _dbName = 'new_word1.db';
//   static const _dbVersion = 1;

//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   static Database? _database;
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _dbName);
    
//     ByteData data = await rootBundle.load(join('assets', _dbName));
//     List<int> bytes = data.buffer.asUint8List();
//     await File(path).writeAsBytes(bytes);

//     return await openDatabase(path);
//   }

//  Future<List<QuestionM>> getQuestions() async {
//     Database db = await instance.database;
//     final List<Map<String, dynamic>> maps = await db.query('QuestionM');
//     return maps.map((e) => QuestionM.fromMap(e)).toList();
//   }

//   Future<List<Vocabulary>> getVocabularies() async {
//     Database db = await instance.database;
//     final List<Map<String, dynamic>> maps = await db.rawQuery('''
//       SELECT v.vocabID, v.syllable, v.vocab, v.matraID, m.matraTEXT 
//       FROM Vocabulary v 
//       INNER JOIN Matra m ON v.matraID = m.matraID
//     ''');
//     return maps.map((e) => Vocabulary.fromMap(e)).toList();
//   }
// }

