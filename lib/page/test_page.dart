// import 'package:flutter/material.dart';
//
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../util/constants.dart';
//
// class TestPage extends StatefulWidget {
//   const TestPage({Key? key}) : super(key: key);
//
//   @override
//   State<TestPage> createState() => _TestPageState();
// }
//
// class _TestPageState extends State<TestPage> {
//
//   final supabase = Supabase.instance.client;
//   String uid = '';
//   @override
//   void initState() {
//     if(supabase.auth.currentSession == null){
//       uid = 'nono';
//     }else{
//       uid = supabase.auth.currentUser!.id;
//     }
//     print('www www $uid');
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body:
//     );
//   }
// }
