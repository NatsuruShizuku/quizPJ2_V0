

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "word_card1.db";
  static final _databaseVersion = 1;

  static final table = 'card';
  
  static final columnId = 'id';
  static final columnDescrip = 'descrip';
  static final columnContents = 'contents';
  static final columnMatraID = 'matraID';

  static Database? _database;
  
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    if (!await databaseExists(path)) {
      await copyDatabaseFromAssets(path);
    }
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDescrip TEXT NOT NULL,
        $columnContents BLOB NOT NULL,
        $columnMatraID INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> copyDatabaseFromAssets(String destinationPath) async {
    try {
      ByteData data = await rootBundle.load('assets/$_databaseName');
      List<int> bytes = data.buffer.asUint8List();
      await File(destinationPath).writeAsBytes(bytes, flush: true);
    } catch (e) {
      throw Exception("Error copying database from assets: $e");
    }
  }

  // Future<int> insertWord(Map<String, dynamic> row) async {
  //   Database db = await instance.database;
  //   return await db.insert(table, row);
  // }

  Future<List<Map<String, dynamic>>> queryAllWords() async {
    Database db = await instance.database;
    return await db.query(table);
  }
}