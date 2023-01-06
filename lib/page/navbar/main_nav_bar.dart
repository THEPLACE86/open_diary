import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:open_diary/page/navbar/chat/chat.dart';
import 'package:open_diary/page/navbar/create/diary_create.dart';
import 'package:open_diary/page/navbar/home/home.dart';
import 'package:open_diary/page/navbar/my_profile/my_profile.dart';
import 'package:open_diary/page/notification/notification.dart';

class MainNavBarPage extends StatefulWidget {
  const MainNavBarPage({Key? key}) : super(key: key);

  @override
  State<MainNavBarPage> createState() => _MainNavBarPageState();
}

class _MainNavBarPageState extends State<MainNavBarPage> {

  int tapCount = 0;
  int selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ChatPage(),
    NotificationPage(),
    MyProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        selectedFontSize: 11,
        items: [
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icon/home.svg',
              width: 22,
              height: 22,
              color: Colors.black,
            ),
            icon: SvgPicture.asset(
              'assets/icon/home.svg',
              width: 22,
              height: 22,
              color: Colors.grey[400],
            ),
            label: "오픈일기"
          ),
          BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/icon/message.svg',
                width: 22,
                height: 22,
                color: Colors.black,
              ),
              icon: SvgPicture.asset(
                'assets/icon/message.svg',
                width: 22,
                height: 22,
                color: Colors.grey[400],
              ),
              label: "채팅"
          ),
          BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/icon/notification.svg',
                width: 22,
                height: 22,
                color: Colors.black,
              ),
              icon: SvgPicture.asset(
                'assets/icon/notification.svg',
                width: 22,
                height: 22,
                color: Colors.grey[400],
              ),
              label: "알림"
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icon/user.svg',
              width: 22,
              height: 22,
              color: Colors.black,
            ),
            icon: SvgPicture.asset(
              'assets/icon/user.svg',
              width: 22,
              height: 22,
              color: Colors.grey[400],
            ),
            label: "내정보"
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icon/user.svg',
              width: 22,
              height: 22,
              color: Colors.black,
            ),
            icon: SvgPicture.asset(
              'assets/icon/user.svg',
              width: 22,
              height: 22,
              color: Colors.grey[400],
            ),
            label: "내정보"
          ),
        ],
        onTap: (int index) {
          onTapHandler(index);
        },
      ),
    );
  }
  void onTapHandler(int index)  {
    setState(() {
      tapCount++;
      selectedIndex = index;
    });
  }
}