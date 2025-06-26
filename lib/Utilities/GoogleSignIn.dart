import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/UI/Auth/AddInfoScreen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore fStore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google Sign-In canceled.")),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        //check if user is new
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          //store userinfo in firestore
          await fStore.collection('UserDetails').doc(user.uid).set({
            'userId': user.uid,
            'fullName': user.displayName,
            'email': user.email,
            'photoURL': user.photoURL,
            'gender': null,
            'age': null,
            'createdAt': FieldValue.serverTimestamp(),
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AdditionalInfoScreen(user: user)),
          );
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-In failed: $e")),
      );
    }
  }
}
