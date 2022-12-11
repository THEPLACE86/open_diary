import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_diary/page/navbar/main_nav_bar.dart';
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
      redirectTo: '/'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            child: Text('login'),
            onPressed: () => googleLogin(),
          )
        ],
      ),
    );
  }
}
