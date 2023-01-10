import 'package:flutter/material.dart';
import 'package:open_diary/page/navbar/chat/chat_list.dart';
import 'package:open_diary/page/navbar/home/tab1.dart';

import 'chat_room_list.dart';

class ChatMainPage extends StatefulWidget {
  const ChatMainPage({Key? key}) : super(key: key);

  @override
  State<ChatMainPage> createState() => _ChatMainPageState();
}

class _ChatMainPageState extends State<ChatMainPage> with TickerProviderStateMixin {
  late TabController _nestedTabController;

  @override
  void initState() {
    super.initState();
    _nestedTabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 35,),
        TabBar(
          controller: _nestedTabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          tabs: const [
            Tab(
              text: "채팅",
            ),
            Tab(
              text: "참여중인 채팅",
            ),
          ],
        ),
        Expanded(
          child: SizedBox(
            height: screenHeight,
            child: TabBarView(
              controller: _nestedTabController,
              children: const [
                ChatListPage(),
                ChatRoomListPage(),
              ],
            ),
          ),
        )
      ],
    );
  }
}