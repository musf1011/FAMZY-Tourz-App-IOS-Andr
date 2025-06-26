import 'package:famzy_tourz_app/UI/Auth/SignIn.dart';
import 'package:famzy_tourz_app/UI/Auth/SignUp.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/GoogleSignIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "asset/images/elianna-gill-AnqA_W26zEM-unsplash.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 0.02.sh),
            child: Column(
              children: [
                SizedBox(
                  height: 0.035.sh,
                ),
                Image.asset(
                  "asset/images/FAMZYLogo.png",
                  width: 1.sw,
                  height: .2.sh,
                ),
                SizedBox(
                  height: .07.sh,
                ),
                Text(
                  "FAMZY Tourz",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 57, 2),
                  ),
                ),
                SizedBox(height: 60.h),
                CustomElevatedButton(
                  child: Text("Sign In"),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignIn()));
                  },
                ),
                SizedBox(height: 35.h),
                CustomElevatedButton(
                  child: Text("Sign Up"),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUp()));
                  },
                ),
                SizedBox(height: 80.h),
                Text(
                  "Or continue with \n\n\t\t\t\t\t\t\t\t\t",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 230, 230, 230),
                    fontSize: 12.sp,
                  ),
                ),
                Text('Google'),
                IconButton(
                  icon: Image.asset(
                    'asset/logos/google_logo.png',
                    height: 40.h,
                  ),
                  onPressed: () => _authService.signInWithGoogle(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
