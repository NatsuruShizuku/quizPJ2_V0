import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Information {
  String subtitle;
  String description;
  String image;

  Color color;
  Color bgColor;

  double height;
  int fcID;

  Information({
    required this.subtitle,
    required this.description,
    required this.image,
    required this.color,
    required this.bgColor,
    required this.height,
    required this.fcID,
  });
}

List<Information> TopicNum() {
  return <Information>[
    Information(
      description: 'เป็นพยัญชนะที่ใช้บังคับเสียงท้ายคำ\nหรือพยัญชนะที่ประกอบอยู่ท้ายสระ\nและมีเสียงประสมเข้ากับสระ',
      subtitle: 'ตัวสะกด',
      image: 'assets/pic/Topic1.png',
      color: Colors.red,
      bgColor: Colors.red[100]!,
      height: 200.0,
      fcID: 0,
    ),
    Information(
      description: 'แบ่งออกเป็น ๒ ประเภท คือ\n๑.มาตราตัวสะกดไม่ตรงรูปมี ๔ มาตรา คือ\nแม่กก , แม่กด , แม่กน , แม่กบ \n๒.มาตราตัวสะกดตรงรูปมี ๔ มาตราคือ\nแม่กง , แม่กม , แม่เกอว , แม่เกย ',
      subtitle: 'มาตราตัวสะกดมีอยู่ ๘ มาตรา',
      image: 'assets/pic/Topic2.png',
      color: Colors.amber,
      bgColor: Colors.amberAccent[700]!,
      height: 200.0,
      fcID: 0,
    ),
    Information(
      description: 'หรือ คำที่อ่านออกเสียง "ง" เป็นตัวสะกด\nเช่น ลิง, ม่วง, กางเกง, ช้าง, เลี้ยง, ทุ่ง',
      subtitle: 'แม่กง คือ คำที่ลงท้ายด้วย ง',
      image: 'assets/pic/Topic3.png',
      color: Colors.orange,
      bgColor: Colors.orange[100]!,
      height: 200.0,
      fcID: 8,
    ),
     Information(
      description: 'หรือ คำที่อ่านออกเสียง "ม" เป็นตัวสะกด\nเช่น ส้ม, อุ้ม, ส้อม, ซ่อม, ธรรม, กลม',
      subtitle: 'แม่กม คือ คำที่ลงท้ายด้วย ม',
      image: 'assets/pic/Topic4.png',
      color: Colors.lightBlue,
      bgColor: Colors.lightBlue[100]!,
      height: 200.0,
      fcID: 1,
    ),
    Information(
      description: 'หรือ คำที่อ่านออกเสียง "ย" เป็นตัวสะกด\nเช่น ขลุ่ย, โกย, ยาย, เนย, เตย, สร้อย, ขาย',
      subtitle: 'แม่เกย คือ คำที่ลงท้ายด้วย ย',
      image: 'assets/pic/Topic5.png',
      color: Colors.green,
      bgColor: Colors.green[100]!,
      height: 200.0,
      fcID: 3,
    ),
     Information(
      description: 'หรือ คำที่อ่านออกเสียง "ว" เป็นตัวสะกด\nเช่น งิ้ว , แมว, ว่าว, เที่ยว, เขียว',
      subtitle: 'แม่เกอว คือ คำที่ลงท้ายด้วย ว',
      image: 'assets/pic/Topic6.png',
      color: Colors.pinkAccent,
      bgColor: Colors.pinkAccent[100]!,
      height: 200.0,
      fcID: 4,
    ),
    Information(
      description: 'หรือ คำที่อ่านออกเสียงเหมือน "ก"\nเป็นตัวสะกด เช่น กระจก อ่านว่า กระ-จก,\nสุนัข อ่านว่า สุ-นัก ,พรรค อ่านว่า พัก,\nเมฆ อ่านว่า เมก',
      subtitle: 'แม่กก คือ คำที่สะกดด้วย ก ข ค ฆ',
      image: 'assets/pic/Topic7.png',
      color: Colors.purpleAccent,
      bgColor: Colors.purpleAccent[100]!,
      height: 200.0,
      fcID: 7,
    ),
    Information(
      description: 'หรือ คำที่อ่านออกเสียงเหมือน "ด"\n เป็นตัวสะกด เช่น เสร็จ อ่านว่า เส็ด,\nอัฐ อ่านว่า อัด , บวช อ่านว่า บวด,\nอนุญาต อ่านว่า อนุ-ยาด',
      subtitle: 'แม่กด คือ คำที่สะกดด้วย จ ช ซ ฎ ฏ ฐ ฑ \nฒ ด ต ถ ท ธ ศ ษ ส',
      image: 'assets/pic/Topic8.png',
      color: Colors.brown,
      bgColor: Colors.brown[100]!,
      height: 200.0,
      fcID: 6,
    ),
    Information(
      description: 'หรือ คำที่อ่านออกเสียงเหมือน "น"\nเป็นตัวสะกด เช่น ขวัญ อ่านว่า ขวัน,\nจร อ่านว่า จอน , วาฬ อ่านว่า วาน,\nโบราณ อ่านว่า โบ-ราน',
      subtitle: 'แม่กน คือ คำที่สะกดด้วย ญ ณ น ร ล ฬ ',
      image: 'assets/pic/Topic9.png',
      color: Colors.blueAccent,
      bgColor: Colors.blueAccent[100]!,
      height: 200.0,
      fcID: 2,
    ),
    Information(
      description: 'หรือ คำที่อ่านออกเสียงเหมือน "บ"\nเป็นตัวสะกด เช่น รูป อ่านว่า รูบ ,\nโลภ อ่านว่า โลบ , เสิร์ฟ อ่านว่า เสิบ ,\nธูป อ่านว่า ทูบ',
      subtitle: 'แม่กบ คือ คำที่สะกดด้วย บ ป พ ฟ ภ',
      image: 'assets/pic/Topic10.png',
      color: Colors.lightGreen,
      bgColor: Colors.greenAccent[400]!,
      height: 200.0,
      fcID: 5,
    ),
  ];
}