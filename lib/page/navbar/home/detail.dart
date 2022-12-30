import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:get/get.dart';
import 'package:open_diary/model/diary.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  DiaryModel diaryModel = Get.arguments;
  AdmobBannerSize? bannerSize = AdmobBannerSize.BANNER;
  late AdmobInterstitial interstitialAd;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FooterView(
        footer: Footer(
          child: Column(
            children: [
              Text('wef')
            ],
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 3),
            child: Row(
              children: [
                const Text('오늘의 기분    ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black87)),
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
            child: Text(diaryModel.content!),
          ),
          Container(
            height: 10,
            color: Colors.grey[200],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: AdmobBanner(
              adUnitId: getBannerAdUnitId()!,
              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
            ),
          ),
          const SizedBox(
            height: 100,
            child: Text('wef'),
          )
        ],
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                TextField(),
                IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.add_box)
                )
              ],
            ),
          ),
        ),
      ),
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