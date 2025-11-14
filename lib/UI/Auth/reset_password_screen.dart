import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/CustTFField.dart';
import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? newPassword;
  String? confirmPassword;
  bool isLoading = false;
  bool isPasswordNotVisible = true;

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
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 0.1.sh),
                Text(
                  "Reset Your Password",
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.04.sh),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustTextFormField(
                        label: 'New Password',
                        hint: 'Enter new password',
                        obscureText: true,
                        isVisible: isPasswordNotVisible,
                        onSaved: (val) => newPassword = val,
                        validator: (val) => val == null || val.length < 6
                            ? 'Enter at least 6 characters'
                            : null,
                        toggleVisibility: () {
                          setState(() {
                            isPasswordNotVisible = !isPasswordNotVisible;
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustTextFormField(
                        label: 'Confirm Password',
                        hint: 'Re-enter new password',
                        obscureText: true,
                        isVisible: isPasswordNotVisible,
                        onSaved: (val) => confirmPassword = val,
                        validator: (val) => val != newPassword
                            ? 'Passwords do not match'
                            : null,
                        toggleVisibility: () {
                          setState(() {
                            isPasswordNotVisible = !isPasswordNotVisible;
                          });
                        },
                      ),
                      SizedBox(height: 40.h),
                      CustomElevatedButton(
                        child: isLoading
                            ? const SpinKitFadingCircle(
                                color: Colors.yellow, size: 70)
                            : Text(
                                'Reset Password',
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.white),
                              ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            setState(() => isLoading = true);

                            try {
                              User? user = _auth.currentUser;

                              if (user != null) {
                                await user.updatePassword(newPassword!);
                                ToastPopUp().toastPopUp(
                                    'Password reset successfully!',
                                    Colors.green);
                                Navigator.pop(context);
                              }
                            } catch (error) {
                              ToastPopUp()
                                  .toastPopUp(error.toString(), Colors.red);
                            } finally {
                              setState(() => isLoading = false);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
