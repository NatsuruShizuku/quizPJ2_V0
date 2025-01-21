class ThaiWordUtils {
  // Map เก็บความสัมพันธ์ระหว่างพยัญชนะท้ายและมาตราตัวสะกด
  static final Map<String, String> endingSoundMap = {
    'ก': 'แม่กก',
    'ด': 'แม่กด',
    'บ': 'แม่กบ',
    'น': 'แม่กน',
    'ม': 'แม่กม',
    'ย': 'แม่เกย',
    'ว': 'แม่เกอว',
    'ง': 'แม่กง',
  };

  // ฟังก์ชันตรวจสอบมาตราตัวสะกด
  static String? getEndingSound(String word) {
    if (word.isEmpty) return null;
    
    // ตรวจสอบตัวสะกดจากตัวอักษรท้าย
    String lastChar = word.substring(word.length - 1);
    return endingSoundMap[lastChar];
  }

  // ฟังก์ชันตรวจสอบว่าคำมีมาตราตัวสะกดเดียวกันหรือไม่
  static bool hasSameEnding(String word1, String word2) {
    String? ending1 = getEndingSound(word1);
    String? ending2 = getEndingSound(word2);
    return ending1 != null && ending1 == ending2;
  }
}