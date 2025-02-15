import 'package:flutter/material.dart';
import 'package:flutter_application_0/data/detail.dart';
import 'package:flutter_application_0/models/model_info.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LearningModeScreen extends StatelessWidget {
  const LearningModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'โหมดการเรียนรู้',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Scrollbar(
        child: MasonryGridView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: TopicNum().length,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // จำนวนคอลัมน์ใน Grid
          ),
          itemBuilder: (BuildContext context, int index) {
            final topic = TopicNum()[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(topic: topic),
                  ),
                );
              },
              child: Container(
                height: height * 0.165, // ปรับความสูงสัมพันธ์กับหน้าจอ
                width: width * 0.2, // ปรับความกว้างสัมพันธ์กับหน้าจอ
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: topic.bgColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: topic.image,
                      child: Image.asset(
                        topic.image,
                        height: height * 0.12, // ปรับขนาดของรูปภาพ
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
