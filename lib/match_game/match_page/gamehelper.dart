import 'package:flutter_application_0/database/database_helper_matchcard.dart';
import 'package:flutter_application_0/models/picture.dart';

class GameHelper {

  static Future<List<Picture>> generateGamePairs(int rows, int cols) async {
    final totalPairs = (rows * cols) ~/ 2;
    final allPictures = await DatabaseHelper.getMatchedPairs();

    final fcGroups = <int, List<Picture>>{};
    for (final picture in allPictures) {
      fcGroups.update(
        picture.fcID,
        (list) => list..add(picture),
        ifAbsent: () => [picture],
      );
    }

    final validGroups = fcGroups.values.where((g) => g.length >= 2).toList();

    if (validGroups.isEmpty) {
      throw Exception('ไม่มีภาพคู่ในฐานข้อมูล');
    }

    if (validGroups.length < totalPairs) {
      throw Exception('ภาพคู่ไม่เพียงพอสำหรับสร้างเกม $rows x $cols');
    }

    validGroups.shuffle();
    final selectedPairs = validGroups.sublist(0, totalPairs);

    final gamePictures = <Picture>[];
    for (final group in selectedPairs) {
      group.shuffle();
      gamePictures.addAll(group.take(2));
    }

    gamePictures.shuffle();
    return gamePictures;
  }
}
