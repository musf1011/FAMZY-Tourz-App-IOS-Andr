// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:famzy_tourz_app/UI/Auth/SignIn.dart';
// import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/MainScreen.dart';
// import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
// import 'package:famzy_tourz_app/Utilities/CustTFField.dart';
// import 'package:famzy_tourz_app/Utilities/GoogleSignIn.dart';
// import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   bool _isPasswordNotVisible = true;

//   bool isLoading = false;

//   final keyOfForm = GlobalKey<FormState>();
//   FirebaseAuth authent = FirebaseAuth.instance;
//   FirebaseFirestore fStore = FirebaseFirestore.instance;
//   final AuthService _authService = AuthService();

//   String? selectedGender;
//   String? fn;
//   String? gm;
//   String? pw;
//   String? cpw;
//   String? age;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//               'asset/images/elianna-gill-AnqA_W26zEM-unsplash.jpg',
//             ),
//             fit: BoxFit.fill,
//           ),
//         ),
//         height: 1.sh,
//         width: 1.sw,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(top: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => WelcomeScreen()));
//                       },
//                       child: Icon(
//                         Icons.arrow_circle_left_outlined,
//                         size: 40.h,
//                         color: const Color.fromARGB(180, 0, 30, 0),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
//                       child: Image.asset(
//                         "asset/images/FAMZYLogo.png",
//                         width: .8.sw,
//                         height: .2.sh,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: .03.sw),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: const Color.fromARGB(50, 0, 30, 0)),
//                   child: Form(
//                     key: keyOfForm,
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 0.009.sh,
//                           ),
//                           // SizedBox(height: 0.02.sh),
//                           CustTextFormField(
//                             label: 'Full Name',
//                             hint: 'Billy Boy',
//                             onSaved: (value) {
//                               fn = value;
//                             },
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Full Name can not be empty';
//                               } else {
//                                 return null;
//                               }
//                             },
//                           ),

//                           CustTextFormField(
//                             label: 'G-Mail',
//                             hint: 'you@gmail.com',
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Please enter a valid G-Mail';
//                               } else {
//                                 return null;
//                               }
//                             },
//                             onSaved: (value) {
//                               print('value: $value');
//                               gm = value;
//                             },
//                           ),
//                           CustTextFormField(
//                             label: 'Password',
//                             hint: 'password',
//                             onSaved: (value) {
//                               pw = value;
//                             },
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Password can not be empty';
//                               } else {
//                                 return null;
//                               }
//                             },
//                             obscureText: true,
//                             isVisible: _isPasswordNotVisible,
//                             toggleVisibility: () {
//                               setState(() {
//                                 _isPasswordNotVisible = !_isPasswordNotVisible;
//                               });
//                             },
//                           ),
//                           CustTextFormField(
//                             label: 'Confirm Password',
//                             hint: 'password',
//                             onSaved: (value) {
//                               cpw = value;
//                             },
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Confirm your password as well';
//                               } else {
//                                 return null;
//                               }
//                             },
//                             obscureText: true,
//                             isVisible: _isPasswordNotVisible,
//                             toggleVisibility: () {
//                               setState(() {
//                                 _isPasswordNotVisible = !_isPasswordNotVisible;
//                               });
//                             },
//                           ),
//                           Row(
//                             children: [
//                               SizedBox(
//                                   width: .5.sw,
//                                   child: CustTextFormField(
//                                     label: 'Age',
//                                     hint: '18',
//                                     keyboardType: TextInputType.number,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your age';
//                                       }
//                                       final age = int.tryParse(value);
//                                       if (age == null ||
//                                           age <= 0 ||
//                                           age > 130) {
//                                         return 'Invalid age, it should be between 13 and 130';
//                                       }
//                                       if (age < 13) {
//                                         return 'You are underage'; // Not eligible
//                                       }
//                                       return null;
//                                     },
//                                     onSaved: (value) {
//                                       int age = int.tryParse(value!) ??
//                                           0; // Parse and set 0 if invalid
//                                       if (age < 1 || age > 130) {
//                                         age = 0; // Enforce 0 for invalid ranges
//                                       }
//                                     },
//                                   )),
//                               Padding(
//                                 padding: EdgeInsets.only(left: .03.sw),
//                                 child: SizedBox(
//                                   width: .35.sw,
//                                   child: DropdownButtonFormField<String>(
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please select your gender';
//                                       }
//                                       return null;
//                                     },
//                                     decoration: InputDecoration(
//                                       label: Text(
//                                         'Gender',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                       fillColor: Colors
//                                           .white, // Background color of the dropdown
//                                       hintText: 'Gender',
//                                       hintStyle:
//                                           const TextStyle(color: Colors.white),

//                                       enabledBorder: UnderlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: Colors
//                                               .grey, // Underline color when enabled
//                                           width: 1.0, // Underline width
//                                         ),
//                                       ),
//                                       focusedBorder: UnderlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: const Color.fromARGB(
//                                               255,
//                                               123,
//                                               100,
//                                               22), // Underline color when focused
//                                           width: 2.0, // Underline width
//                                         ),
//                                       ),
//                                     ),
//                                     dropdownColor: const Color.fromARGB(
//                                         180,
//                                         0,
//                                         30,
//                                         0), // Dropdown menu background color
//                                     value: selectedGender,
//                                     items: [
//                                       DropdownMenuItem(
//                                         value: 'male',
//                                         child: const Text(
//                                           'Male',
//                                           style: TextStyle(
//                                               color: Color.fromARGB(
//                                                   255, 95, 176, 241)),
//                                         ),
//                                       ),
//                                       DropdownMenuItem(
//                                         value: 'female',
//                                         child: const Text(
//                                           'Female',
//                                           style: TextStyle(
//                                               color: Color.fromARGB(
//                                                   255, 255, 109, 157)),
//                                         ),
//                                       ),
//                                     ],
//                                     onChanged: (String? newValue) {
//                                       setState(() {
//                                         selectedGender = newValue;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(
//                             height: 15.h,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: .022.sh),
//               CustomElevatedButton(
//                 child: isLoading
//                     ? const CircularProgressIndicator(
//                         color: Colors.white,
//                       )
//                     : Text(
//                         'SIGN UP',
//                         style: TextStyle(fontSize: 18.sp, color: Colors.white),
//                       ),
//                 onPressed: () async {
//                   // Performing sign up
//                   setState(() {
//                     isLoading = true;
//                   });
//                   print('run start');
//                   if (keyOfForm.currentState!.validate()) {
//                     print('validated');
//                     print('gm: $gm');
//                     print('pw: $pw');
//                     authent
//                         .createUserWithEmailAndPassword(
//                             email: gm!.trim(), password: pw!.trim())
//                         .then((value) {
//                       print('user created time for fstore');
//                       fStore
//                           .collection('UserDetails')
//                           .doc(value.user!.uid)
//                           .set({
//                         'fullName': fn!.trim(),
//                         'email': gm!.trim(),
//                         'password': pw!.trim(),
//                         'createdAt': FieldValue.serverTimestamp(),
//                         'age': int.parse(age!),
//                         'gender': selectedGender,
//                         'userID': value.user!.uid,
//                       });

//                       ToastPopUp()
//                           .toastPopUp('Sign Up Successful', Colors.black);

//                       // Navigate to main screen after saving data
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const MainScreen()));
//                       setState(() {
//                         isLoading = false;
//                       });
//                       keyOfForm.currentState!.reset();
//                     }).onError((error, value) {
//                       ToastPopUp().toastPopUp(error.toString(), Colors.black);
//                       setState(() {
//                         isLoading = false;
//                       });
//                     });
//                   } else {
//                     setState(() {
//                       isLoading = false;
//                     });
//                   }
//                 },
//               ),
//               Text(
//                 "\n\n\nOr continue with \n\n\t\t\t\t\t\t\t\t\t",
//                 style: TextStyle(
//                   color: const Color.fromARGB(255, 230, 230, 230),
//                   fontSize: 12.sp,
//                 ),
//               ),
//               Text('Google'),
//               IconButton(
//                 icon: Image.asset(
//                   'asset/logos/google_logo.png', // Add your Google logo image to assets
//                   height: 35.h, // Adjust size as needed
//                 ),
//                 onPressed: () => _authService.signInWithGoogle(context),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "\nAlready have an account?",
//                     style: TextStyle(color: Colors.white, fontSize: 12.sp),
//                   ),
//                   const SizedBox(width: 8.0),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const SignIn()));
//                     },
//                     child: const Text(
//                       '\nLog In',
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 30.h,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/UI/Auth/SignIn.dart';
import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
import 'package:famzy_tourz_app/UI/Auth/email_verify.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/CustTFField.dart';
import 'package:famzy_tourz_app/Utilities/GoogleSignIn.dart';
import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isPasswordNotVisible = true;
  bool isLoading = false;

  final keyOfForm = GlobalKey<FormState>();
  FirebaseAuth authent = FirebaseAuth.instance;
  FirebaseFirestore fStore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  String? selectedGender;
  String? fn;
  String? gm;
  String? pw;
  String? cpw;
  int? age;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'asset/images/elianna-gill-AnqA_W26zEM-unsplash.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        height: 1.sh,
        width: 1.sw,
        child: SingleChildScrollView(
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
                                builder: (context) => WelcomeScreen()));
                      },
                      child: Icon(
                        Icons.arrow_circle_left_outlined,
                        size: 40.h,
                        color: const Color.fromARGB(180, 0, 30, 0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
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
                "Sign Up",
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
                      padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 0.009.sh,
                          ),
                          CustTextFormField(
                            label: 'Full Name',
                            hint: 'Billy Boy',
                            onSaved: (value) {
                              fn = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Full Name can not be empty';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustTextFormField(
                            label: 'G-Mail',
                            hint: 'you@gmail.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid G-Mail';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              gm = value;
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustTextFormField(
                            label: 'Password',
                            hint: 'password',
                            onSaved: (value) {
                              pw = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password can not be empty';
                              } else {
                                return null;
                              }
                            },
                            obscureText: true,
                            isVisible: _isPasswordNotVisible,
                            toggleVisibility: () {
                              setState(() {
                                _isPasswordNotVisible = !_isPasswordNotVisible;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustTextFormField(
                            label: 'Confirm Password',
                            hint: 'password',
                            onSaved: (value) {
                              cpw = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Confirm your password as well';
                              } else if (cpw != pw) {
                                return 'Passwords do not match';
                              } else {
                                return null;
                              }
                            },
                            obscureText: true,
                            isVisible: _isPasswordNotVisible,
                            toggleVisibility: () {
                              setState(() {
                                _isPasswordNotVisible = !_isPasswordNotVisible;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: .5.sw,
                                child: CustTextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  label: 'Age',
                                  hint: '18',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your age';
                                    }
                                    final age = int.tryParse(value);
                                    if (age == null || age <= 0 || age > 130) {
                                      return 'Invalid age, it should be between 13 and 130';
                                    }
                                    if (age < 13) {
                                      return 'You are underage'; // Not eligible
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    age = int.tryParse(value!) ??
                                        0; // Parse and set 0 if invalid
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: .03.sw),
                                child: SizedBox(
                                  width: .35.sw,
                                  child: DropdownButtonFormField<String>(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select your gender';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      label: Text(
                                        'Gender',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      fillColor: Colors.white,
                                      hintText: 'Not Selected',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 14.sp),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 123, 100, 22),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(15.r),
                                    dropdownColor:
                                        const Color.fromARGB(180, 0, 30, 0),
                                    value: selectedGender,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'male',
                                        child: const Text(
                                          'Male',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 95, 176, 241)),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'female',
                                        child: const Text(
                                          'Female',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 109, 157)),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'other',
                                        child: const Text(
                                          'other',
                                          style:
                                              TextStyle(color: Colors.yellow),
                                        ),
                                      ),
                                    ],
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedGender = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: .018.sh),
              CustomElevatedButton(
                child: isLoading
                    ? const SpinKitFadingCircle(color: Colors.yellow, size: 70)
                    : Text(
                        'SIGN UP',
                        style: TextStyle(fontSize: 18.sp, color: Colors.white),
                      ),
                onPressed: () async {
                  // Save the form before processing
                  if (keyOfForm.currentState!.validate()) {
                    keyOfForm.currentState!.save(); // Save form data

                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final userCredential =
                          await authent.createUserWithEmailAndPassword(
                        email: gm!.trim(),
                        password: pw!.trim(),
                      );

                      await fStore
                          .collection('UserDetails')
                          .doc(userCredential.user!.uid)
                          .set({
                        'fullName': fn!.trim(),
                        'email': gm!.trim(),
                        'createdAt': FieldValue.serverTimestamp(),
                        'age': age,
                        'gender': selectedGender,
                        'userId': userCredential.user!.uid,
                        'photoURL': ''
                      });
                      //stor if user is looged in local DataBase
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', true);

                      // Send verificate email
                      await userCredential.user!.sendEmailVerification();

                      ToastPopUp().toastPopUp(
                        'Verification email sent to ${gm!.trim()}',
                        Colors.black,
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const EmailVerificationPendingScreen(),
                        ),
                      );
                      // Only reset the form if navigation was successful
                      keyOfForm.currentState!.reset();
                    } catch (error) {
                      ToastPopUp().toastPopUp(error.toString(), Colors.black);
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
              ),
              Text(
                "\nOr continue with \n\n\t\t\t\t\t\t\t\t\t",
                style: TextStyle(
                  color: const Color.fromARGB(255, 230, 230, 230),
                  fontSize: 12.sp,
                ),
              ),
              Text('Google'),
              IconButton(
                icon: Image.asset(
                  'asset/logos/google_logo.png',
                  height: 35.h,
                ),
                onPressed: () => _authService.signInWithGoogle(context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()));
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
