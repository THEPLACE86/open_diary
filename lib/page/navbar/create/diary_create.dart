import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:super_tag_editor/tag_editor.dart';
import 'dart:convert';
import '../../login/google_login.dart';

class DiaryCreatePage extends StatefulWidget {
  const DiaryCreatePage({Key? key}) : super(key: key);

  @override
  State<DiaryCreatePage> createState() => _DiaryCreatePageState();
}

class _DiaryCreatePageState extends State<DiaryCreatePage> {

  final supabase = Supabase.instance.client;
  String todayFeel = '선택해 주세요.';
  String location = '위치 검색중..';
  String location1 = ' 어딘가 에서...';
  late String lat, lng;

  final controller = MultiImagePickerController(
    maxImages: 10,
    allowedImageTypes: ['png', 'jpg', 'jpeg', 'gif'],
  );

  static const mockResults = [
    'dat@gmail.com',
    'dab246@gmail.com',
    'kaka@gmail.com',
    'datvu@gmail.com'
  ];

  final List<String> _values = [];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _diaryController = TextEditingController();

  Future<void> fetchData() async {
    LocationPermission permission = await Geolocator.requestPermission(); //오류 해결 코드
    bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();

    if(isLocationServiceEnabled == true){
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      lat = position.latitude.toString();
      lng = position.longitude.toString();

      Map<String,String> headers = {
        "X-NCP-APIGW-API-KEY-ID": "h7gtjkv92c", // 개인 클라이언트 아이디
        "X-NCP-APIGW-API-KEY": "fidpcKEkyxqEnmCRAErXGgKSQJe5mYRWBcGeiTda" // 개인 시크릿 키
      };

      http.Response response = await http.get(
          Uri.parse(
              "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$lng,$lat&sourcecrs=epsg:4326&output=json"),
          headers: headers
      );

      String jsonData = response.body;

      var myJsonGu = jsonDecode(jsonData)["results"][1]['region']['area2']['name'];
      var myJsonSi = jsonDecode(jsonData)["results"][1]['region']['area1']['name'];
      var myJsonSi1 = jsonDecode(jsonData)["results"][1]['region']['area3']['name'];

      setState(() {
        location = myJsonSi + ' ' + myJsonGu + ' ' + myJsonSi1;
      });
    }else{
      setState(() {
        location = '위치를 활성화 해주세요.';
        location1 = '';
      });
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  _onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

  // void saveDiary() async {
  //   List images = [];
  //
  //   try {
  //     int date = DateTime.now().millisecondsSinceEpoch;
  //
  //     for(final ImageFile image in controller.images){
  //       var uuid = const Uuid().v4();
  //       supabase.storage.from('storage-diary').upload(
  //         'loginID/$date/$uuid', File(image.path!)
  //       );
  //       images.add(
  //         'https://pafibucbvxckinbhdgbp.supabase.co/storage/v1/object/public/storage-diary/loginID/$date/$uuid'
  //       );
  //     }
  //
  //     await supabase.from('diary').insert({
  //       'content': _diaryController.text,
  //       'author': 'a20e7289-e63c-4053-9f63-3fc5f8bbaba9',
  //       'location': location,
  //       'lat': lat,
  //       'lng': lng,
  //       'feel': todayFeel,
  //       'images': images
  //     });
  //
  //     Get.offAll(const MainNavBarPage());
  //   } on PostgrestException catch (error) {
  //     print(error.message);
  //     //context.showErrorSnackBar(message: error.message);
  //   } catch (_) {
  //     //context.showErrorSnackBar(message: unexpectedErrorMessage);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 쓰기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            disabledColor: Colors.grey,
            onPressed: () {},
            icon: const Icon(Icons.check_circle, color: Colors.teal,)
          ),
          IconButton(
              disabledColor: Colors.grey,
              onPressed: () => Get.to(const RegisterPage()),
              icon: const Icon(Icons.access_time_filled_sharp, color: Colors.teal,)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView(
                shrinkWrap: true,
                physics : const ClampingScrollPhysics(),
                children: <Widget>[
                  TagEditor<String>(
                    length: _values.length,
                    controller: _textEditingController,
                    focusNode: _focusNode,
                    delimiters: const [',', ' '],
                    hasAddButton: true,
                    resetTextOnSubmitted: true,
                    // This is set to grey just to illustrate the `textStyle` prop
                    textStyle: const TextStyle(color: Colors.grey),
                    onSubmitted: (outstandingValue) {
                      setState(() {
                        _values.add(outstandingValue);
                      });
                    },
                    inputDecoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '원하는 태그(#)를 검색해 보세요!',
                    ),
                    onTagChanged: (newValue) {
                      setState(() {
                        _values.add(newValue);
                      });
                    },
                    tagBuilder: (context, index) => _Chip(
                      index: index,
                      label: _values[index],
                      onDeleted: _onDelete,
                    ),
                    // InputFormatters example, this disallow \ and /
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))
                    ],
                    suggestionBuilder: (context, state, data) {
                      return ListTile(
                        key: ObjectKey(data),
                        title: Text(data),
                        onTap: () {
                          setState(() {
                            _values.add(data);
                          });
                          state.selectSuggestion(data);
                        },
                      );
                    },
                    suggestionsBoxElevation: 10,
                    findSuggestions: (String query) {
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return mockResults.where((profile) {
                          return profile
                              .toLowerCase()
                              .contains(query.toLowerCase()) ||
                              profile.toLowerCase().contains(query.toLowerCase());
                        }).toList(growable: false)
                          ..sort((a, b) => a
                            .toLowerCase()
                            .indexOf(lowercaseQuery)
                            .compareTo(b.toLowerCase().indexOf(lowercaseQuery)));
                      }
                      return [];
                    },
                  ),
                  const Divider(),
                ],
              ),
              Row(
                children: [
                  const Text('오늘의 감정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  const SizedBox(width: 5),
                  TextButton(
                    onPressed: () =>
                        Get.bottomSheet(
                            Container(
                              color: Colors.grey[50],
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 35, right: 35, top: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 8,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey[200]
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 20, bottom: 20),
                                        child: Text('오늘의 감정', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                todayFeel = '기쁨';
                                              });
                                              Get.back();
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        10),
                                                    color: Colors.red[50]
                                                ),
                                                height: 70,
                                                width: 90,
                                                child: const Center(child: Text('기쁨',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 16)))
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                todayFeel = '행복';
                                                Get.back();
                                              });
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        10),
                                                    color: Colors.yellow[50]
                                                ),
                                                height: 70,
                                                width: 90,
                                                child: const Center(child: Text('행복',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 16)))
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                todayFeel = '슬픔';
                                              });
                                              Get.back();
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        10),
                                                    color: Colors.blue[50]
                                                ),
                                                height: 70,
                                                width: 90,
                                                child: const Center(child: Text('슬픔',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 16)))
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                        ],
                                      ),
                                      const SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                todayFeel = '우울';
                                              });
                                              Get.back();
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        10),
                                                    color: Colors.deepPurple[50]
                                                ),
                                                height: 70,
                                                width: 90,
                                                child: const Center(child: Text('우울',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 16)))
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                todayFeel = '분노';
                                              });
                                              Get.back();
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        10),
                                                    color: Colors.red[100]
                                                ),
                                                height: 70,
                                                width: 90,
                                                child: const Center(child: Text('분노',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 16)))
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                todayFeel = '후회';
                                              });
                                              Get.back();
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        10),
                                                    color: Colors.grey[100]
                                                ),
                                                height: 70,
                                                width: 90,
                                                child: const Center(child: Text('후회',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 16)))
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                        ],
                                      ),
                                      const SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                todayFeel = '보통';
                                              });
                                              Get.back();
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        10),
                                                    color: Colors.lime[50]
                                                ),
                                                height: 70,
                                                width: 90,
                                                child: const Center(child: Text('보통',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 16)))
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                todayFeel = '설렘';
                                              });
                                              Get.back();
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        10),
                                                    color: Colors.orange[100]
                                                ),
                                                height: 70,
                                                width: 90,
                                                child: const Center(child: Text('설렘',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 16)))
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                todayFeel = '짜증';
                                              });
                                              Get.back();
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        10),
                                                    color: Colors.cyan[50]
                                                ),
                                                height: 70,
                                                width: 90,
                                                child: const Center(child: Text('짜증',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 16)))
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            )
                        ),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: todayFeel == '기쁨' ? Colors.red[50] :
                          todayFeel == '행복' ? Colors.yellow[50] :
                          todayFeel == '슬픔' ? Colors.blue[50] :
                          todayFeel == '우울' ? Colors.deepPurple[50] :
                          todayFeel == '분노' ? Colors.red[50] :
                          todayFeel == '후회' ? Colors.grey[100] :
                          todayFeel == '보통' ? Colors.lime[50] :
                          todayFeel == '설렘' ? Colors.orange[100]:
                          todayFeel == '선택해 주세요.' ? Colors.teal[100]:
                          Colors.cyan[50],
                        ),
                        height: 35,
                        width: todayFeel == '선택해 주세요.' ? 100 : 50,
                        child: Center(
                            child: Text(todayFeel, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 11,color: Colors.black87))
                        )
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: [
                    Text(location,style: const TextStyle(fontSize: 12, color: Colors.black38, fontWeight: FontWeight.bold),),
                    Text(location1,style: const TextStyle(fontSize: 11, color: Colors.grey),),
                  ],
                ),
              ),
              TextField(
                maxLines: 10,
                controller: _diaryController,
                decoration: const InputDecoration(
                  labelText: '오늘 나는 ...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(
                height: 300,
                child: MultiImagePickerView(
                  controller: controller,
                  padding: const EdgeInsets.all(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold),),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}