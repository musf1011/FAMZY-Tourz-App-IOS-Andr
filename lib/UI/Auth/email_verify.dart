// // Add this new screen for email verification handling
// import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/MainScreen.dart';
// import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
// import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EmailVerificationPendingScreen extends StatefulWidget {
//   const EmailVerificationPendingScreen({super.key});

//   @override
//   State<EmailVerificationPendingScreen> createState() =>
//       _EmailVerificationPendingScreenState();
// }

// class _EmailVerificationPendingScreenState
//     extends State<EmailVerificationPendingScreen> {
//   bool isVerified = false;
//   bool isLoading = false;
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     checkEmailVerification();
//   }

//   Future<void> checkEmailVerification() async {
//     try {
//       // Reload user to get latest verification status
//       await auth.currentUser?.reload();
//       final user = auth.currentUser;

//       if (user != null && user.emailVerified) {
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const MainScreen()),
//           );
//         }
//       }
//     } catch (error) {
//       ToastPopUp().toastPopUp(error.toString(), Colors.red);
//     }
//   }

//   Future<void> resendVerificationEmail() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       await auth.currentUser?.sendEmailVerification();
//       ToastPopUp().toastPopUp('Verification email resent!', Colors.black);
//     } catch (error) {
//       ToastPopUp().toastPopUp('Error: ${error.toString()}', Colors.red);
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: 1.sh,
//         width: 1.sw,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage(
//                   'asset/images/elianna-gill-AnqA_W26zEM-unsplash.jpg'),
//               fit: BoxFit.fill),
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => WelcomeScreen()));
//                     },
//                     child: Icon(
//                       Icons.arrow_circle_left_outlined,
//                       size: 40.h,
//                       color: const Color.fromARGB(180, 0, 30, 0),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
//                     child: Image.asset(
//                       "asset/images/FAMZYLogo.png",
//                       width: .8.sw,
//                       height: .2.sh,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               "Verify Your Email",
//               textAlign: TextAlign.center,
//               style: GoogleFonts.lato(
//                 fontSize: 26.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Color.fromARGB(255, 0, 57, 2),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(20.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: const Color.fromARGB(50, 0, 30, 0)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 20.h),
//                     Text(
//                       'A verification email has been sent to your email address.\nPlease check your inbox and verify your email.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         color: Colors.white,
//                         fontFamily: 'Poppins', // Add this in pubspec.yaml
//                         fontWeight: FontWeight.w400, // Regular
//                       ),
//                     ),
//                     SizedBox(height: 30.h),
//                     CustomElevatedButton(
//                       child: isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : Text(
//                               'Resend Verification Email',
//                               style: TextStyle(fontSize: 16.sp),
//                             ),
//                       onPressed: resendVerificationEmail,
//                     ),
//                     SizedBox(height: 20.h),
//                     TextButton(
//                       onPressed: () async {
//                         await checkEmailVerification();
//                       },
//                       child: Text(
//                         'Already verified? Refresh status',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14.sp,
//                           shadows: [
//                             Shadow(
//                               color: Colors.black.withOpacity(0.3),
//                               blurRadius: 2,
//                               offset: Offset(1, 1),
//                             ),
//                           ],
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// // }

// import 'dart:async';

// import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/MainScreen.dart';
// import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
// import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EmailVerificationPendingScreen extends StatefulWidget {
//   const EmailVerificationPendingScreen({super.key});

//   @override
//   State<EmailVerificationPendingScreen> createState() =>
//       _EmailVerificationPendingScreenState();
// }

// class _EmailVerificationPendingScreenState
//     extends State<EmailVerificationPendingScreen> {
//   bool isLoading = false;
//   bool isChecking = false;
//   Timer? _verificationTimer;
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     _startVerificationCheck();
//   }

//   @override
//   void dispose() {
//     _verificationTimer?.cancel();
//     super.dispose();
//   }

//   void _startVerificationCheck() {
//     // Check every 3 seconds
//     _verificationTimer =
//         Timer.periodic(const Duration(seconds: 5), (timer) async {
//       await _checkEmailVerification();
//     });
//   }

//   Future<void> _checkEmailVerification() async {
//     if (isChecking) return;

//     try {
//       setState(() => isChecking = true);

//       await auth.currentUser?.reload();
//       final user = auth.currentUser;

//       if (user != null && user.emailVerified) {
//         if (mounted) {
//           _verificationTimer?.cancel();
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const MainScreen()),
//           );
//         }
//       }
//     } catch (error) {
//       if (mounted) {
//         ToastPopUp()
//             .toastPopUp("Error checking verification: $error", Colors.red);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => isChecking = false);
//       }
//     }
//   }

//   Future<void> resendVerificationEmail() async {
//     try {
//       setState(() => isLoading = true);
//       await auth.currentUser?.sendEmailVerification();
//       if (mounted) {
//         ToastPopUp().toastPopUp('Verification email resent!', Colors.black);
//       }
//     } catch (error) {
//       if (mounted) {
//         ToastPopUp().toastPopUp('Error: ${error.toString()}', Colors.red);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: 1.sh,
//         width: 1.sw,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//                 'asset/images/elianna-gill-AnqA_W26zEM-unsplash.jpg'),
//             fit: BoxFit.fill,
//           ),
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => WelcomeScreen()),
//                       );
//                     },
//                     child: Icon(
//                       Icons.arrow_circle_left_outlined,
//                       size: 40.h,
//                       color: const Color.fromARGB(180, 0, 30, 0),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
//                     child: Image.asset(
//                       "asset/images/FAMZYLogo.png",
//                       width: .8.sw,
//                       height: .2.sh,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               "Verify Your Email",
//               textAlign: TextAlign.center,
//               style: GoogleFonts.lato(
//                 fontSize: 26.sp,
//                 fontWeight: FontWeight.bold,
//                 color: const Color.fromARGB(255, 0, 57, 2),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(20.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: const Color.fromARGB(50, 0, 30, 0),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 20.h),
//                     Text(
//                       'A verification email has been sent to your email address.\nPlease check your inbox and verify your email.',
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.poppins(
//                         fontSize: 16.sp,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     SizedBox(height: 30.h),
//                     CustomElevatedButton(
//                       onPressed: resendVerificationEmail,
//                       child: isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : Text(
//                               'Resend Verification Email',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16.sp,
//                                 color: Colors.white,
//                               ),
//                             ),
//                     ),
//                     SizedBox(height: 20.h),
//                     TextButton(
//                       onPressed: () async {
//                         await _checkEmailVerification();
//                       },
//                       child: Text(
//                         'Already verified? Refresh status',
//                         style: GoogleFonts.poppins(
//                           fontSize: 14.sp,
//                           color: Colors.white,
//                           shadows: [
//                             Shadow(
//                               color: Colors.black.withOpacity(0.3),
//                               blurRadius: 2,
//                               offset: const Offset(1, 1),
//                             ),
//                           ],
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10.h),
//                     if (isChecking)
//                       Padding(
//                         padding: EdgeInsets.only(top: 10.h),
//                         child: Text(
//                           'Checking verification status...',
//                           style: GoogleFonts.poppins(
//                             fontSize: 12.sp,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/MainScreen.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailVerificationPendingScreen extends StatefulWidget {
  const EmailVerificationPendingScreen({super.key});

  @override
  State<EmailVerificationPendingScreen> createState() =>
      _EmailVerificationPendingScreenState();
}

class _EmailVerificationPendingScreenState
    extends State<EmailVerificationPendingScreen> {
  bool isLoading = false;
  bool isChecking = false;
  bool canResendEmail = false;
  int resendCooldown = 60;
  Timer? _verificationTimer;
  Timer? _cooldownTimer;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
    _startCooldownTimer(); // Initialize cooldown timer
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startVerificationCheck() {
    _verificationTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _checkEmailVerification();
    });
  }

  void _startCooldownTimer() {
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown > 0) {
        setState(() => resendCooldown--);
      } else {
        if (!canResendEmail) {
          setState(() => canResendEmail = true);
        }
      }
    });
  }

  Future<void> _checkEmailVerification() async {
    if (isChecking) return;

    try {
      setState(() => isChecking = true);
      await auth.currentUser?.reload();
      final user = auth.currentUser;

      if (user != null && user.emailVerified) {
        if (mounted) {
          _verificationTimer?.cancel();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
          //locally store is email verified?
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isEmailVerified', true);
        }
      }
    } catch (error) {
      if (mounted) {
        ToastPopUp()
            .toastPopUp("Error checking verification: $error", Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => isChecking = false);
      }
    }
  }

  Future<void> resendVerificationEmail() async {
    if (!canResendEmail) return;

    setState(() {
      isLoading = true;
      canResendEmail = false;
      resendCooldown = 60;
    });

    try {
      await auth.currentUser?.sendEmailVerification();
      if (mounted) {
        ToastPopUp().toastPopUp('Verification email resent!', Colors.black);
      }
    } catch (error) {
      if (mounted) {
        setState(() => canResendEmail = true); // Re-enable on error
        ToastPopUp().toastPopUp('Error: ${error.toString()}', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'asset/images/elianna-gill-AnqA_W26zEM-unsplash.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()),
                      );
                    },
                    child: Icon(
                      Icons.arrow_circle_left_outlined,
                      size: 40.h,
                      color: const Color.fromARGB(180, 0, 30, 0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
                    child: Image.asset(
                      "asset/images/FAMZYLogo.png",
                      width: .8.sw,
                      height: .2.sh,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "Verify Your Email",
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 57, 2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: const Color.fromARGB(50, 0, 30, 0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'A verification email has been sent to your email address.\nPlease check your inbox and verify your email.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    CustomElevatedButton(
                      onPressed: canResendEmail
                          ? () {
                              resendVerificationEmail();
                            }
                          : () {},
                      child: isLoading
                          ? const SpinKitFadingCircle(
                              color: Colors.yellow, size: 70)
                          : Text(
                              canResendEmail
                                  ? 'Resend Verification Email'
                                  : 'Resend in $resendCooldown sec',
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    SizedBox(height: 20.h),
                    TextButton(
                      onPressed: _checkEmailVerification,
                      child: Text(
                        'Already verified? Refresh status',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(1, 1),
                            ),
                          ],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (isChecking)
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Text(
                          'Checking verification status...',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: Colors.white70,
                          ),
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
