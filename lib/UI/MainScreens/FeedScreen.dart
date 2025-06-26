// import 'package:famzy_tourz_app/UI/MainScreens/Feed/comment_screen.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/chatting/conversation_screen.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/posting_screen.dart';
// import 'package:famzy_tourz_app/Utilities/prof_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:share/share.dart';

// class FeedScreen extends StatefulWidget {
//   const FeedScreen({super.key});

//   @override
//   State<FeedScreen> createState() => _FeedScreenState();
// }

// class _FeedScreenState extends State<FeedScreen> {
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   Widget _buildLikeButton(String postId, String? userId, int likes) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('posts')
//           .doc(postId)
//           .collection('likes')
//           .doc(userId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         final isLiked = snapshot.data?.exists ?? false;

//         return IconButton(
//           icon: Icon(
//             isLiked ? Icons.favorite : Icons.favorite_border,
//             color: isLiked ? Colors.red : Colors.black,
//           ),
//           onPressed: () => _toggleLike(postId, userId),
//         );
//       },
//     );
//   }

//   Widget _buildCommentButton(BuildContext context, String postId, int count) {
//     return TextButton.icon(
//       icon: Icon(Icons.comment_outlined),
//       label: Text('$count'),
//       onPressed: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CommentsScreen(postId: postId),
//         ),
//       ),
//     );
//   }

//   Widget _buildShareButton(String postId, String description, String imageUrl) {
//     return IconButton(
//       icon: Icon(Icons.share),
//       onPressed: () async {
//         await Share.share(
//           'Check out this post: $description\n$imageUrl',
//           subject: 'Shared from Famzy Tourz',
//         );
//       },
//     );
//   }

//   void _toggleLike(String postId, String? userId) async {
//     if (userId == null) return;

//     final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
//     final likeRef = postRef.collection('likes').doc(userId);

//     final batch = FirebaseFirestore.instance.batch();

//     if ((await likeRef.get()).exists) {
//       batch.delete(likeRef);
//       batch.update(postRef, {'likes': FieldValue.increment(-1)});
//     } else {
//       batch.set(likeRef, {'timestamp': FieldValue.serverTimestamp()});
//       batch.update(postRef, {'likes': FieldValue.increment(1)});
//     }

//     await batch.commit();
//   }

//   void _navigateToChat(
//       BuildContext context, String userId, String name, String photo) {
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUserId == null) return;

//     List<String> ids = [currentUserId, userId];
//     ids.sort();
//     String chatId = ids.join("_");

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SinglChatScreen(
//           receiverId: userId,
//           receiverName: name,
//           receiverPhoto: photo,
//           chatId: chatId,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context)

//     return Scaffold(
//         // backgroundColor: Colors.black,
//         appBar: AppBar(
//           automaticallyImplyLeading: false, // Add this line
//           title: Text(
//             "FAMZY Instants",
//             textAlign: TextAlign.center,
//             style: GoogleFonts.playfairDisplay(
//               fontWeight: FontWeight.bold,
//               fontSize: 25.sp,
//               color: Colors.white,
//             ),
//           ),
//           centerTitle: true,
//           backgroundColor: const Color.fromARGB(255, 0, 57, 2),
//           actions: [
//             IconButton(
//               icon: Icon(
//                 Icons.add_circle_outline_sharp,
//                 color: Colors.yellow,
//                 size: 30.r,
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PostingScreen(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('posts')
//               .orderBy('timestamp', descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                   child: SpinKitFadingCircle(color: Colors.yellow, size: 70));
//             }

//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }

//             final posts = snapshot.data?.docs ?? [];
//             final currentUserId = FirebaseAuth.instance.currentUser?.uid;

//             return ListView.builder(
//               itemCount: posts.length,
//               itemBuilder: (context, index) {
//                 final post = posts[index];
//                 final postId = post.id;
//                 final imageUrl = post['imageURL'];
//                 final description = post['description'];
//                 final userId = post['userId'];
//                 final likes = post['likes'] ?? 0;
//                 final commentsCount = post['commentsCount'] ?? 0;

//                 return FutureBuilder<DocumentSnapshot>(
//                   future: FirebaseFirestore.instance
//                       .collection('UserDetails')
//                       .doc(userId)
//                       .get(),
//                   builder: (context, userSnapshot) {
//                     if (!userSnapshot.hasData) return const SizedBox.shrink();

//                     final user = userSnapshot.data!;
//                     final userName = user['fullName'];
//                     final userPhoto = user['photoURL'];

//                     return Card(
//                       color: Colors.white,
//                       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // User Header
//                           ListTile(
//                             leading: GestureDetector(
//                               onTap: () => {
//                                 _navigateToChat(
//                                     context, userId, userName, userPhoto)
//                               },
//                               child: CircleAvatar(
//                                 backgroundColor:
//                                     Color.fromARGB(255, 245, 255, 245),
//                                 child: profileImage(
//                                   profilePic: userPhoto,
//                                   size: 50.r,
//                                 ),
//                               ),
//                             ),
//                             title: Text(userName),
//                           ),

//                           // Post Image with Overlay
//                           Container(
//                             height: 0.6.sh,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: NetworkImage(imageUrl),
//                                 fit: BoxFit.cover,
//                                 colorFilter: ColorFilter.mode(
//                                     Colors.black.withOpacity(0.1),
//                                     BlendMode.darken),
//                               ),
//                             ),
//                             child: Stack(
//                               children: [
//                                 Positioned.fill(
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         begin: Alignment.bottomCenter,
//                                         end: Alignment.topCenter,
//                                         colors: [
//                                           Colors.black.withOpacity(0.7),
//                                           Colors.transparent,
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 16,
//                                   left: 16,
//                                   child: Text(
//                                     description,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18.sp,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           // Engagement Buttons
//                           Padding(
//                             padding: EdgeInsets.all(8),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 _buildLikeButton(postId, currentUserId, likes),
//                                 _buildCommentButton(
//                                     context, postId, commentsCount),
//                                 _buildShareButton(
//                                     postId, description, imageUrl),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         ));
//   }
// }

import 'package:famzy_tourz_app/UI/MainScreens/Feed/comment_screen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/Feed/posting_screen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/chatting/conversation_screen.dart';
import 'package:famzy_tourz_app/Utilities/prof_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget _buildLikeButton(String postId, String userId) {
    final likeRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId);

    return StreamBuilder<DocumentSnapshot>(
      stream: likeRef.snapshots(),
      builder: (context, snapshot) {
        final isLiked = snapshot.data?.exists ?? false;

        return IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.grey,
          ),
          onPressed: () => _toggleLike(postId, userId),
        );
      },
    );
  }

  Widget _buildCommentButton(BuildContext context, String postId, int count) {
    return TextButton.icon(
      icon: Icon(Icons.comment_outlined),
      label: Text('$count'),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommentsScreen(postId: postId),
        ),
      ),
    );
  }

  Widget _buildShareButton(String description, String imageUrl) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () async {
        // ignore: deprecated_member_use
        await Share.share(
          'Check out this post: $description\n$imageUrl',
          subject: 'Shared from Famzy Tourz',
        );
      },
    );
  }

  void _toggleLike(String postId, String userId) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    final likeRef = postRef.collection('likes').doc(userId);

    final likeDoc = await likeRef.get();

    if (likeDoc.exists) {
      // Unlike the post
      await likeRef.delete();
      await postRef.update({'likesCount': FieldValue.increment(-1)});
    } else {
      // Like the post
      await likeRef.set({'likedAt': FieldValue.serverTimestamp()});
      await postRef.update({'likesCount': FieldValue.increment(1)});
    }
  }

  void _navigateToChat(
      BuildContext context, String userId, String name, String photo) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    List<String> ids = [currentUserId, userId];
    ids.sort();
    String chatId = ids.join("_");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SinglChatScreen(
          receiverId: userId,
          receiverName: name,
          receiverPhoto: photo,
          chatId: chatId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "FAMZY Instants",
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 25.sp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 57, 2),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline_sharp,
              color: Colors.yellow,
              size: 35.r,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostingScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/images/bg-chats.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitFadingCircle(color: Colors.yellow, size: 70),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final posts = snapshot.data?.docs ?? [];
            final currentUserId = FirebaseAuth.instance.currentUser?.uid;

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final postId = post.id;
                final imageUrl = post['imageURL'];
                final description = post['description'];
                final userId = post['userId'];
                final commentsCount = post['commentsCount'] ?? 0;

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('UserDetails')
                      .doc(userId)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) return const SizedBox.shrink();

                    final user = userSnapshot.data!;
                    final userName = user['fullName'];
                    final userPhoto = user['photoURL'];

                    return Card(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => _navigateToChat(
                                context, userId, userName, userPhoto),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 245, 255, 245),
                                child: profileImage(
                                  profilePic: userPhoto,
                                  size: 50.r,
                                ),
                              ),
                              title: Text(userName),
                            ),
                          ),
                          Container(
                            height: 0.6.sh,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.1),
                                    BlendMode.darken),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    _buildLikeButton(postId, currentUserId!),
                                    SizedBox(width: 4),
                                    Text(
                                      '${post['likesCount'] ?? 0} likes',
                                      style: TextStyle(
                                          fontSize: 14.sp, color: Colors.black),
                                    ),
                                  ],
                                ),
                                _buildCommentButton(
                                    context, postId, commentsCount),
                                _buildShareButton(description, imageUrl),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
