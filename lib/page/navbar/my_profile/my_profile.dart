import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_diary/page/login/google_login.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final loginInfo = GetStorage();
  String nickname = '';

  @override
  void initState(){
    super.initState();
  }

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      await loginInfo.write('uid','');
      await loginInfo.write('nickname','');
    } on AuthException catch (error) {
      Get.snackbar(
        '에러!',
        error.message,
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
    } catch (error) {
      Get.snackbar(
        '에러!',
        '에러 입니다.',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
    }
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            disabledColor: Colors.grey,
            onPressed: () => _signOut(),
            icon: const Icon(Icons.check_circle, color: Colors.teal,)
          ),
        ],
      ),
      body: loginInfo.read('uid') != '' ? Column(
        children: [
          Text(loginInfo.read('nickname') ?? '')
        ],
      ): Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('로그인을 해주세요.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            const SizedBox(height: 10,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                )
              ),
              onPressed: () => Get.to(const RegisterPage()),
              child: const Text('로그인',style: TextStyle(fontWeight: FontWeight.bold))
            )
          ],
        ),
      )
    );
  }
}
