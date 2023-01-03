import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_diary/model/diary.dart';
import 'package:open_diary/page/navbar/home/detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Tab1 extends StatefulWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  final int pageSize = 4;
  late PagewiseLoadController<DiaryModel> pageLoadController;

  final supabase = Supabase.instance.client;

  double  lat = 37.2042, lng = 126.864;
  int likeCount = 0;
  MaterialColor likeColors = Colors.blue;

  Future<void> myLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();

    if(isLocationServiceEnabled == true){
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        lat = position.latitude;
        lng = position.longitude;
      });
    }else{
      Get.snackbar(
        '위치를 활성화 해 주세요.',
        '기본 위치가 경기도로 변경 되었습니다.',
        snackPosition: SnackPosition.TOP,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
    }
  }

  @override
  void initState(){
    myLocation();
    pageLoadController = PagewiseLoadController(
        pageSize: 4,
        pageFuture: (pageIndex) => getPosts(pageIndex! * 4)
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _diaryStream = supabase.from('diary').stream(primaryKey: ['id']).eq('open_diary', true).limit(3).map((maps) => maps
    //     .map((map) => DiaryModel.fromMap(map: map)).toList());
  }

  Future<List<DiaryModel>> getPosts(offset) async {
    print(offset);
    List diaryStream = [];
    if(offset == 0){
      diaryStream = await supabase.from('diary').select().range(0, 3);
    }else{
      diaryStream = await supabase.from('diary').select().range(offset, offset + pageSize -1);
    }
    print(diaryStream);
    var postList = DiaryModel.fromJsonList(diaryStream);
    return postList;
  }

  Widget itemBuilder(context, DiaryModel diaryModel, index) {
      return InkWell(
        onTap: () => Get.to(const DetailPage(), arguments: diaryModel),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25,top: 25, bottom: 15),
              child: Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: diaryModel.feel == '기쁨' ? Colors.red[50] :
                        diaryModel.feel == '행복' ? Colors.yellow[50] :
                        diaryModel.feel == '슬픔' ? Colors.blue[50] :
                        diaryModel.feel == '우울' ? Colors.deepPurple[50] :
                        diaryModel.feel == '분노' ? Colors.red[50] :
                        diaryModel.feel == '후회' ? Colors.grey[100] :
                        diaryModel.feel == '보통' ? Colors.lime[50] :
                        diaryModel.feel == '설렘' ? Colors.orange[100]:
                        Colors.cyan[50],
                      ),
                      height: 35,
                      width: 50,
                      child: Center(
                          child: Text(diaryModel.feel ?? '', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 11,color: Colors.black87))
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(diaryModel.nickName!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                        Text(diaryModel.createDate!.toString(), style: const TextStyle(fontSize: 11, color: Colors.black54),),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),
          if(diaryModel.images.toString() != '[]')Padding(
            padding: const EdgeInsets.only(top: 5,bottom: 5),
            child: (
              CarouselSlider(
                options: CarouselOptions(
                  height: 350,
                  enlargeCenterPage: false,
                ),
                items: diaryModel.images?.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.network(
                            i.toString(),
                            fit: BoxFit.cover,
                            height: 300,
                          )
                      );
                    },
                  );
                }).toList(),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              diaryModel.content!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          diaryModel.location != '위치를 활성화 해주세요.' ?
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 25),
            child: Row(
              children: [
                Text(diaryModel.location ?? '',style: const TextStyle(fontSize: 11, color: Colors.black38, fontWeight: FontWeight.bold),),
                const Text(' 어딘가 에서...',style: TextStyle(fontSize: 11, color: Colors.grey),),
              ],
            ),
          ): Container(),

          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
            child: Row(
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 18,
                  color: likeColors,
                ),
                const SizedBox(width: 3),
                Text(diaryModel.like!.length.toString(), style: const TextStyle(fontSize: 12, color: Colors.grey),),
                const SizedBox(width: 10,),
                const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 18),
                const SizedBox(width: 3),
                const Text('0', style: TextStyle(fontSize: 12, color: Colors.grey),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
              children: const [
                Icon(Icons.add_box_rounded, color: Colors.indigo, size: 16),
                Center(child: Text(' 댓글 달기...', style: TextStyle(color: Colors.indigo, fontSize: 12, fontWeight: FontWeight.bold),))
              ],
            ),
          ),
          const SizedBox(height: 15,),
          Container(height: 10, color: Colors.grey[100],)
        ],
    ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        pageLoadController.reset();
        await Future.value({});
      },
      child: PagewiseListView<DiaryModel>(
        //pageSize: pageSize,
        itemBuilder: (BuildContext context, data, int index) {
          return itemBuilder(context, data, index);
        },
        pageLoadController: pageLoadController,
        //pageFuture: (pageIndex) => getPosts(pageIndex! * pageSize)
      ),
    );
  }
}

