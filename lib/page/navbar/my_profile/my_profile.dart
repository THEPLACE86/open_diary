import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  String nickname = '';

  @override
  void initState(){
    getProfile();
    super.initState();
  }

  Future<void> getProfile() async {
    try{
      final uid = Supabase.instance.client.auth.currentUser!.id;
      print('유아이디 : $uid');
      final profile = await Supabase.instance.client.from('profiles').select().eq('uid', uid).single() as Map;
      print('아니 시발 : ${profile['uid']}');

      // if(profile.isEmpty){
      //   await Supabase.instance.client.from('profiles').insert({
      //     'uid': uid,
      //   });
      //   final profile1 = await Supabase.instance.client.from('profiles').select().eq('uid', uid).single() as Map;
      //   setState(() {
      //     nickname = profile1['nickname'] ?? '안됨';
      //   });
      // }else{
      //   setState(() {
      //     nickname = profile['nickname'] ?? '';
      //   });
      // }

    } on PostgrestException catch (error) {
      print(error.message);
    } catch (error) {
      print('Unexpected exception occurred');
    }
  }

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
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
      body: Column(
        children: [
          Text(nickname)
        ],
      ),
    );
  }
}
