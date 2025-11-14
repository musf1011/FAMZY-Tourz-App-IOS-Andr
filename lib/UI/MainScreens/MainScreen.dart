// Created by: FAMZY CodeWorks
import 'package:famzy_tourz_app/UI/Auth/email_verify.dart';
import 'package:famzy_tourz_app/UI/MainScreens/FeedScreen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/chat_list_screen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/profile_screen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/tour_packages.dart';
import 'package:famzy_tourz_app/contstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Color navigationBarColor = Colors.white;
  int selectedIndex = 0;
  late PageController pageController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isInitialCheckComplete = false;
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    pageController = PageController(initialPage: selectedIndex);
  }

  Future<void> _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isEmailVerified = prefs.getBool('isEmailVerified') ?? false;

    if (!_isEmailVerified) {
      await _verifyEmailStatus();
    } else {
      setState(() => _isInitialCheckComplete = true);
    }
  }

  Future<void> _verifyEmailStatus() async {
    await _auth.currentUser?.reload();
    final isVerified = _auth.currentUser?.emailVerified ?? false;

    if (!isVerified && mounted) {
      await _auth.currentUser?.sendEmailVerification();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const EmailVerificationPendingScreen(),
        ),
      );
    } else if (mounted) {
      setState(() {
        _isEmailVerified = true;
        _isInitialCheckComplete = true;
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialCheckComplete) {
      return const Scaffold(
        body:
            Center(child: SpinKitFadingCircle(color: Colors.yellow, size: 70)),
      );
    }

    if (!_isEmailVerified) {
      return const Scaffold(
        body:
            Center(child: SpinKitFadingCircle(color: Colors.yellow, size: 70)),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: <Widget>[
            FeedScreen(),
            TourPackages(),
            ChatListScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: WaterDropNavBar(
          backgroundColor: AppConstants.primaryColor,
          bottomPadding: 8.h,
          inactiveIconColor: AppConstants.whiteColorP5,
          waterDropColor: Colors.white,
          onItemSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.animateToPage(
              selectedIndex,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuad,
            );
          },
          selectedIndex: selectedIndex,
          barItems: <BarItem>[
            BarItem(
              filledIcon: Icons.festival,
              outlinedIcon: Icons.festival_outlined,
            ),
            BarItem(
              filledIcon: Icons.tour_rounded,
              outlinedIcon: Icons.tour_outlined,
            ),
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
