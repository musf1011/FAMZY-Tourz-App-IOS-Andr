import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/auth_services.dart';
import 'package:famzy_tourz_app/UI/MainScreens/Settings.dart';
import 'package:famzy_tourz_app/contstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 0, 40, 0),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //          ----- TOP SECTION ------
            Column(
              children: [
                // Header
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 60, 0),
                    border: Border(
                      bottom: BorderSide(
                          color: AppConstants.tertiaryColor, width: 1.5),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "asset/images/FAMZYLogo.png",
                          width: .3.sw,
                          height: .1.sh,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "FAMZY Tourz",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                //           ------ HOME   BUTTON ------
                Padding(
                  padding: EdgeInsets.only(left: 10.w, top: 20.h, right: 90.w),
                  child: CustomElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.home_rounded,
                            color: AppConstants.primaryColor, size: 22.sp),
                        SizedBox(width: 10.w),
                        Text(
                          'HOME',
                          style: TextStyle(
                            fontFamily: GoogleFonts.playfairDisplay.toString(),
                            color: Colors.white,
                            fontSize: 16.sp,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //                  ----- SETTINGS BUTTON ------
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.w,
                    top: 15.h,
                    right: 90.w,
                  ),
                  child: CustomElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Settings()),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.settings_rounded,
                            color: AppConstants.primaryColor, size: 22.sp),
                        SizedBox(width: 10.w),
                        Text(
                          'SETTINGS',
                          style: TextStyle(
                            fontFamily: GoogleFonts.playfairDisplay.toString(),
                            color: Colors.white,
                            fontSize: 18.sp,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ---------- LOGOUT BUTTON ----------
            Padding(
              padding: EdgeInsets.only(
                  left: 10.w, top: 20.h, right: 90.w, bottom: 25.h),
              child: CustomElevatedButton(
                onPressed: () async {
                  await AuthServices.signOut(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.red, size: 22.sp),
                    SizedBox(width: 12.w),
                    Text(
                      'LOGOUT',
                      style: TextStyle(
                        fontFamily: GoogleFonts.playfairDisplay.toString(),
                        color: Colors.white,
                        fontSize: 18.sp,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
