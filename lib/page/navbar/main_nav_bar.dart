import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:open_diary/page/navbar/create/diary_create.dart';
import 'package:open_diary/page/navbar/home/home.dart';
import 'package:open_diary/page/navbar/create/diary_create.dart';

class MainNavBarPage extends StatefulWidget {
  const MainNavBarPage({Key? key}) : super(key: key);

  @override
  State<MainNavBarPage> createState() => _MainNavBarPageState();
}

class _MainNavBarPageState extends State<MainNavBarPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    HomePage(),
    HomePage(),
    DiaryCreatePage(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 5,
              activeColor: Colors.black,
              iconSize: 20,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: '공개일기',
                ),
                GButton(
                  icon: Icons.chat_bubble_outline_outlined,
                  text: '대화',
                ),
                GButton(
                  icon: Icons.notifications_none_rounded,
                  text: '알림',
                ),
                GButton(
                  icon: Icons.account_balance_wallet_outlined,
                  iconActiveColor: Colors.cyan,
                  iconColor: Colors.cyan,
                  text: '일기쓰기',
                ),
                GButton(
                  icon: Icons.person_outlined,
                  text: '내정보',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}