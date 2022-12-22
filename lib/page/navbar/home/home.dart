import 'package:flutter/material.dart';
import 'package:open_diary/page/navbar/home/tab1.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _nestedTabController;

  @override
  void initState() {
    super.initState();
    _nestedTabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 25,),
        TabBar(
          controller: _nestedTabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          tabs: const [
            Tab(
              text: "근처",
            ),
            Tab(
              text: "인기",
            ),
            Tab(
              text: "새로운",
            ),
            Tab(
              text: "태그",
            ),
            Tab(
              text: "Five",
            ),
          ],
        ),
        Expanded(
          child: SizedBox(
            height: screenHeight,
            child: TabBarView(
              controller: _nestedTabController,
              children: const [
                Tab1(),
                Tab1(),
                Tab1(),
                Tab1(),
                Tab1(),
              ],
            ),
          ),
        )
      ],
    );
  }
}