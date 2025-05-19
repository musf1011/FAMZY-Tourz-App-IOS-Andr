import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/Pass_Dialog.dart';
import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
import 'package:famzy_tourz_app/Utilities/prof_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final String currentUserId = _auth.currentUser!.uid;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top container for profile info
            Container(
              width: 1.sw,
              height: 0.36.sh, // Fixed height
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(150, 0, 30, 0),
                    Color.fromARGB(255, 0, 57, 2)
                  ],
                ),
              ),
              child: SizedBox(
                height: 100.h, // Dynamic height for the container
                child: StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('UserDetails')
                      .doc(currentUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: const Color.fromARGB(255, 0, 57, 2),
                      ));
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(
                        child: Text(
                          'No data found',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp, // Dynamic font size
                          ),
                        ),
                      );
                    }

                    // Retrieve the data
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final String profilePic = data['photoURL'];
                    final String fullName = data['fullName'] ?? 'No name';
                    final String email = data['email'] ?? 'No email';
                    // final Timestamp? timestamp = data['createdAt'];
                    // final DateTime dateTime = timestamp!.toDate();
                    final DateTime dateTime = data['createdAt'].toDate();
                    final String createdTime =
                        DateFormat('MMM yyyy').format(dateTime);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        CircleAvatar(
                          maxRadius: 50.r, // Dynamic radius
                          backgroundColor: Colors.grey
                              .shade200, // Optional: Background color for better visuals
                          child: profileImage(
                            profilePic: profilePic,
                            size: 100.r, // Dynamic size
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          fullName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp, // Dynamic font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp, // Dynamic font size
                          ),
                        ),
                        Text('since $createdTime')
                      ],
                    );
                  },
                ),
              ),
            ),
            // Bottom container for account details
            SizedBox(
              width: 1.sw,
              height: 0.6.sh, // Fixed height
              // color: Colors.black,
              child: StreamBuilder<DocumentSnapshot>(
                stream: _firestore
                    .collection('UserDetails')
                    .doc(currentUserId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(
                      child: Text(
                        'No account details found',
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                    );
                  }

                  // Retrieve the data
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final String createdTime = data['time'] ?? 'Unknown';
                  final String password = data['password'] ?? 'Not set';

                  return Column(children: [
                    SizedBox(height: 0.1.sh),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'This account was created on: ',
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp),
                        ),
                        Text(
                          createdTime,
                          style:
                              TextStyle(color: Colors.amber, fontSize: 16.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.05.sh),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Your password: ',
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp),
                        ),
                        Text(
                          password,
                          style:
                              TextStyle(color: Colors.amber, fontSize: 16.sp),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                  ]);
                },
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 40.h,
                  width: .5.sw,
                  child: CustomElevatedButton(
                    child: Icon(Icons.logout),
                    onPressed: () async {
                      try {
                        // Sign out from Firebase (safe for all auth types)
                        await FirebaseAuth.instance.signOut();

                        // Try Google sign-out only if session exists
                        final googleSignIn = GoogleSignIn();
                        final isSignedIn = await googleSignIn.isSignedIn();
                        if (isSignedIn) {
                          try {
                            await googleSignIn.signOut();
                            await googleSignIn.disconnect();
                          } catch (e) {
                            debugPrint(
                                "Google SignOut Error: $e"); // log but don't stop flow
                          }
                        }

                        //log out status saved in local database
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', false);
                        await prefs.setBool('isEmailVerified', false);

                        // ✅ Always navigate after Firebase logout
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()),
                        );
                      } catch (error) {
                        ToastPopUp().toastPopUp(error.toString(), Colors.amber);
                      }
                    },
                  ),

                  // CustomElevatedButton(
                  //   child: Icon(Icons.logout),
                  //   onPressed: () {
                  //     _auth.signOut().then((value) {
                  //       Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => WelcomeScreen()));
                  //     }).onError((Error, value) {
                  //       ToastPopUp().toastPopUp(Error.toString(), Colors.amber);
                  //     });
                  //   },
                  // ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  height: 40.h,
                  width: .5.sw,
                  child: CustomElevatedButton(
                    child: Icon(Icons.no_accounts_outlined),
                    onPressed: () {
                      showDeleteAccountDialog(context);
                    },

                    // onPressed: () {
                    //   _auth.currentUser!.delete().then((value) {
                    //     Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => WelcomeScreen()));
                    //   });
                    // },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
