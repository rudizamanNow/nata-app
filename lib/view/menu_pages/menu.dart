import 'package:flutter/material.dart' hide Badge;
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:get/get.dart';
import 'package:nata/controller/habit_controller.dart';
import 'package:nata/utils/colors.dart';
import 'package:nata/view/menu_pages/add_habit_page.dart';
import 'package:nata/view/menu_pages/explore_habit_page.dart';
import 'package:nata/view/menu_pages/home_page.dart';
import 'package:nata/view/menu_pages/progress_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    _pageController = PageController(initialPage: currentIndex);
  }

  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
      _pageController.animateToPage(currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: const <Widget>[
          HomePage(),
          ExploreHabitPage(),
          ProgressPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => const AddHabitPage());
          Get.find<HabitController>().loadAllHabits();
        },
        backgroundColor: bluishClr,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Colors.white,
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        opacity: 1,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        elevation: 10,
        tilesPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        items: const <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: bluishClr,
            icon: Icon(
              Icons.home,
              color: darkHeaderClr,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text(
              "Home",
              style: TextStyle(color: Color(0xFFFFFFFF)),
            ),
          ),
          BubbleBottomBarItem(
              backgroundColor: bluishClr,
              icon: Icon(
                Icons.explore,
                color: darkHeaderClr,
              ),
              activeIcon: Icon(
                Icons.explore,
                color: Colors.white,
              ),
              title: Text(
                "Explore",
                style: TextStyle(color: Color(0xFFFFFFFF)),
              )),
          BubbleBottomBarItem(
              backgroundColor: bluishClr,
              icon: Icon(
                Icons.bar_chart_rounded,
                color: darkHeaderClr,
              ),
              activeIcon: Icon(
                Icons.bar_chart_rounded,
                color: Colors.white,
              ),
              title: Text(
                "Progress",
                style: TextStyle(color: Color(0xFFFFFFFF)),
              )),
        ],
      ),
    );
  }
}
