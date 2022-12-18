import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  final loginInfo = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
        body: loginInfo.read('uid') != '' ? Column(
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
