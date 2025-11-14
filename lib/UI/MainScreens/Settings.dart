import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/Pass_Dialog.dart';
import 'package:famzy_tourz_app/Utilities/auth_services.dart';
import 'package:famzy_tourz_app/Utilities/prof_image.dart';
import 'package:famzy_tourz_app/contstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _ProfileState();
}

class _ProfileState extends State<Settings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final String currentUserId = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        iconTheme: IconThemeData(color: AppConstants.whiteColorP5),
        title: Text(
          'Settings',
          style: AppConstants.appBarTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top container for profile info
            Container(
              width: 1.sw,
              height: 0.3.sh,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppConstants.secondaryColor,
                    AppConstants.primaryColor
                  ],
                ),
              ),
              child: SizedBox(
                height: 50.h,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('UserDetails')
                      .doc(currentUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.yellow,
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
                          maxRadius: 50.r,
                          backgroundColor: Colors.grey.shade200,
                          child: profileImage(
                            profilePic: profilePic,
                            size: 100.r,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          fullName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
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
              height: 0.6.sh,
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
                      onPressed: () => AuthServices.signOut(context)),
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
