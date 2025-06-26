import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

void showDeleteAccountDialog(BuildContext context) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  // Check if the user signed in with Google or Email
  List<UserInfo> providerData = user!.providerData;
  bool isGoogleUser =
      providerData.any((info) => info.providerId == "google.com");

  if (isGoogleUser) {
    // If Google user, delete without asking for a password
    deleteUserAccount(context, isGoogleUser: true);
  } else {
    // If Email/Password user, ask for password before deleting
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(150, 0, 30, 0),
          title: Text(
            "Enter Password",
          ),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter your password",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white)),
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text("Cancel", style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white)),
              onPressed: () async {
                String password = passwordController.text.trim();
                if (password.isNotEmpty) {
                  // Navigator.pop(context); // Close dialog before proceeding
                  await deleteUserAccount(context, password: password);
                }
              },
              child: Text(
                "Delete Account",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

Future<void> deleteUserAccount(BuildContext context,
    {String? password, bool isGoogleUser = false}) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;

    // Step 1: Re-authenticate user
    if (isGoogleUser) {
      // Re-authenticate Google user
      final GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw "Google sign-in failed. Try again.";

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await user.reauthenticateWithCredential(credential);
      print("Google re-authentication successful!");
    } else {
      // Re-authenticate Email/Password user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password!,
      );
      await user.reauthenticateWithCredential(credential);
      print("Email/Password re-authentication successful!");
    }

    // Step 2: Delete Firestore document first (to avoid permission issues)
    await FirebaseFirestore.instance
        .collection('UserDetails')
        .doc(uid)
        .delete();
    print("Firestore document deleted successfully!");

    // Step 3: Delete Firebase user account
    await user.delete();
    print("User deleted from Firebase Auth!");

    // Step 4: Navigate to WelcomeScreen after successful deletion

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
    print('step 4 completed');
  } catch (e) {
    print('Error deleting user: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to delete account: $e")),
    );
  }
}
