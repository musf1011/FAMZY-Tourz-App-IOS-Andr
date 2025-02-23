import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    final String? currentUserId = auth.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('userId',
                isNotEqualTo: currentUserId) // Exclude current user
            .orderBy('timestamp', descending: true) // Order by timestamp
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color.fromARGB(255, 0, 57, 2),
            ));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // List of posts
          final posts = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final imageUrl = post['imageURL'];
              final description = post['description'];
              final userId =
                  post['userId']; // Assuming userId is stored with the post

              // Fetch user's name from Firestore
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasError || !userSnapshot.hasData) {
                    return const SizedBox.shrink(); // Handle error case
                  }

                  final user = userSnapshot.data!;
                  final userName =
                      user['name']; // Assuming user's name is stored

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Info
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person), // You can customize this
                          ),
                          title: Text(userName),
                          subtitle: Text(userId), // Optionally show user ID
                        ),
                        // Post Image
                        Container(
                          height: 200, // Set height for image
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Post Description
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(description),
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
    );
  }
}
