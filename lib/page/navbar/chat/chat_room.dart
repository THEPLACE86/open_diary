import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
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
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: ChatBubble(
                            alignment: message.isMine ? Alignment.topRight : Alignment.topLeft,
                            clipper: ChatBubbleClipper5(
                              type: message.isMine ? BubbleType.sendBubble : BubbleType.receiverBubble,
                              radius: 15,
                              secondRadius: 15,
                            ),
                            margin: const EdgeInsets.only(top: 20),
                            backGroundColor: message.isMine ? Colors.blue : Colors.grey[100],
                            child: message.isMine ? Container(
                              padding: const EdgeInsets.all(4),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: Text(message.message, style: const TextStyle(color: Colors.white),
                              ),
                            ) : Row(
                              children: [
                                Text('wef'),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  child: Text(message.message, style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            )
                          ),
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
