
import 'dart:typed_data';

class Picture {
  final int picID;
  final String picDetail;
  final String picURL;
  final int fcID;

  Picture({
    required this.picID,
    required this.picDetail,
    required this.picURL,
    required this.fcID,
  });

  factory Picture.fromMap(Map<String, dynamic> map) {
    return Picture(
      picID: map['picID'],
      picDetail: map['picDetail'],
      picURL: map['picURL'],
      fcID: map['fcID'],
    );
  }
}