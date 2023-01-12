import 'dart:async';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_diary/model/chatList.dart';
import 'package:open_diary/model/chatRoom.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart';
import '../../../util/constants.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final Stream<List<ChatRoomModel>> _messagesStream;
  ChatListModel chatListModel = Get.arguments;
  final ScrollController scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final myUserId = supabase.auth.currentUser!.id;

  void _scrollToTop() {
    setState(() {
      scrollController.jumpTo(0);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void initState() {
    _messagesStream = supabase
        .from('chat_room')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((maps) => maps
        .map((map) => ChatRoomModel.fromMap(map: map, myUserId: myUserId))
        .toList());
    super.initState();
  }

  void _submitMessage() async {
    final text = _textController.text;
    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    try {
      await supabase.from('chat_room').insert({
        'chat_list_id': chatListModel.id,
        'author': myUserId,
        'message': text,
      });
      _scrollToTop();
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (_) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    controller: scrollController,
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];

                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: Row(
                            mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              message.isMine ? Container() : const SizedBox(
                                width: 40,
                                height: 40,
                                child: CircleAvatar(
                                  backgroundColor: Colors.teal,
                                  radius: 250,
                                  backgroundImage: AssetImage("assets/icon/a.jpeg"),
                                ),
                              ),
                              BubbleSpecialThree(
                                text: message.message,
                                color: message.isMine ? Colors.teal : const Color(0xFFEEEEEE),
                                tail: false,
                                textStyle: TextStyle(
                                  color: message.isMine ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(format(message.createdAt))
                            ],
                          )
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          autofocus: true,
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: '메세지 입력',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          _submitMessage();
                        },
                        icon: SvgPicture.asset(
                          'assets/icon/send.svg',
                          width: 30,
                          height: 30,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}
