import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:super_tag_editor/tag_editor.dart';

class DiaryCreatePage extends StatefulWidget {
  const DiaryCreatePage({Key? key}) : super(key: key);

  @override
  State<DiaryCreatePage> createState() => _DiaryCreatePageState();
}

class _DiaryCreatePageState extends State<DiaryCreatePage> {

  String todayFeel = '선택해 주세요.';
  final supabase = Supabase.instance.client;

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

  _onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

  void saveDiary() async {
    try {
      await supabase.from('diary').insert({
        'content': _diaryController.text,
        'author': 'a20e7289-e63c-4053-9f63-3fc5f8bbaba9',
      });
    } on PostgrestException catch (error) {
      print(error.message);
      //context.showErrorSnackBar(message: error.message);
    } catch (_) {
      //context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 쓰기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: (){
              saveDiary();
            },
            icon: const Icon(Icons.check_circle, color: Colors.cyan)
          )
        ],
      ),
      body: Padding(
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
                  delimiters: [',', ' '],
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
                const SizedBox(width: 10,),
                ElevatedButton(
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
                  child: Text(todayFeel),
                ),
              ],
            ),
            const SizedBox(height: 15,),
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
            )
          ],
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