// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';

// // class SettingsScreen extends StatelessWidget {
// //   const SettingsScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Settings'),
// //         centerTitle: true,
// //         backgroundColor: Colors.green.shade700,
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0.w),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             // Circular Avatar for Profile Picture
// //             Center(
// //               child: Stack(
// //                 children: [
// //                   CircleAvatar(
// //                     radius: 60.r,
// //                     backgroundImage: NetworkImage(
// //                       'https://via.placeholder.com/150', // Replace with Firebase URL
// //                     ),
// //                   ),
// //                   Positioned(
// //                     bottom: 0,
// //                     right: 0,
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         color: Colors.green,
// //                         shape: BoxShape.circle,
// //                       ),
// //                       child: IconButton(
// //                         icon: const Icon(Icons.edit,
// //                             color: Colors.white, size: 20),
// //                         onPressed: () {
// //                           // Add functionality to update profile picture
// //                         },
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             SizedBox(height: 20.h),

// //             // User Name and Email
// //             Text(
// //               'John Doe', // Replace with user name
// //               style: TextStyle(
// //                 fontSize: 22.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             SizedBox(height: 8.h),
// //             Text(
// //               'john.doe@example.com', // Replace with user email
// //               style: TextStyle(
// //                 fontSize: 16.sp,
// //                 color: Colors.grey.shade700,
// //               ),
// //             ),
// //             SizedBox(height: 30.h),

// //             // Divider
// //             Divider(thickness: 1.h),

// //             // Settings Options
// //             ListTile(
// //               leading: const Icon(Icons.lock, color: Colors.green),
// //               title: const Text('Change Password'),
// //               onTap: () {
// //                 // Add functionality to change password
// //               },
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.share, color: Colors.green),
// //               title: const Text('Share App'),
// //               onTap: () {
// //                 // Add functionality to share app
// //               },
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.info, color: Colors.green),
// //               title: const Text('About Us'),
// //               onTap: () {
// //                 // Add functionality to display "About Us" info
// //               },
// //             ),
// //             SizedBox(height: 20.h),

// //             // Sign Out Button
// //             ElevatedButton.icon(
// //               onPressed: () {

// //               },
// //               icon: const Icon(Icons.logout),
// //               label: const Text('Sign Out'),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: const Color.fromARGB(
// //                     255, 81, 16, 12), // Button background color
// //                 minimumSize: Size(150.w, 50.h),
// //               ),
// //             ),
// //             SizedBox(height: 20.h),

// //             // Delete Account Button
// //             ElevatedButton.icon(
// //               onPressed: () {
// //                 // Add functionality to delete account
// //               },
// //               icon: const Icon(Icons.delete),
// //               label: const Text('Delete Account'),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.black, // Button background color
// //                 minimumSize: Size(150.w, 50.h),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:famzy_tourz_app/Utilities/prof_info.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class Profile extends StatefulWidget {
//   Profile({super.key});

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     final String currentUserId = _auth.currentUser!.uid;

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Top container for profile info
//             Container(
//               width: 1.sw,
//               height: 0.39.sh, // Fixed height
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.green, Colors.black],
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   // Profile info section
//                   ProfInfo(),
//                 ],
//               ),
//             ),
//             // Bottom container for account details
//             Container(
//               width: 1.sw,
//               height: 0.6.sh, // Fixed height
//               color: Colors.black,
//               child: StreamBuilder<DocumentSnapshot>(
//                 stream: _firestore
//                     .collection('UserDetails')
//                     .doc(currentUserId)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }

//                   if (!snapshot.hasData || !snapshot.data!.exists) {
//                     return Center(
//                       child: Text(
//                         'No account details found',
//                         style: TextStyle(color: Colors.white, fontSize: 16.sp),
//                       ),
//                     );
//                   }

//                   // Retrieve the data
//                   final data = snapshot.data!.data() as Map<String, dynamic>;
//                   final String createdTime = data['time'] ?? 'Unknown';
//                   final String password = data['password'] ?? 'Not set';

//                   return Column(
//                     children: [
//                       SizedBox(height: 0.1.sh),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'This account was created on: ',
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 16.sp),
//                           ),
//                           Text(
//                             createdTime,
//                             style:
//                                 TextStyle(color: Colors.amber, fontSize: 16.sp),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 0.05.sh),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Your password: ',
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 16.sp),
//                           ),
//                           Text(
//                             password,
//                             style:
//                                 TextStyle(color: Colors.amber, fontSize: 16.sp),
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/UI/Auth/WelcomeScreen.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
                  colors: [Colors.green, Colors.black],
                ),
              ),
              child: Column(
                children: [
                  // Back button
                  // Padding(
                  //   padding:
                  //       EdgeInsets.fromLTRB(0.02.sw, 0.02.sh, 0.9.sw, 0.02.sh),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Navigator.pop(context);
                  //     },
                  //     child: Icon(
                  //       Icons.arrow_back,
                  //       size: 30.sp,
                  //     ),
                  //   ),
                  // ),
                  // Profile Info
                  SizedBox(height: 30.h),
                  CircleAvatar(
                    maxRadius: 60.r, // Dynamic radius
                    child: Icon(
                      Icons.person_4,
                      size: 80.sp, // Dynamic icon size
                    ),
                  ),

                  SizedBox(
                    height: 100.h, // Dynamic height for the container
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: _firestore
                          .collection('UserDetails')
                          .doc(currentUserId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;
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
                ],
              ),
            ),
            // Bottom container for account details
            Container(
              width: 1.sw,
              height: 0.6.sh, // Fixed height
              color: Colors.black,
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
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    );
                  }

                  // Retrieve the data
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final String createdTime = data['time'] ?? 'Unknown';
                  final String password = data['password'] ?? 'Not set';

                  return Column(
                    children: [
                      SizedBox(height: 0.1.sh),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'This account was created on: ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.sp),
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
                                TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                          Text(
                            password,
                            style:
                                TextStyle(color: Colors.amber, fontSize: 16.sp),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 190.h,
                      ),
                      SizedBox(
                        height: 40.h,
                        width: .5.sw,
                        child: CustomElevatedButton(
                          child: Icon(Icons.logout),
                          onPressed: () {
                            _auth.signOut().then((value) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomeScreen()));
                            }).onError((Error, value) {
                              ToastPopUp()
                                  .toastPopUp(Error.toString(), Colors.amber);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                        width: .5.sw,
                        child: CustomElevatedButton(
                          child: Icon(Icons.no_accounts_outlined),
                          onPressed: () {
                            _auth.currentUser!.delete().then((value) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomeScreen()));
                            });
                          },
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
