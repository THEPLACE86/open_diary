import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_diary/page/navbar/main_nav_bar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  void googleLogin() async {
    await Supabase.instance.client.auth.signInWithOAuth(
      Provider.google,
      redirectTo: 'io.supabase.flutterquickstart://login-callback/',
    ).whenComplete((){
      print('성공');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SupaSocialsAuth(
            socialProviders: const [
              SocialProviders.google,
            ],
            colored: true,
            redirectUrl: 'io.supabase.flutterquickstart://login-callback/',
            onSuccess: (Session response) async {
              Get.offAll(const MainNavBarPage());
              // try{
              //   final user = await Supabase.instance.client.from('profiles').select().eq('uid', response.user.id).single() as Map;
              //   print('유아이디 : $user');
              //   //String uid = user['uid'] ?? '';
              //   //print('유아이디  $uid');
              //   // if(user['uid'] == ''){
              //   //   await Supabase.instance.client.from('profiles').insert({
              //   //     'uid': response.user.id,
              //   //   });
              //   //   Get.offAll(const MainNavBarPage());
              //   // }else{
              //   //   Get.offAll(const MainNavBarPage());
              //   // }
              // } on PostgrestException catch (error) {
              //   print(error.message);
              // } catch (error) {
              //   print('Unexpected exception occurred');
              // }
            },
            onError: (error) {
              // do something, for example: navigate("wait_for_email");
            },
          )
        ],
      ),
    );
  }
}
