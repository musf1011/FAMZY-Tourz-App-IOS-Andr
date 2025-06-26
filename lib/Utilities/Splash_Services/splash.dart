// import 'dart:async';

// import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/MainScreen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Splashservices {
//   void isLogin(BuildContext context) {
//     Timer(const Duration(seconds: 5), () {
//       FirebaseAuth authent = FirebaseAuth.instance;
//       final user = authent.currentUser;

//       if (user == null) {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
//       } else {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => MainScreen()));
//       }
//     });
//   }
// }

import 'dart:async';

import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashservices {
  void isLogin(BuildContext context) {
    Timer(const Duration(seconds: 5), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      }
    });
  }
}
