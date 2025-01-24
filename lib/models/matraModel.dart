class Matramodel {
  final int matraID;
  final String matraDetail;
  

  Matramodel( {
    required this.matraID, // เลขโมเดล
    required this.matraDetail,
  });

  factory Matramodel.fromMap(Map<String, dynamic> map) {
    return Matramodel(
      matraID: map['matraID'],
      matraDetail: map['matraDetail'],
    );
  }
}

