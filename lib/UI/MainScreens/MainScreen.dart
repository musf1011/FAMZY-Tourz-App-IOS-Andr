import 'package:famzy_tourz_app/UI/MainScreens/FeedScreen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/Settings.dart';
import 'package:famzy_tourz_app/UI/MainScreens/chat_list_screen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/tour_packages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Color navigationBarColor = Colors.white;
  int selectedIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    /// [AnnotatedRegion<SystemUiOverlayStyle>] only for android black navigation bar. 3 button navigation control (legacy)

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        // backgroundColor: Colors.grey,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: <Widget>[
            FeedScreen(),
            TourPackages(),
            ChatListScreen(),
            Profile(),
          ],
        ),
        bottomNavigationBar: WaterDropNavBar(
          backgroundColor: const Color.fromARGB(255, 0, 57, 2),
          bottomPadding: 8.h,
          inactiveIconColor: const Color.fromARGB(255, 210, 210, 210),
          waterDropColor: Colors.white,
          onItemSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad);
          },
          selectedIndex: selectedIndex,
          barItems: <BarItem>[
            BarItem(
              filledIcon: Icons.festival,
              outlinedIcon: Icons.festival_outlined,
            ),
            BarItem(
                filledIcon: Icons.tour_rounded,
                outlinedIcon: Icons.tour_outlined),
            BarItem(
              filledIcon: Icons.email_rounded,
              outlinedIcon: Icons.email_outlined,
            ),
            BarItem(
              filledIcon: Icons.folder_rounded,
              outlinedIcon: Icons.folder_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
