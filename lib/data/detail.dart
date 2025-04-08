import 'package:flutter/material.dart';
import 'package:flutter_application_0/data/minigame.dart';
import 'package:flutter_application_0/database/database_helper_matchcard.dart';
import 'package:flutter_application_0/models/model_info.dart';
import 'package:google_fonts/google_fonts.dart';

class Details extends StatefulWidget {
  const Details({
    super.key,
    required this.topic,
  });
  final Information topic;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  
  Future<String?> _getImageUrl() async {
    if (widget.topic.fcID == 0) {
      return widget.topic.image; // คืนค่า asset path
    } else {
      final pictures =
          await DatabaseHelper.getPicturesByFcID(widget.topic.fcID);
      if (pictures.isEmpty) return null;
      pictures.shuffle(); // สุ่มรูป
      return pictures.first.picURL; // คืนค่า URL จากฐานข้อมูล
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: widget.topic.bgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30),
              child: CustomButton(
                minheight: 50,
                minwidth: 50,
                icon: Icons.arrow_back_ios_new,
                onpressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // Center(
            //   child: SizedBox(
            //     height: height * 0.4,
            //     child: Hero(
            //       tag: widget.topic.image,
            //       child: Image.asset(widget.topic.image),
            //     ),
            //   ),
            // ),
            Center(
              child: FutureBuilder<String?>(
                future: _getImageUrl(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: height * 0.4,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('ไม่พบรูปภาพ');
                  } else {
                    final imageUrl = snapshot.data!;
                    return SizedBox(
                      height: height * 0.4,
                      child: Hero(
                        tag: imageUrl,
                        child: imageUrl.startsWith('assets/')
                            ? Image.asset(imageUrl) // แสดงรูป Asset
                            : Image.network(imageUrl), // แสดงรูปจาก Database
                      ),
                    );
                  }
                },
              ),
            ),
            
            Container(
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // หดขนาดตามเนื้อหา
                  children: [
                    Text(
                      widget.topic.subtitle,
                      style: GoogleFonts.chakraPetch(
                        fontSize: 22,
                        color: widget.topic.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // ใช้ Flexible + SingleChildScrollView
                    Flexible(
                      fit: FlexFit.loose, // อนุญาตให้มีขนาดเล็กกว่าพื้นที่เหลือ
                      child: SingleChildScrollView(
                        physics:
                            const AlwaysScrollableScrollPhysics(), // เปิดการเลื่อนเสมอ
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // หดตามเนื้อหา
                          children: [
                            Text(
                              widget.topic.description,
                              style: GoogleFonts.chakraPetch(
                                fontSize: 22,
                                color: widget.topic.color,
                              ),
                            ),
                            const SizedBox(height: 30),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                              // child: MiniGame(),
                              child: MiniGame(fcID: widget.topic.fcID)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onpressed,
    required this.minheight,
    required this.minwidth,
    required this.icon,
  });
  final VoidCallback onpressed;
  final double minheight;
  final double minwidth;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onpressed,
      constraints: BoxConstraints(
        minHeight: minheight,
        minWidth: minwidth,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      fillColor: Colors.white,
      child: Icon(icon),
    );
  }
}
