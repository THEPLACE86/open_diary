import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/chatHeard.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  ChatHeardModel chatHeard = Get.arguments;

  Widget buildBody(){
    return Column(
      children: [

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: buildBody(),
    );
  }
}
