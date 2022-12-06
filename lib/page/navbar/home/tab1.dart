import 'package:flutter/material.dart';
import 'package:open_diary/model/diary.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Tab1 extends StatefulWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {

  final supabase = Supabase.instance.client;
  late final Stream<List<DiaryModel>> _diaryStream;

  @override
  void initState() {
    //final myUserId = supabase.auth.currentUser!.id;
    _diaryStream = supabase.from('diary').stream(primaryKey: ['id']).map((maps) => maps
        .map((map) => DiaryModel.fromMap(map: map)).toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<DiaryModel>>(
      stream: _diaryStream,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData){
          final diary = snapshot.data!;
          return ListView.builder(

            itemCount: diary.length,
            itemBuilder: (context, index){
              final data = diary[index];

              return Column(
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
                                  color: Colors.red[50]
                              ),
                              height: 35,
                              width: 50,
                              child: const Center(child: Text('기쁨', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 11)))
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('익명', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                                Text('2022년 12월 12일 (토)', style: TextStyle(fontSize: 11, color: Colors.black54),),
                              ],
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          const InkWell(
                              child: Icon(Icons.more_vert_rounded, color: Colors.grey, size: 15,)
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Text(data.content, maxLines: 3,),
                  ),
                  data.location != '위치없음' ?
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 25),
                    child: Row(
                      children: [
                        Text(data.location,style: const TextStyle(fontSize: 12, color: Colors.black38, fontWeight: FontWeight.bold),),
                        const Text(' 어딘가 에서...',style: TextStyle(fontSize: 11, color: Colors.grey),),
                      ],
                    ),
                  ): Container(),

                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
                    child: Row(
                      children: const [
                        Icon(Icons.favorite_border, color: Colors.grey, size: 18),
                        SizedBox(width: 3),
                        Text('0', style: TextStyle(fontSize: 12, color: Colors.grey),),
                        SizedBox(width: 10,),
                        Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 18),
                        SizedBox(width: 3),
                        Text('0', style: TextStyle(fontSize: 12, color: Colors.grey),)
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
              );
            },
          );
        }
        return const Text('bdfbb');
      },
    );
  }
}
