import 'package:famzy_tourz_app/UI/Auth/SignUp.dart';
import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
import 'package:famzy_tourz_app/UI/Auth/enter_email_for_reset_screen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/MainScreen.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/CustTFField.dart';
import 'package:famzy_tourz_app/Utilities/GoogleSignIn.dart';
import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> keyOfForm = GlobalKey<FormState>();

  bool isLoading = false;

  bool _isPasswordNotVisible = true;

  FirebaseAuth authentic = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  String? g;
  String? p;
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
              fit: BoxFit.fill),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()));
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
                "Sign In",
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 57, 2),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: .03.sw),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: const Color.fromARGB(50, 0, 30, 0)),
                    child: Form(
                      key: keyOfForm,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: .02.sw),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            CustTextFormField(
                              label: 'Gmail',
                              hint: 'you@gmail.com',
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) {
                                g = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Gmail field should be filled';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: .05.sh),
                            CustTextFormField(
                              label: 'Password',
                              hint: 'password',
                              onSaved: (value) {
                                p = value;
                              },
                              isVisible: _isPasswordNotVisible,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password field should be filled';
                                }
                                return null;
                              },
                              toggleVisibility: () {
                                setState(() {
                                  _isPasswordNotVisible =
                                      !_isPasswordNotVisible;
                                });
                              },
                            ),
                            SizedBox(height: 0.01.sh),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EnterEmailForResetScreen()));
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          250, 200, 200, 200),
                                      fontSize: 12.sp),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(height: .025.sh),
              CustomElevatedButton(
                child: isLoading == true
                    ? SpinKitFadingCircle(color: Colors.yellow, size: 70)
                    : Text(
                        'SIGN IN',
                        style: TextStyle(fontSize: 18.sp, color: Colors.white),
                      ),
                onPressed: () async {
                  if (keyOfForm.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    keyOfForm.currentState!.save(); // Save form data

                    authentic
                        .signInWithEmailAndPassword(
                      email: g!.trim(),
                      password: p!.trim(),
                    )
                        .then((value) async {
                      //locally store user is logged in
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', true);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()));

                      ToastPopUp()
                          .toastPopUp('Sign In Successful', Colors.black);
                      keyOfForm.currentState!.reset();
                    }).onError((error, value) {
                      ToastPopUp().toastPopUp(error.toString(), Colors.red);
                      setState(() {
                        isLoading = false;
                      });
                    });
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
              SizedBox(height: .07.sh),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\nDon't have an account?",
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    child: const Text(
                      '\nSign up',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
