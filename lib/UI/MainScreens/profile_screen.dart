import 'package:famzy_tourz_app/Utilities/my_drawer.dart';
import 'package:famzy_tourz_app/contstants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:famzy_tourz_app/Utilities/prof_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: AppConstants.primaryColor,
        iconTheme: IconThemeData(
          color: AppConstants.tertiaryColor,
        ),
      ),
      body: Column(
        children: [
          // — User Info Header —
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('UserDetails')
                .doc(currentUser.uid)
                .get(),
            builder: (ctx, snap) {
              if (!snap.hasData) {
                return Padding(
                  padding: EdgeInsets.all(20.h),
                  child: SpinKitFadingCircle(color: Colors.yellow, size: 50),
                );
              }
              final user = snap.data!;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40.r,
                      backgroundColor: Colors.grey[200],
                      foregroundImage: NetworkImage(user['photoURL'] ?? ''),
                      child: profileImage(
                          profilePic: user['photoURL'] ?? '', size: 80.r),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(" ${user['fullName']}" ?? 'No Name',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: AppConstants.secondaryColor,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 4.h),
                          Text(currentUser.email ?? '',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppConstants.tertiaryColor)),
                        ]),
                  ],
                ),
              );
            },
          ),

          Divider(color: Colors.white30, height: 1),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  // .where('userId', isEqualTo: currentUser.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          SpinKitFadingCircle(color: Colors.yellow, size: 50));
                }
                final docs = snap.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(
                      child: Text('No posts yet',
                          style: TextStyle(color: AppConstants.primaryColor)));
                }
                return GridView.builder(
                  padding: EdgeInsets.all(8.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.w,
                    mainAxisSpacing: 4.w,
                    childAspectRatio: 1,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final p = docs[i];
                    final likes = p['likesCount'] ?? 0;
                    final imgUrl = p['imageURL'];
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(imgUrl, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.favorite,
                                    size: 14.sp, color: Colors.redAccent),
                                SizedBox(width: 2.w),
                                Text('$likes',
                                    style: TextStyle(
                                        fontSize: 12.sp, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
