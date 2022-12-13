import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_diary/page/navbar/main_nav_bar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'login/google_login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _redirectCalled = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (_redirectCalled || !mounted) {
      return;
    }

    _redirectCalled = true;
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      Get.offAll(const MainNavBarPage());
    } else {
      Get.offAll(const RegisterPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}