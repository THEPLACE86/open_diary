import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:open_diary/model/diary.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:yet_another_json_isolate/yet_another_json_isolate.dart';
import '../../../model/user.dart';

class Tab1 extends StatefulWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  static const _pageSize = 3;

  final PagingController<int, DiaryModel> _pagingController = PagingController(firstPageKey: 1);

  final supabase = Supabase.instance.client;
  late double  lat = 123.029348, lng = 74.23231;

  Future<void> myLocation() async {
    LocationPermission permission = await Geolocator.requestPermission(); //오류 해결 코드
    bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();

    if(isLocationServiceEnabled == true){
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        lat = position.latitude;
        lng = position.longitude;
      });
    }else{
      setState(() {
        lat = 123.029348;
        lng = 74.23231;
      });
    }
  }

  @override
  void initState(){
    //myLocation();
    // _pagingController.addPageRequestListener((pageKey) {
    //   _fetchPage(pageKey);
    // });
    //final myUserId = supabase.auth.currentUser!.id;
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
    // _diaryStream = supabase.from('diary').stream(primaryKey: ['id']).eq('open_diary', true).limit(3).map((maps) => maps
    //     .map((map) => DiaryModel.fromMap(map: map)).toList());
  }

  Future<List<PostModel>> getPosts(offset, limit) async {
  
    final diaryStream = await supabase.from('diary').select('content');
    print(diaryStream);
    var postList = PostModel.fromJsonList(diaryStream);
    print(postList);
    return postList;
  }


  @override
  Widget build(BuildContext context) {
    return PagewiseListView<PostModel>(
        pageSize: 5,
        itemBuilder: _itemBuilder,
        pageFuture: (pageIndex) => getPosts(pageIndex! * 5, 5)
    );
  }

  Widget _itemBuilder(context, PostModel entry, _) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.brown[200],
          ),
          title: Text(entry.content!),
          subtitle: Text('entry!'),
        ),
        Divider()
      ],
    );
  }
}


  // @override
  // Widget build(BuildContext context) {
  //   return PagedListView<int, DiaryModel>(
  //     pagingController: _pagingController,
  //     builderDelegate: PagedChildBuilderDelegate<DiaryModel>(
  //       itemBuilder: (context, data, index){
  //         //final data = item[index];
  //         return Column(
  //           children: [
  //             Text('data.content')
  //           ],
  //         );
  //         // const Distance distance = Distance();
  //         // final double km = distance.as(LengthUnit.Kilometer, LatLng(lat, lng), LatLng(data.lat, data.lng));
  //
  //         // return Column(
  //         //   mainAxisAlignment: MainAxisAlignment.start,
  //         //   crossAxisAlignment: CrossAxisAlignment.start,
  //         //   children: [
  //         //     Container(
  //         //       color: Colors.white,
  //         //       child: Padding(
  //         //         padding: const EdgeInsets.only(left: 25, right: 25,top: 25, bottom: 15),
  //         //         child: Row(
  //         //           children: [
  //         //             Container(
  //         //                 decoration: BoxDecoration(
  //         //                   borderRadius: BorderRadius.circular(10),
  //         //                   color: data.feel == '기쁨' ? Colors.red[50] :
  //         //                   data.feel == '행복' ? Colors.yellow[50] :
  //         //                   data.feel == '슬픔' ? Colors.blue[50] :
  //         //                   data.feel == '우울' ? Colors.deepPurple[50] :
  //         //                   data.feel == '분노' ? Colors.red[50] :
  //         //                   data.feel == '후회' ? Colors.grey[100] :
  //         //                   data.feel == '보통' ? Colors.lime[50] :
  //         //                   data.feel == '설렘' ? Colors.orange[100]:
  //         //                   Colors.cyan[50],
  //         //                 ),
  //         //                 height: 35,
  //         //                 width: 50,
  //         //                 child: Center(
  //         //                     child: Text(data.feel, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 11,color: Colors.black87))
  //         //                 )
  //         //             ),
  //         //             Padding(
  //         //               padding: const EdgeInsets.only(left: 15),
  //         //               child: Column(
  //         //                 crossAxisAlignment: CrossAxisAlignment.start,
  //         //                 children: const [
  //         //                   Text('익명', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
  //         //                   Text('2022년 12월 12일 (토)', style: TextStyle(fontSize: 11, color: Colors.black54),),
  //         //                 ],
  //         //               ),
  //         //             ),
  //         //             const Expanded(child: SizedBox()),
  //         //             const InkWell(
  //         //                 child: Icon(Icons.more_vert_rounded, color: Colors.grey, size: 15,)
  //         //             )
  //         //           ],
  //         //         ),
  //         //       ),
  //         //     ),
  //         //     if(data.images.toString() != '[]')Padding(
  //         //       padding: const EdgeInsets.only(top: 5,bottom: 5),
  //         //       child: (
  //         //           CarouselSlider(
  //         //             options: CarouselOptions(
  //         //               height: 350,
  //         //               enlargeCenterPage: false,
  //         //             ),
  //         //             items: data.images.map((i) {
  //         //               return Builder(
  //         //                 builder: (BuildContext context) {
  //         //                   return Container(
  //         //                       width: MediaQuery.of(context).size.width,
  //         //                       margin: const EdgeInsets.symmetric(horizontal: 5.0),
  //         //                       child: Image.network(
  //         //                         i.toString(),
  //         //                         fit: BoxFit.cover,
  //         //                         height: 300,
  //         //                       )
  //         //                   );
  //         //                 },
  //         //               );
  //         //             }).toList(),
  //         //           )
  //         //       ),
  //         //     ),
  //         //     Padding(
  //         //       padding: const EdgeInsets.only(left: 25, right: 25),
  //         //       child: Text(data.content, maxLines: 3,),
  //         //     ),
  //         //     data.location != '위치를 활성화 해주세요.' ?
  //         //     Padding(
  //         //       padding: const EdgeInsets.only(top: 10, left: 25),
  //         //       child: Row(
  //         //         children: [
  //         //           Text(data.location,style: const TextStyle(fontSize: 11, color: Colors.black38, fontWeight: FontWeight.bold),),
  //         //           const Text(' 어딘가 에서...',style: TextStyle(fontSize: 11, color: Colors.grey),),
  //         //           Text(km.ceil().toString())
  //         //         ],
  //         //       ),
  //         //     ): Container(),
  //         //
  //         //     Padding(
  //         //       padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
  //         //       child: Row(
  //         //         children: const [
  //         //           Icon(Icons.favorite_border, color: Colors.grey, size: 18),
  //         //           SizedBox(width: 3),
  //         //           Text('0', style: TextStyle(fontSize: 12, color: Colors.grey),),
  //         //           SizedBox(width: 10,),
  //         //           Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 18),
  //         //           SizedBox(width: 3),
  //         //           Text('0', style: TextStyle(fontSize: 12, color: Colors.grey),)
  //         //         ],
  //         //       ),
  //         //     ),
  //         //     Padding(
  //         //       padding: const EdgeInsets.only(left: 25),
  //         //       child: Row(
  //         //         children: const [
  //         //           Icon(Icons.add_box_rounded, color: Colors.indigo, size: 16),
  //         //           Center(child: Text(' 댓글 달기...', style: TextStyle(color: Colors.indigo, fontSize: 12, fontWeight: FontWeight.bold),))
  //         //         ],
  //         //       ),
  //         //     ),
  //         //     const SizedBox(height: 15,),
  //         //     Container(height: 10, color: Colors.grey[100],)
  //         //   ],
  //         // );
  //       },
  //     ),
  //   );
  //   // return StreamBuilder<List<DiaryModel>>(
  //   //   stream: _diaryStream,
  //   //   builder: (context, snapshot){
  //   //     if(snapshot.connectionState == ConnectionState.waiting){
  //   //       return const Center(child: CircularProgressIndicator());
  //   //     }
  //   //     if (snapshot.hasData){
  //   //       final diary = snapshot.data!;
  //   //
  //   //     }
  //   //     return const Center(child: Text('앱을 다시 실행해 주세요.'));
  //   //   },
  //   // );
  // }

