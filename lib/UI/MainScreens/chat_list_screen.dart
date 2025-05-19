// Created by: Famzy Tourz

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/UI/MainScreens/chatting/conversation_screen.dart';
import 'package:famzy_tourz_app/Utilities/prof_image.dart';
import 'package:famzy_tourz_app/Utilities/time_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Unfocus the keyboard
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          automaticallyImplyLeading: false, // Add this line
          title: Text(
            "\tInteracts",
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              fontSize: 28.sp,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 57, 2),
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
              // Search bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: const Color.fromARGB(255, 0, 57, 2),
                  style: TextStyle(color: Colors.black),
                  controller: searchController,
                  decoration: InputDecoration(
                    hoverColor: const Color.fromARGB(255, 0, 57, 2),
                    labelText: "Search by Name",
                    labelStyle:
                        TextStyle(color: const Color.fromARGB(255, 0, 57, 2)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: const Color.fromARGB(255, 0, 57, 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 0, 57, 2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 0, 57, 2)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.trim();
                    });
                  },
                ),
              ),

              // Chat List or Search Results
              Expanded(
                child: searchQuery == ""
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chat')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: SpinKitFadingCircle(
                                  color: Colors.yellow, size: 70),
                            );
                          }

                          try {
                            // Process Firestore documents with type safety
                            // final chatlist = snapshot.data!.docs
                            //     .map((doc) {
                            //       final data =
                            //           doc.data() as Map<String, dynamic>;
                            //       return {
                            //         'chatId': data['chatId'] as String? ?? '',
                            //         'receiverId':
                            //             data['receiverId'] as String? ?? '',
                            //         'receiverName':
                            //             data['receiverName'] as String? ??
                            //                 'Unknown',
                            //         'receiverPhoto':
                            //             data['receiverPhoto'] as String? ?? '',
                            //         'time': data['time'] as int? ?? 0,
                            //         'message': data['message'] as String? ??
                            //             'No messages',
                            //         // 'isAI': false,
                            //         'isAI': data['receiverId'] ==
                            //             'gemini-ai-id', // 🔹 Identify AI chat
                            //       };
                            //     })
                            //     .where((chat) => (chat['chatId'] as String)
                            //         .contains(currentUserId))
                            //     .toList();

                            final chatlist = snapshot.data!.docs
                                .map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  final isSender =
                                      data['senderId'] == currentUserId;

                                  return {
                                    'chatId': data['chatId'] as String? ?? '',
                                    'receiverId': isSender
                                        ? data['receiverId'] as String? ?? ''
                                        : data['senderId'] as String? ?? '',
                                    'receiverName': isSender
                                        ? data['receiverName'] as String? ??
                                            'Unknown'
                                        : data['senderName'] as String? ??
                                            'Unknown',
                                    'receiverPhoto': isSender
                                        ? data['receiverPhoto'] as String? ?? ''
                                        : data['senderPhoto'] as String? ?? '',
                                    'time': data['time'] as int? ?? 0,
                                    'message': data['message'] as String? ??
                                        'No messages',
                                    'isAI':
                                        data['receiverId'] == 'gemini-ai-id',
                                  };
                                })
                                .where((chat) => (chat['chatId'] as String)
                                    .contains(currentUserId))
                                .toList();

                            // Add AI chat entry with proper typing
                            final aiChatDoc = {
                              'chatId': 'ai-chat-$currentUserId',
                              'receiverId': 'gemini-ai-id',
                              'receiverName': 'FAMZY AI',
                              'receiverPhoto':
                                  'https://assets.lummi.ai/assets/QmTiN4tEYqeq9rGB6G2BtczQqusMgwyXsWyZUK2C8atjDf?auto=format&w=640',
                              'time': 0,
                              'message': 'Ask me anything about tours!',
                              'isAI': true,
                            };
                            // Sort actual chat list (excluding AI), then reinsert AI chat at the top
                            chatlist.sort((a, b) =>
                                (b['time'] as int).compareTo(a['time'] as int));
                            chatlist
                                .removeWhere((chat) => chat['isAI'] == true);
                            final allChats = [aiChatDoc, ...chatlist];
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: allChats.length,
                              itemBuilder: (context, index) {
                                final chat = allChats[index];
                                final isAI = chat['isAI'] as bool;
                                final chatId = chat['chatId'] as String;

                                return FutureBuilder<int>(
                                  future: isAI
                                      ? Future.value(0)
                                      : _getUnseenMessageCount(chatId),
                                  builder: (context, snapshot) {
                                    final unseenCount = snapshot.data ?? 0;

                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      color: Colors.white,
                                      child: ListTile(
                                        onTap: () async {
                                          if (isAI) {
                                            await FirebaseFirestore.instance
                                                .collection('chat')
                                                .doc(chatId)
                                                .set(chat,
                                                    SetOptions(merge: true));
                                          }
                                          await _markMessagesAsSeen(chatId);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SinglChatScreen(
                                                receiverId: chat['receiverId']
                                                    as String,
                                                receiverName:
                                                    chat['receiverName']
                                                        as String,
                                                receiverPhoto:
                                                    chat['receiverPhoto']
                                                        as String,
                                                chatId: chatId,
                                              ),
                                            ),
                                          );
                                        },
                                        leading: CircleAvatar(
                                          backgroundColor: Color.fromARGB(
                                              255, 245, 255, 245),
                                          child: profileImage(
                                            profilePic:
                                                chat['receiverPhoto'] as String,
                                            size: 50.r,
                                          ),
                                        ),
                                        title: Text(
                                          chat['receiverName'] as String,
                                          style: TextStyle(fontSize: 18.sp),
                                        ),
                                        subtitle: Text(
                                          (chat['message'] as String).length >
                                                  20
                                              ? '${(chat['message'] as String).substring(0, 20)}...'
                                              : chat['message'] as String,
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (unseenCount > 0 && !isAI)
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 6.w,
                                                  vertical: 3.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Text(
                                                  unseenCount.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                              ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              getFormattedTime(
                                                chat['time'] as int,
                                                format: 'hh:mm a',
                                              ),
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } catch (e) {
                            return Center(
                              child: Text(
                                'Failed to load chats',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('UserDetails')
                            .where('fullName',
                                isGreaterThanOrEqualTo: searchQuery)
                            .where('fullName', isLessThan: '${searchQuery}z')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: SpinKitFadingCircle(
                                  color: Colors.yellow, size: 70),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(child: Text("No users found"));
                          }

                          return ListView(
                            children: snapshot.data!.docs.map((doc) {
                              Map<String, dynamic> userData =
                                  doc.data() as Map<String, dynamic>;

                              return ListTile(
                                leading: CircleAvatar(
                                  child: profileImage(
                                    profilePic: userData['photoURL'],
                                    size: 50.r,
                                  ),
                                ),
                                title: Text(userData['fullName'] ?? "Unknown"),
                                trailing: TextButton(
                                  onPressed: () {
                                    List<String> ids = [
                                      currentUserId,
                                      userData['userId']
                                    ];
                                    ids.sort();
                                    String chatId = ids.join("_");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SinglChatScreen(
                                          chatId: chatId,
                                          receiverId: userData['userId'],
                                          receiverName: userData['fullName'],
                                          receiverPhoto: userData['photoURL'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text("Message"),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> _getUnseenMessageCount(String chatId) async {
    try {
      // Fetch unread messages
      final snapshot = await FirebaseFirestore.instance
          .collection('chat')
          .doc(chatId)
          .collection('conversation')
          .where('seen', isEqualTo: false)
          .where('senderId', isNotEqualTo: currentUserId)
          .get();

      // Return the count of unread messages
      return snapshot.docs.length;
    } catch (e) {
      print('Error fetching unread messages: $e');
      return 0; // Return 0 in case of an error
    }
  }

  Future<void> _markMessagesAsSeen(String chatId) async {
    try {
      // Fetch unread messages
      final snapshot = await FirebaseFirestore.instance
          .collection('chat')
          .doc(chatId)
          .collection('conversation')
          .where('seen', isEqualTo: false)
          .where('senderId', isNotEqualTo: currentUserId)
          .get();

      // Update each message as seen
      for (var doc in snapshot.docs) {
        await doc.reference.update({'seen': true});
      }
    } catch (e) {
      print('Error marking messages as seen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark messages as seen: $e')),
      );
    }
  }
}
