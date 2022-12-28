import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_diary/model/diary.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  DiaryModel diaryModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(diaryModel.id.toString())
        ],
      ),
    );
  }
}
