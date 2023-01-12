import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_diary/page/navbar/main_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  if (Platform.isIOS) {
    await Admob.requestTrackingAuthorization();
  }

  await Supabase.initialize(
    url: 'https://pafibucbvxckinbhdgbp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBhZmlidWNidnhja2luYmhkZ2JwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Njk3NzA2NjEsImV4cCI6MTk4NTM0NjY2MX0.8dsUjkTadwKTsR4ygNYb1ZhVuxtZtiKKvqRFBap7q6I'
  );
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainNavBarPage(),
    );
  }
}