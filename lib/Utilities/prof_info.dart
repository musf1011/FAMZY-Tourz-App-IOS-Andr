import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfInfo extends StatefulWidget {
  const ProfInfo({super.key});

  @override
  State<ProfInfo> createState() => _ProfInfoState();
}

class _ProfInfoState extends State<ProfInfo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Get the current user's UID
    final String currentUserId = _auth.currentUser!.uid;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          SizedBox(height: 20.h), // Dynamic height using ScreenUtil
          CircleAvatar(
            maxRadius: 60.r, // Dynamic radius
            child: Icon(
              Icons.person_4,
              size: 80.sp, // Dynamic icon size
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 100.h, // Dynamic height for the container
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
                final String fullName = data['fullName'] ?? 'No name';
                final String email = data['email'] ?? 'No email';

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
