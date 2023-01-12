import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:open_diary/model/chatList.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat_room.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController titleController = TextEditingController();
  final loginInfo = GetStorage();
  final supabase = Supabase.instance.client;

  void createChat() async {

    Dialogs.materialDialog(
        msg: 'Are you sure ? you can\'t undo this',
        title: "Delete",
        color: Colors.white,
        context: context,
        dialogWidth: kIsWeb ? 0.3 : null,
        onClose: (value) => print("returned value is '$value'"),
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigator.of(context).pop(['Test', 'List']);
            },
            text: 'Cancel',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {},
            text: "Delete",
            iconData: Icons.delete,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);

    // Get.dialog(
    //   AlertDialog(
    //     title: const Text('채팅방 생성'),
    //     content: SizedBox(
    //       height: 200,
    //       child: Column(
    //         children: [
    //           TextField(
    //             maxLines: 1,
    //             controller: titleController,
    //             decoration: const InputDecoration(
    //               labelText: '제목',
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //               ),
    //             ),
    //             keyboardType: TextInputType.multiline,
    //           ),
    //         ],
    //       ),
    //     ),
    //     actions: [
    //       TextButton(
    //         child: const Text("취소"),
    //         onPressed: () => Get.back(),
    //       ),
    //       TextButton(
    //         child: const Text("생성"),
    //         onPressed: () async {
    //           var uuid = const Uuid().v4();
    //           try {
    //             final createUser = await supabase.from('chat_list').select().eq('create_user', supabase.auth.currentUser!.id).maybeSingle();
    //
    //             if(createUser == null){
    //               await supabase.from('chat_list').insert({
    //                 'title': titleController.text,
    //                 'max_user': 5,
    //                 'user_list': [supabase.auth.currentUser!.id],
    //                 'create_user': supabase.auth.currentUser!.id
    //               });
    //               Get.back();
    //             }else{
    //               Get.back();
    //               Get.snackbar(
    //                 '채팅방 중복생성',
    //                 '2개이상 채팅방을 생성할수 없습니다.',
    //                 snackPosition: SnackPosition.BOTTOM,
    //                 forwardAnimationCurve: Curves.elasticInOut,
    //                 reverseAnimationCurve: Curves.easeOut,
    //               );
    //             }
    //           } on PostgrestException catch (error) {
    //             print(error.message);
    //             Get.snackbar(
    //               'Error.',
    //               error.message,
    //               snackPosition: SnackPosition.BOTTOM,
    //               forwardAnimationCurve: Curves.elasticInOut,
    //               reverseAnimationCurve: Curves.easeOut,
    //             );
    //           } catch (_) {
    //             Get.snackbar(
    //               'Error.',
    //               '다시 실행해주세요',
    //               snackPosition: SnackPosition.BOTTOM,
    //               forwardAnimationCurve: Curves.elasticInOut,
    //               reverseAnimationCurve: Curves.easeOut,
    //             );
    //           }
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[100],
        onPressed: () => createChat(),
        child: SvgPicture.asset(
          'assets/icon/add.svg',
          width: 25,
          height: 25,
          color: Colors.black,
        ),
      ),
      body: supabase.auth.currentSession == null ? Column(
        children: const [
          Text('로그인')
        ],
      ): Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 110),
        child: StreamBuilder<List<ChatListModel>>(
            stream: Supabase.instance.client.from('chat_list').stream(primaryKey: ['id']).order('created_at', ascending: true).map((maps) =>
                maps.map((map) => ChatListModel.fromMap(map: map)).toList()
            ),
            builder: (context, snapshot){
              if(snapshot.hasData){
                final chatHeard = snapshot.data!;

                return Column(
                  children: [
                    if (chatHeard.isEmpty) const Center(child: Text('채팅방이 없습니다.'),)
                    else ListView.builder(
                      physics : const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: chatHeard.length,
                      itemBuilder: (context, index){
                        final chat = chatHeard[index];
                        return InkWell(
                          onTap: (){
                            Get.dialog(
                              AlertDialog(
                                title: const Text('채팅방 참여하기'),
                                content: SizedBox(
                                  height: 200,
                                  child: Column(
                                    children: const [
                                      Text('참여하기')
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("취소"),
                                    onPressed: () => Get.back(),
                                  ),
                                  TextButton(
                                    child: const Text("참여하기"),
                                    onPressed: () async {
                                      if(chat.userList.length == chat.maxUser){
                                        Get.snackbar(
                                          '채팅방 입장 불가능.',
                                          '입장가능한 인원이 초가되었습니다.',
                                          snackPosition: SnackPosition.BOTTOM,
                                          forwardAnimationCurve: Curves.elasticInOut,
                                          reverseAnimationCurve: Curves.easeOut,
                                        );
                                      }else{
                                        chat.userList.add(supabase.auth.currentUser!.id);
                                        await supabase.from('chat_list').update({
                                          'user_list': chat.userList
                                        }).eq('id', chat.id);
                                        Get.to(const ChatRoomPage(), arguments: chat);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(chat.createNickName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Expanded(
                                      child: Text('  ${timeago.format(DateTime.now().subtract(Duration(minutes: chat.createdAt.millisecond)))}', style: const TextStyle(color: Colors.black38 , fontSize: 12))
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
                              Text(chat.title, style: const TextStyle(fontSize: 13),),
                              Text('${chat.userList.length}/${chat.maxUser}', style: const TextStyle(fontSize: 13),),
                              Divider(color: Colors.grey[300])
                            ],
                          ),
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
    );
  }
}
