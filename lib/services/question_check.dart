import 'package:flutter/material.dart';

class WordCheck extends StatelessWidget {
  const WordCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WordCheckScreen(),
    );
  }
}

class WordCheckScreen extends StatefulWidget {
  @override
  _WordCheckScreenState createState() => _WordCheckScreenState();

  processThaiWordEnding(String vocab) {}

  identifyThaiCategory(lastConsonant) {}
}

class _WordCheckScreenState extends State<WordCheckScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = "";

 String processThaiWordEnding(String word) {
  if (word.isEmpty) return 'ไม่มีพยัญชนะ';

  final List<String> consonants = [
    'ก', 'ข', 'ค', 'ฆ',
    'ง',
    'ด', 'ต', 'ถ', 'ท', 'ธ', 'จ', 'ธ', 'ฎ', 'ฏ', 'ฑ', 'ฒ', 'ช', 'ซ', 'ศ', 'ษ', 'ส',
    'น', 'ณ', 'ญ', 'ร', 'ล', 'ฬ',
    'บ', 'ป', 'พ', 'ฟ', 'ภ',
    'ม',
    'ย',
    'ว',
  ];

  final List<String> vowels = [
    'ะ', 'ั', 'า', 'ิ', 'ี', 'ึ', 'ื', 'ุ', 'ู',
    'เ', 'แ', 'โ', 'ใ', 'ไ','อ'
  ];

  final List<String> specialMarks = ['์']; // การันต์
  final List<String> toneMarks = ['่', '้', '๊', '๋']; // วรรณยุกต์

  String? lastConsonant;
  bool isLastVowel = false;

  for (int i = word.length - 1; i >= 0; i--) {
    String currentChar = word[i];

    // ตรวจสอบว่าตัวสุดท้ายเป็นสระ → แม่ ก กา
    if (vowels.contains(currentChar)) {
      isLastVowel = true;
      break;
    }

    // ข้ามตัวที่เป็นวรรณยุกต์
    if (toneMarks.contains(currentChar)) {
      isLastVowel = true;
      break;
    }

if (i > 0 && specialMarks.contains(currentChar) && vowels.contains(word[i - 1])) {
      i--; // ข้ามสระก่อนการันต์
      continue;
    }
    // ข้ามพยัญชนะที่มีการันต์ เช่น "ท" ใน "พันธุ์"
    if (i < word.length - 1 && specialMarks.contains(word[i + 2])) continue;
    // ตรวจสอบว่าตัวอักษรปัจจุบันเป็นพยัญชนะ
    if (consonants.contains(currentChar)) {
      lastConsonant = currentChar;
      break; // หยุดทันทีที่เจอพยัญชนะตัวสุดท้าย
    }
  }

  // หากตัวสุดท้ายเป็นสระ → แม่ ก กา
  if (isLastVowel) {
    return 'แม่ ก กา';
  }

  // หากมีพยัญชนะตัวสุดท้าย → คืนค่าพยัญชนะ
  return lastConsonant ?? 'ไม่มีพยัญชนะ';
}

String identifyThaiCategory(String consonant) {
  if (consonant == 'แม่ ก กา') {
    return 'แม่ ก กา'; // กรณีไม่มีตัวสะกด หรือมีวรรณยุกต์
  }

  final Map<String, String> categories = {
    'ก': 'แม่กก',
    'ข': 'แม่กก',
    'ค': 'แม่กก',
    'ฆ': 'แม่กก',
    'ง': 'แม่กง',
    'จ': 'แม่กด',
    'ช': 'แม่กด',
    'ญ': 'แม่กน',
    'ด': 'แม่กด',
    'ต': 'แม่กด',
    'ถ': 'แม่กด',
    'ท': 'แม่กด',
    'ธ': 'แม่กด',
    'น': 'แม่กน',
    'ณ': 'แม่กน',
    'บ': 'แม่กบ',
    'ป': 'แม่กบ',
    'พ': 'แม่กบ',
    'ฟ': 'แม่กบ',
    'ภ': 'แม่กบ',
    'ม': 'แม่กม',
    'ย': 'แม่เกย',
    'ร': 'แม่กน',
    'ล': 'แม่กน',
    'ว': 'แม่เกอว',
    'ส': 'แม่กด',
    'ศ': 'แม่กด',
    'ษ': 'แม่กด',
    'ฬ': 'แม่กน',
  };

  return categories[consonant] ?? 'ไม่พบมาตราตัวสะกด';
}

  void processWord() {
    String input = _controller.text;
    if (input.isEmpty) {
      setState(() {
        _result = "กรุณากรอกคำภาษาไทย";
      });
      return;
    }

    String lastConsonant = processThaiWordEnding(input);
    String category = identifyThaiCategory(lastConsonant);

    setState(() {
      _result = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
