import 'package:famzy_tourz_app/Utilities/prof_image.dart';
import 'package:famzy_tourz_app/contstants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _postComment() async {
    final user = _auth.currentUser;
    if (user == null || _commentController.text.trim().isEmpty) return;

    final comment = {
      'userId': user.uid,
      'text': _commentController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Batch write for atomic updates
    final batch = _firestore.batch();

    // Add comment
    final commentRef = _firestore
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc();
    batch.set(commentRef, comment);

    // Update comment count
    final postRef = _firestore.collection('posts').doc(widget.postId);
    batch.update(postRef, {'commentsCount': FieldValue.increment(1)});

    await batch.commit();

    _commentController.clear();
    _scrollController.jumpTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments",
            textAlign: TextAlign.center, style: AppConstants.appBarTextStyle),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_circle_left_outlined,
              size: 35.h, color: Colors.white),
        ),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/images/bg-chats.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('posts')
                    .doc(widget.postId)
                    .collection('comments')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SpinKitFadingCircle(
                            color: Colors.yellow, size: 70.h));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No comments yet\nBe the first to comment!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    //reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final comment = snapshot.data!.docs[index];
                      return FutureBuilder<DocumentSnapshot>(
                        future: _firestore
                            .collection('UserDetails')
                            .doc(comment['userId'])
                            .get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) {
                            return SizedBox.shrink();
                          }

                          final user = userSnapshot.data!;
                          return _CommentTile(
                            userName: user['fullName'],
                            userImage: user['photoURL'],
                            commentText: comment['text'],
                            timestamp: comment['timestamp']?.toDate(),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            _CommentInputField(
              controller: _commentController,
              onPressed: _postComment,
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final String userName;
  final String? userImage;
  final String commentText;
  final DateTime? timestamp;

  const _CommentTile({
    required this.userName,
    required this.userImage,
    required this.commentText,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.r,
            child: profileImage(profilePic: userImage!, size: 50.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$userName\t\t\t\t\t\t',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.black38,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (timestamp != null)
                      Text(
                        DateFormat('MMM d, h:mm a').format(timestamp!),
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 12.sp,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  commentText,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressed;

  const _CommentInputField({
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
              child: Theme(
            data: AppConstants.customSelectionTheme,
            child: TextField(
              controller: controller,
              style: TextStyle(color: AppConstants.secondaryColor),
              decoration: const InputDecoration(
                hintText: 'Enter message',
                hintStyle: TextStyle(color: AppConstants.transGColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(color: AppConstants.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppConstants.primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              // Correctly sets the cursor ("pointer") color
              cursorColor: AppConstants.secondaryColor,
              maxLines: 3,
              minLines: 1,
            ),
          )),
          SizedBox(width: 8.w),
          IconButton(
            icon: Icon(
              Icons.send,
              color: AppConstants.primaryColor,
              size: 35.r,
            ),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
