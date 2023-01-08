import 'dart:io';
import 'package:timeago/timeago.dart' as timeago;
import 'package:admob_flutter/admob_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_diary/model/comment.dart';
import 'package:open_diary/model/diary.dart';
import 'package:open_diary/page/login/google_login.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final supabase = Supabase.instance.client;
  DiaryModel diaryModel = Get.arguments;
  AdmobBannerSize? bannerSize = AdmobBannerSize.BANNER;
  late AdmobInterstitial interstitialAd;
  final TextEditingController txtComment = TextEditingController();
  final loginInfo = GetStorage();
  String nickname = '';
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    bannerSize = AdmobBannerSize.BANNER;
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId()!,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
  }

  void saveComment() async {
    try{
      if(supabase.auth.currentSession == null){
        Get.to(const RegisterPage());
      }else{
        if(txtComment.text.trim() == ''){
          Get.snackbar(
            '댓글 입력.',
            '댓글을 입력해주세요.',
            snackPosition: SnackPosition.BOTTOM,
            forwardAnimationCurve: Curves.elasticInOut,
            reverseAnimationCurve: Curves.easeOut,
          );
        }else{
          await supabase.from('comment').insert({
            'comment': txtComment.text,
            'author': supabase.auth.currentUser!.id,
            'nickname': loginInfo.read('nickname'),
            'diary_id': diaryModel.id,
          });
          await supabase.from('diary').update({
            'comment_count': commentCount + 1
          }).eq('id', diaryModel.id);
          setState(() {
            txtComment.text = '';
          });
        }
      }
    } on PostgrestException catch (error) {
      print(error.message);
    } catch (e) {
      print('뭔 에러여   $e');
    }
  }

  void btnLike(List like) async {
    final likes = await supabase.from('diary').select('like').eq('id', diaryModel.id);

    print(likes[0]['like']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: (){},
            child: const Icon(Icons.more_vert_rounded, color: Colors.black54, size: 20,)
          ),
          const SizedBox(width: 10)
        ],
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics : const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 3),
              child: Row(
                children: [
                  const Text('오늘의 기분  ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black87)),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Text(diaryModel.createDate!, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),),
            ),
            if(diaryModel.images.toString() != '[]') InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
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
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(diaryModel.content!, style: const TextStyle(fontSize: 16),),
            ),
            if(diaryModel.location != '위치를 활성화 해주세요.')(
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icon/location.svg',
                        width: 16,
                        height: 16,
                        color: Colors.grey,
                      ),
                      Text(' ${diaryModel.location}' ?? '',style: const TextStyle(fontSize: 12, color: Colors.black38, fontWeight: FontWeight.bold),),
                      const Text(' 어딘가 에서...',style: TextStyle(fontSize: 12, color: Colors.grey),),
                    ],
                  ),
                )
            ),
            Container(
              color: Colors.grey[100],
              width: MediaQuery.of(context).size.width,
              child: AdmobBanner(
                adUnitId: getBannerAdUnitId()!,
                adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 110),
              child: StreamBuilder<List<CommentModel>>(
                stream: Supabase.instance.client.from('comment').stream(primaryKey: ['id']).eq('diary_id', diaryModel.id).order('created_at', ascending: true).map((maps) =>
                    maps.map((map) => CommentModel.fromMap(map: map)).toList()
                ),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    final comments = snapshot.data!;

                    return Column(
                      children: [
                        if (comments.isEmpty) const SizedBox(height: 150, child: Center(child: Text('댓글이 없습니다.'),))
                        else ListView.builder(
                          physics : const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: comments.isEmpty ? 1 : comments.length + 1,
                          itemBuilder: (context, index){
                            commentCount = comments.length;
                            if(index == 0){
                              return Padding(
                                padding: const EdgeInsets.only(right: 20, top: 15, bottom: 15),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        btnLike(diaryModel.like!.toList());
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icon/heart.svg',
                                        width: 20,
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(diaryModel.like!.length.toString(), style: const TextStyle(fontSize: 12, color: Colors.grey),),
                                    const SizedBox(width: 10,),
                                    SvgPicture.asset(
                                      'assets/icon/message.svg',
                                      width: 20,
                                      height: 20,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(commentCount.toString(), style: const TextStyle(fontSize: 12, color: Colors.grey),)
                                  ],
                                ),
                              );
                            }
                            index -= 1;
                            final comment = comments[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(comment.nickname, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Expanded(
                                      child: Text('  ${timeago.format(DateTime.now().subtract(Duration(minutes: comment.createdAt.millisecond)))}', style: const TextStyle(color: Colors.black38 , fontSize: 12))
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                        'assets/icon/alarm.svg',
                                        width: 17,
                                        height: 17,
                                      ),
                                    ),

                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(comment.comment, style: const TextStyle(fontSize: 13),),
                                ),
                                Divider(color: Colors.grey[300])
                              ],
                            );
                          },
                        )
                      ],
                    );
                  }else{
                    return const Center(child: CircularProgressIndicator());
                  }
                }
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10, right: 10),
                margin: const EdgeInsets.only(left: 10, right: 10),
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25)),
                child: TextField(
                  controller: txtComment,
                  minLines: 1,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '댓글을 입력해주세요.',
                    hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                saveComment();
                FocusScope.of(context).unfocus();
              },
              icon: SvgPicture.asset(
                'assets/icon/send.svg',
                width: 30,
                height: 30,
                color: Colors.teal,
              ),
            )
          ],
        ),
      )
    );
  }
}

String? getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}

String? getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/1033173712';
  }
  return null;
}