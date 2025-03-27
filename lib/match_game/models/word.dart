
import 'package:flutter_application_0/database/database_helper_matchcard.dart';

class Word {
  final int id;
  final String descrip;
  final List<int> contents;
  final int fcID;
  bool displayText;

  Word({
    required this.id,
    required this.descrip,
    required this.contents,
    required this.fcID,
    this.displayText = false,
  });

  factory Word.fromMap(Map<String, dynamic> map) => Word(
    id: map[DatabaseHelper.columnId],
    descrip: map[DatabaseHelper.columnDescrip],
    contents: map[DatabaseHelper.columnContents],
    fcID: map[DatabaseHelper.columnFCID],
  );
}