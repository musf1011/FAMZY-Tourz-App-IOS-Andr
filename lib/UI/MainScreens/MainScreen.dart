// import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/FeedScreen.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/Settings.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/tour_packages.dart';
// import 'package:flutter/material.dart';

// class MainScreen extends StatefulWidget {
//   final int selectedIndex;
//   const MainScreen({super.key, this.selectedIndex = 0});

//   @override
//   State<MainScreen> createState() => _MainScreenState(selectedIndex);
// }

// class _MainScreenState extends State<MainScreen> {
//   int selectedIndex;

//   _MainScreenState(this.selectedIndex);
//   late final NotchBottomBarController _controller;

//   final List<Widget> _screens = [
//     const FeedScreen(),
//     TourPackages(),
//     // PostingScreen(),
//     Profile()
//     // const SettingProfile()
//   ];

//   void _onItemTapped(int index) {
//     setState(() {

//       selectedIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _controller = NotchBottomBarController(widget.selectedIndex);
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Dispose of the controller to avoid memory leaks
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // appBar: AppBar(
//         //   title: Text('FAMZY'),
//         //   centerTitle: true,
//         // ),
//         body: _screens[selectedIndex],
//         bottomNavigationBar: AnimatedNotchBottomBar(
//           /// Provide NotchBottomBarController
//           notchBottomBarController: selectedIndex,

//           color: Colors.white,
//           showLabel: true,
//           textOverflow: TextOverflow.visible,
//           maxLine: 1,
//           shadowElevation: 5,
//           kBottomRadius: 28.0,

//           // notchShader: const SweepGradient(
//           //   startAngle: 0,
//           //   endAngle: pi / 2,
//           //   colors: [Colors.red, Colors.green, Colors.orange],
//           //   tileMode: TileMode.mirror,
//           // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
//           notchColor: Colors.black87,

//           /// restart app if you change removeMargins
//           removeMargins: false,
//           bottomBarWidth: 500,
//           showShadow: false,
//           durationInMilliSeconds: 300,

//           itemLabelStyle: const TextStyle(fontSize: 10),

//           elevation: 1,
//           bottomBarItems: const [
//             BottomBarItem(
//               inActiveItem: Icon(
//                 Icons.home_filled,
//                 color: Colors.blueGrey,
//               ),
//               activeItem: Icon(
//                 Icons.home_filled,
//                 color: Colors.blueAccent,
//               ),
//               itemLabel: 'Page 1',
//             ),
//             BottomBarItem(
//               inActiveItem: Icon(Icons.star, color: Colors.blueGrey),
//               activeItem: Icon(
//                 Icons.star,
//                 color: Colors.blueAccent,
//               ),
//               itemLabel: 'Page 2',
//             ),
//             BottomBarItem(
//               inActiveItem: Icon(
//                 Icons.settings,
//                 color: Colors.blueGrey,
//               ),
//               activeItem: Icon(
//                 Icons.settings,
//                 color: Colors.pink,
//               ),
//               itemLabel: 'Page 3',
//             ),
//             BottomBarItem(
//               inActiveItem: Icon(
//                 Icons.person,
//                 color: Colors.blueGrey,
//               ),
//               activeItem: Icon(
//                 Icons.person,
//                 color: Colors.yellow,
//               ),
//               itemLabel: 'Page 4',
//             ),
//           ],
//           onTap: _onItemTapped,
//           kIconSize: 24.0,
//         )

//         //   BottomNavigationBar(
//         //     currentIndex: selectedIndex,
//         //     onTap: _onItemTapped,
//         //     items: const [
//         //       BottomNavigationBarItem(
//         //         icon: Icon(Icons.home),
//         //         label: 'Home',
//         //       ),
//         //       BottomNavigationBarItem(
//         //         icon: Icon(Icons.calendar_today),
//         //         label: 'Appointments',
//         //       ),
//         //       BottomNavigationBarItem(
//         //         icon: Icon(Icons.person),
//         //         label: 'Profile',
//         //       ),
//         //     ],
//         //   ),
//         );
//   }
// }

import 'package:famzy_tourz_app/UI/MainScreens/FeedScreen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/Settings.dart';
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
            Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.folder_rounded,
                size: 56,
                color: Colors.green,
              ),
            ),
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
