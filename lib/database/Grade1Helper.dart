
import 'package:flutter_application_0/const/const.dart';
import 'package:flutter_application_0/models/word.dart';
import 'package:sqflite/sqflite.dart';


class Grade1Helper {
  Future<List<Word>> getWord(Database db) async {
    List<Map<String, dynamic>> maps = await db.query(tableQuizName,
        columns: [vocabID, syllableQuiz , vocabQuiz]);
    if (maps.isNotEmpty) {
      return maps.map((vocab) => Word.fromMap(vocab)).toList();
    }
    return List<Word>.empty(growable: true);
  }

  Future close(Database db) async => db.close();
}

/// loading Database