import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final loginInfo = GetStorage();

  @override
  void initState() {
    super.initState();
    print('로그인 ${loginInfo.read('nickname')}');
    print('uid ${loginInfo.read('uid')}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('대화', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: loginInfo.read('uid') != null ? Column(
          children: [
            Text(loginInfo.read('nickname') ?? '')
          ],
        ): Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('로그인을 해주세요.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ],
          ),
        )
    );
  }
}
