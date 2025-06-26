import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
import 'package:famzy_tourz_app/UI/Auth/email_verify.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/CustTFField.dart';
import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterEmailForResetScreen extends StatefulWidget {
  const EnterEmailForResetScreen({super.key});

  @override
  State<EnterEmailForResetScreen> createState() =>
      _EnterEmailForResetScreenState();
}

class _EnterEmailForResetScreenState extends State<EnterEmailForResetScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? email;
  bool isLoading = false;

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
              SizedBox(height: 0.02.sh),
              Text(
                "Forgot Password?",
                style: GoogleFonts.lato(
                  fontSize: 26.sp,
                  color: Color.fromARGB(255, 0, 57, 2),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: .03.sw),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(50, 0, 30, 0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 15.h),
                        Text(
                          'Enter your email address and we’ll send you a link to reset your password.',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30.h),
                        Form(
                          key: formKey,
                          child: CustTextFormField(
                            label: 'Gmail',
                            hint: 'you@example.com',
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (val) => email = val,
                            validator: (val) => val == null || val.isEmpty
                                ? 'Please enter your email'
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        )
                      ],
                    ),
                  )),
              SizedBox(height: 40.h),
              CustomElevatedButton(
                child: isLoading
                    ? const SpinKitFadingCircle(color: Colors.yellow, size: 70)
                    : Text(
                        'Send Reset Email',
                        style: TextStyle(fontSize: 18.sp, color: Colors.white),
                      ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    setState(() => isLoading = true);

                    try {
                      await _auth.sendPasswordResetEmail(email: email!.trim());

                      ToastPopUp().toastPopUp(
                          'Reset link sent to $email', Colors.green);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const EmailVerificationPendingScreen(),
                        ),
                      );
                    } catch (error) {
                      ToastPopUp().toastPopUp(error.toString(), Colors.red);
                    } finally {
                      setState(() => isLoading = false);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
