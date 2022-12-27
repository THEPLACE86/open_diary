import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_diary/page/navbar/main_nav_bar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final loginInfo = GetStorage();

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
              try{
                final uid = Supabase.instance.client.auth.currentUser!.id;
                final profile = await Supabase.instance.client.from('profiles').select().eq('uid', uid).limit(1);

                if(profile.isEmpty){
                  await Supabase.instance.client.from('profiles').insert({
                    'uid': uid,
                  });
                  final userProfile = await Supabase.instance.client.from('profiles').select().eq('uid', uid).limit(1);

                  await loginInfo.write('nickname', userProfile[0]['nickname']);
                  await loginInfo.write('uid', userProfile[0]['uid']);
                  Get.offAll(const MainNavBarPage());
                }else{
                  await loginInfo.write('nickname', profile[0]['nickname']);
                  await loginInfo.write('uid', profile[0]['uid']);
                  Get.offAll(const MainNavBarPage());
                }
              } on PostgrestException catch (error) {
                print(error.message);
              } catch (error) {
                print('Unexpected exception occurred');
              }
              Get.offAll(const MainNavBarPage());

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
