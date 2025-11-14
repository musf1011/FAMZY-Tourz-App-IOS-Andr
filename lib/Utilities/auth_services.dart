import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Signs out the current user from all providers (Firebase + Google)
  static Future<void> signOut(BuildContext context) async {
    try {
      // Firebase Sign Out
      await _auth.signOut();

      // If signed in with Google, sign out there too
      final isGoogleSignedIn = await _googleSignIn.isSignedIn();
      if (isGoogleSignedIn) {
        try {
          await _googleSignIn.signOut();
          await _googleSignIn.disconnect();
        } catch (e) {
          debugPrint("Google SignOut Error: $e");
        }
      }

      // Update local login flags
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.setBool('isEmailVerified', false);

      // Navigate to Welcome Screen
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
          (route) => false,
        );
      }
    } catch (error) {
      ToastPopUp().toastPopUp(error.toString(), Colors.amber);
    }
  }
}
