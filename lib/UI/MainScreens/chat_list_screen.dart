// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/chatting/conversation_screen.dart';
// import 'package:famzy_tourz_app/Utilities/prof_image.dart';
// import 'package:famzy_tourz_app/Utilities/time_formatter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ChatListScreen extends StatefulWidget {
//   const ChatListScreen({super.key});

//   @override
//   State<ChatListScreen> createState() => _ChatListScreenState();
// }

// class _ChatListScreenState extends State<ChatListScreen> {
//   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//   TextEditingController searchController = TextEditingController();
//   String searchQuery = "";

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus(); //to unfocus the keyboard
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "\tInteracts",
//             textAlign: TextAlign.center,
//             style: GoogleFonts.playfairDisplay(
//               fontWeight: FontWeight.bold,
//               fontSize: 28.sp,
//               color: Colors.white,
//             ),
//           ),
//           backgroundColor: const Color.fromARGB(255, 0, 57, 2),
//         ),
//         body: Column(
//           children: [
//             // Search bar starts here
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 style: TextStyle(
//                   color: Colors.black,
//                 ),
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hoverColor: const Color.fromARGB(255, 0, 57, 2),
//                   labelText: "Search by Name",
//                   labelStyle: TextStyle(
//                     color: const Color.fromARGB(255, 0, 57, 2),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: const Color.fromARGB(255, 0, 57, 2),
//                   ),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25),
//                       borderSide: BorderSide(
//                           color: const Color.fromARGB(255, 0, 57, 2))),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15),
//                     borderSide: BorderSide(
//                       color: const Color.fromARGB(255, 0, 57, 2),
//                     ),
//                   ),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     searchQuery = value.trim();
//                   });
//                 },
//               ),
//             ), // Search bar ends here

//             searchQuery == ""
//                 ? Expanded(
//                     child: StreamBuilder(
//                         stream: FirebaseFirestore.instance
//                             .collection('chat')
//                             .snapshots(),
//                         builder: (context, snapshot) {
//                           if (snapshot.hasData) {
//                             var chatlist = snapshot.data!.docs.where((element) {
//                               String chatId = element['chatId'];
//                               return chatId.contains(
//                                   FirebaseAuth.instance.currentUser!.uid);
//                             }).toList();
//                             return ListView.builder(
//                               itemCount: chatlist.length,
//                               itemBuilder: (context, index) {
//                                 return Padding(
//                                   padding:
//                                       EdgeInsets.symmetric(horizontal: 5.w),
//                                   child: Card(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(25)),
//                                     color: Colors.white,
//                                     child: ListTile(
//                                       // tileColor: Colors.grey[200],
//                                       onTap: () {
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (_) => SinglChatScreen(
//                                                       receiverId:
//                                                           chatlist[index]
//                                                               ['receiverId'],
//                                                       receiverName:
//                                                           chatlist[index]
//                                                               ['receiverName'],
//                                                       receiverPhoto:
//                                                           chatlist[index]
//                                                               ['receiverPhoto'],
//                                                       chatId: chatlist[index]
//                                                           ['chatId'],
//                                                     )));
//                                       },
//                                       leading: CircleAvatar(
//                                         child: profileImage(
//                                             profilePic: chatlist[index]
//                                                 ['receiverPhoto'],
//                                             size: 50.r),
//                                       ),
//                                       title: Text(
//                                         chatlist[index]['receiverName'],
//                                         style: TextStyle(
//                                           fontSize: 18.sp,
//                                         ),
//                                       ),
//                                       subtitle: Text(
//                                         chatlist[index]['message'].length > 20
//                                             ? chatlist[index]['message']
//                                                     .substring(0, 20) +
//                                                 '...'
//                                             : chatlist[index]['message'],
//                                         style: TextStyle(
//                                           color: Colors.black.withOpacity(.6),
//                                         ),
//                                       ),
//                                       trailing: Text(
//                                         getFormattedTime(
//                                             chatlist[index]['time'],
//                                             format: 'hh:mm a'),
//                                         style: TextStyle(
//                                           fontSize: 12.sp,
//                                           color: Colors.black.withOpacity(.6),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           } else {
//                             return Center(
//                               child: Text('No Interections yet',
//                                   style: TextStyle(
//                                     fontSize: 20.sp,
//                                     color: Colors.black,
//                                   )),
//                             );
//                           }
//                         }),
//                   )
//                 :
//                 //  Search Results
//                 Expanded(
//                     child: StreamBuilder<QuerySnapshot>(
//                       stream: (searchQuery.isEmpty)
//                           ? FirebaseFirestore.instance
//                               .collection('UserDetails')
//                               .snapshots()
//                           : FirebaseFirestore.instance
//                               .collection('UserDetails')
//                               // .where('userId', isNotEqualTo: currentUserId)
//                               .where('fullName',
//                                   isGreaterThanOrEqualTo: searchQuery)
//                               .where('fullName', isLessThan: '${searchQuery}z')
//                               .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         }
//                         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                           return Center(child: Text("No users found"));
//                         }

//                         //Build a list of rearch results
//                         return ListView(
//                           children: snapshot.data!.docs.map((doc) {
//                             Map<String, dynamic> userData =
//                                 doc.data() as Map<String, dynamic>;

//                             return ListTile(
//                               leading: CircleAvatar(
//                                 child: profileImage(
//                                     profilePic: userData['photoURL'],
//                                     size: 50.r),
//                               ),
//                               title: Text(userData['fullName'] ?? "Unknown"),
//                               trailing: TextButton(
//                                 onPressed: () {
//                                   //  Implementing messaging

//                                   List<String> ids = [
//                                     currentUserId,
//                                     userData['userId']
//                                   ];
//                                   ids.sort();
//                                   String chatId = ids.join("_");
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => SinglChatScreen(
//                                         chatId: chatId,
//                                         receiverId: userData['userId'],
//                                         receiverName: userData['fullName'],
//                                         receiverPhoto: userData['photoURL'],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Text("Message"),
//                               ),
//                             );
//                           }).toList(),
//                         );
//                       },
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/chatting/conversation_screen.dart';
// import 'package:famzy_tourz_app/Utilities/prof_image.dart';
// import 'package:famzy_tourz_app/Utilities/time_formatter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ChatListScreen extends StatefulWidget {
//   const ChatListScreen({super.key});

//   @override
//   State<ChatListScreen> createState() => _ChatListScreenState();
// }

// class _ChatListScreenState extends State<ChatListScreen> {
//   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
//   TextEditingController searchController = TextEditingController();
//   String searchQuery = "";

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus(); // Unfocus keyboard
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "\tInteracts",
//             textAlign: TextAlign.center,
//             style: GoogleFonts.playfairDisplay(
//               fontWeight: FontWeight.bold,
//               fontSize: 28.sp,
//               color: Colors.white,
//             ),
//           ),
//           backgroundColor: const Color.fromARGB(255, 0, 57, 2),
//         ),
//         body: Column(
//           children: [
//             // 🔹 Search Bar
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   labelText: "Search by Name",
//                   prefixIcon:
//                       Icon(Icons.search, color: Color.fromARGB(255, 0, 57, 2)),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25)),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     searchQuery = value.trim();
//                   });
//                 },
//               ),
//             ),

//             // 🔹 Chat List with Unread Messages
//             Expanded(
//               child: StreamBuilder(
//                 stream:
//                     FirebaseFirestore.instance.collection('chat').snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     var chatlist = snapshot.data!.docs.where((element) {
//                       String chatId = element['chatId'];
//                       return chatId.contains(currentUserId);
//                     }).toList();

//                     return ListView.builder(
//                       itemCount: chatlist.length,
//                       itemBuilder: (context, index) {
//                         var chatData =
//                             chatlist[index].data() as Map<String, dynamic>;
//                         String chatId = chatData['chatId'];
//                         String receiverId = chatData['users'].firstWhere(
//                             (id) => id != currentUserId); // Get receiver ID
//                         String receiverName =
//                             chatData['userNames'][receiverId] ?? "Unknown";
//                         String receiverPhoto =
//                             chatData['userPhotos'][receiverId] ?? "";
//                         String lastMessage = chatData['lastMessage'] ?? "";
//                         // Timestamp lastMessageTime = chatData['lastMessageTime'] ?? Timestamp.now();

//                         return StreamBuilder<QuerySnapshot>(
//                           stream: FirebaseFirestore.instance
//                               .collection('chat')
//                               .doc(chatId)
//                               .collection('messages')
//                               .where('isSeen', isEqualTo: false)
//                               .where('receiverId',
//                                   isEqualTo:
//                                       currentUserId) // Only check unseen messages for current user
//                               .snapshots(),
//                           builder: (context, msgSnapshot) {
//                             int unseenCount = msgSnapshot.hasData
//                                 ? msgSnapshot.data!.docs.length
//                                 : 0;

//                             return Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 5.w),
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(25)),
//                                 color: Colors.white,
//                                 child: ListTile(
//                                   onTap: () {
//                                     // 🔹 Mark Messages as Seen when opening chat
//                                     markMessagesAsSeen(chatId);

//                                     // 🔹 Navigate to Chat Screen
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => SinglChatScreen(
//                                           receiverId: receiverId,
//                                           receiverName: receiverName,
//                                           receiverPhoto: receiverPhoto,
//                                           chatId: chatId,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   leading: CircleAvatar(
//                                     child: profileImage(
//                                         profilePic: receiverPhoto, size: 50.r),
//                                   ),
//                                   title: Text(
//                                     receiverName,
//                                     style: TextStyle(fontSize: 18.sp),
//                                   ),
//                                   subtitle: Text(
//                                     lastMessage.length > 20
//                                         ? "${lastMessage.substring(0, 20)}..."
//                                         : lastMessage,
//                                     style: TextStyle(
//                                         color: Colors.black.withOpacity(.6)),
//                                   ),
//                                   trailing: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         getFormattedTime(chatData['time'],
//                                             format: 'hh:mm a'),
//                                         style: TextStyle(
//                                             fontSize: 12.sp,
//                                             color:
//                                                 Colors.black.withOpacity(.6)),
//                                       ),
//                                       if (unseenCount > 0)
//                                         Container(
//                                           padding: EdgeInsets.all(6),
//                                           decoration: BoxDecoration(
//                                             color: Colors.red,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: Text(
//                                             unseenCount.toString(),
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     );
//                   } else {
//                     return Center(
//                       child: Text('No Interactions yet',
//                           style:
//                               TextStyle(fontSize: 20.sp, color: Colors.black)),
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 🔹 Mark messages as seen when user opens a chat
//   void markMessagesAsSeen(String chatId) async {
//     var messages = await FirebaseFirestore.instance
//         .collection('chat')
//         .doc(chatId)
//         .collection('messages')
//         .where('isSeen', isEqualTo: false)
//         .where('receiverId', isEqualTo: currentUserId)
//         .get();

//     for (var doc in messages.docs) {
//       await doc.reference.update({'isSeen': true});
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/UI/MainScreens/chatting/conversation_screen.dart';
import 'package:famzy_tourz_app/Utilities/prof_image.dart';
import 'package:famzy_tourz_app/Utilities/time_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                    ?

                    // Add this to your search results list
                    // StreamBuilder<QuerySnapshot>(
                    //     stream: FirebaseFirestore.instance
                    //         .collection('chat')
                    //         .snapshots(),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasData) {
                    //         try {
                    //           var chatlist = snapshot.data!.docs.where((element) {
                    //             final data =
                    //                 element.data() as Map<String, dynamic>?;
                    //             final chatId = data?['chatId'] as String?;
                    //             final isAiChat =
                    //                 chatId?.startsWith('ai-chat-') ?? false;

                    //             return chatId != null &&
                    //                 (chatId.contains(currentUserId) || isAiChat);
                    //           }).toList();

                    //           chatlist.sort((a, b) {
                    //             int timestampA = a['time'] ??
                    //                 0; // Use 0 as fallback for null timestamps
                    //             int timestampB = b['time'] ??
                    //                 0; // same as above, but for the other timestamp
                    //             return timestampB.compareTo(
                    //                 timestampA); // Sort in descending order (newest first)
                    //           });

                    //           return Column(
                    //             children: [
                    //               ListTile(

                    //                 leading: CircleAvatar(
                    //                   child: profileImage(
                    //                     profilePic: chat['receiverPhoto'].isEmpty
                    //                         ? 'https://example.com/default_ai.png'
                    //                         : chat['receiverPhoto'],
                    //                     size: 50.r,
                    //                   ),
                    //                 ),
                    //                 title: Text('FAMZY AI'),
                    //                 trailing: TextButton(
                    //                   onPressed: () {
                    //                     Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                         builder: (context) => SinglChatScreen(
                    //                           chatId: 'ai-chat-$currentUserId',
                    //                           receiverId: 'gemini-ai-id',
                    //                           receiverName: 'Tourz AI Assistant',
                    //                           receiverPhoto: '',
                    //                         ),
                    //                       ),
                    //                     );
                    //                   },
                    //                   child: Text("Chat"),
                    //                 ),
                    //               ),
                    //               ListView.builder(
                    //                 itemCount: chatlist.length,
                    //                 itemBuilder: (context, index) {
                    //                   var chat = chatlist[index];
                    //                   String chatId = chat['chatId'];

                    //                   return FutureBuilder<int>(
                    //                     future: _getUnseenMessageCount(chatId),
                    //                     builder: (context, snapshot) {
                    //                       int unseenCount = snapshot.data ?? 0;

                    //                       return Card(
                    //                         shape: RoundedRectangleBorder(
                    //                           borderRadius:
                    //                               BorderRadius.circular(5),
                    //                         ),
                    //                         color: Colors.white,
                    //                         child: ListTile(
                    //                           onTap: () async {
                    //                             // Mark messages as seen when the chat is opened
                    //                             await _markMessagesAsSeen(chatId);

                    //                             Navigator.push(
                    //                               context,
                    //                               MaterialPageRoute(
                    //                                 builder: (_) =>
                    //                                     SinglChatScreen(
                    //                                   receiverId:
                    //                                       chat['receiverId'],
                    //                                   receiverName:
                    //                                       chat['receiverName'],
                    //                                   receiverPhoto:
                    //                                       chat['receiverPhoto'],
                    //                                   chatId: chat['chatId'],
                    //                                 ),
                    //                               ),
                    //                             );
                    //                           },
                    //                           leading: CircleAvatar(
                    //                             child: profileImage(
                    //                               profilePic:
                    //                                   chat['receiverPhoto'],
                    //                               size: 50.r,
                    //                             ),
                    //                           ),
                    //                           title: Text(
                    //                             chat['receiverName'],
                    //                             style: TextStyle(fontSize: 18.sp),
                    //                           ),
                    //                           subtitle: Text(
                    //                             chat['message'].length > 20
                    //                                 ? chat['message']
                    //                                         .substring(0, 20) +
                    //                                     '...'
                    //                                 : chat['message'],
                    //                             style: TextStyle(
                    //                               color: Colors.black
                    //                                   .withOpacity(.6),
                    //                             ),
                    //                           ),
                    //                           trailing: Column(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.center,
                    //                             children: [
                    //                               if (unseenCount > 0)
                    //                                 Container(
                    //                                   padding:
                    //                                       EdgeInsets.symmetric(
                    //                                           horizontal: 6,
                    //                                           vertical: 3),
                    //                                   decoration: BoxDecoration(
                    //                                     color: Colors.green,
                    //                                     borderRadius:
                    //                                         BorderRadius.circular(
                    //                                             50),
                    //                                   ),
                    //                                   child: Text(
                    //                                     unseenCount.toString(),
                    //                                     style: TextStyle(
                    //                                       color: Colors.white,
                    //                                       fontSize: 10.sp,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               SizedBox(
                    //                                 height: 5.h,
                    //                               ),
                    //                               Text(
                    //                                 getFormattedTime(chat['time'],
                    //                                     format: 'hh:mm a'),
                    //                                 style: TextStyle(
                    //                                   fontSize: 12.sp,
                    //                                   color: Colors.black
                    //                                       .withOpacity(.6),
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       );
                    //                     },
                    //                   );
                    //                 },
                    //               ),
                    //             ],
                    //           );
                    //         } catch (e) {
                    //           return Center(child: Text('Failed to load chats.'));
                    //         }
                    //       } else {
                    //         return Center(
                    //           child: Text(
                    //             'No Interactions yet',
                    //             style: TextStyle(
                    //                 fontSize: 20.sp, color: Colors.black),
                    //           ),
                    //         );
                    //       }
                    //     },
                    //   )

                    //                   StreamBuilder<QuerySnapshot>(
                    //   stream: FirebaseFirestore.instance.collection('chat').snapshots(),
                    //   builder: (context, snapshot) {
                    //     if (!snapshot.hasData) {
                    //       return Center(child: CircularProgressIndicator());
                    //     }

                    //     try {
                    //       // Filter chats for current user
                    //       var chatlist = snapshot.data!.docs.where((element) {
                    //         final data = element.data() as Map<String, dynamic>?;
                    //         return data?['chatId']?.contains(currentUserId) ?? false;
                    //       }).toList();

                    //       // Create AI chat entry
                    //       final aiChatDoc = {
                    //         'chatId': 'ai-chat-$currentUserId',
                    //         'receiverId': 'gemini-ai-id',
                    //         'receiverName': 'Tourz AI Assistant',
                    //         'receiverPhoto': 'https://example.com/ai_avatar.png', // Add your AI image URL
                    //         'time': 0, // Pinned timestamp
                    //         'isAI': true,
                    //         'message': 'Ask me anything about tours!' // Default message
                    //       };

                    //       // Merge and sort chats
                    //       final allChats = [...chatlist, aiChatDoc];
                    //       allChats.sort((a, b) {
                    //         if (a['isAI'] == true) return -1;
                    //         if (b['isAI'] == true) return 1;
                    //         return (b['time'] ?? 0).compareTo(a['time'] ?? 0);
                    //       });

                    //       return ListView.builder(
                    //         shrinkWrap: true,
                    //         physics: NeverScrollableScrollPhysics(),
                    //         itemCount: allChats.length,
                    //         itemBuilder: (context, index) {
                    //           final chat = allChats[index];
                    //           final isAI = chat['isAI'] == true;
                    //           final chatId = chat['chatId'];

                    //           return FutureBuilder<int>(
                    //             future: isAI ? Future.value(0) : _getUnseenMessageCount(chatId),
                    //             builder: (context, snapshot) {
                    //               int unseenCount = snapshot.data ?? 0;

                    //               return Card(
                    //                 shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(5),
                    //                 color: Colors.white,
                    //                 child: ListTile(
                    //                   onTap: () async {
                    //                     if (isAI) {
                    //                       // Create AI chat document if not exists
                    //                       await FirebaseFirestore.instance.collection('chat')
                    //                         .doc(chatId)
                    //                         .set(chat, SetOptions(merge: true));
                    //                     }
                    //                     await _markMessagesAsSeen(chatId);

                    //                     Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                         builder: (_) => SinglChatScreen(
                    //                           receiverId: chat['receiverId'],
                    //                           receiverName: chat['receiverName'],
                    //                           receiverPhoto: chat['receiverPhoto'],
                    //                           chatId: chatId,
                    //                         ),
                    //                       ),
                    //                     );
                    //                   },
                    //                   leading: CircleAvatar(
                    //                     child: profileImage(
                    //                       profilePic: chat['receiverPhoto']?.isNotEmpty == true
                    //                           ? chat['receiverPhoto']
                    //                           : 'assets/default_ai.png', // Add default AI image
                    //                       size: 50.r,
                    //                     ),
                    //                   ),
                    //                   title: Text(
                    //                     chat['receiverName'],
                    //                     style: TextStyle(fontSize: 18.sp),
                    //                   ),
                    //                   subtitle: Text(
                    //                     chat['message'].length > 20
                    //                         ? chat['message'].substring(0, 20) + '...'
                    //                         : chat['message'],
                    //                     style: TextStyle(
                    //                       color: Colors.black.withOpacity(.6),
                    //                   ),
                    //                   trailing: Column(
                    //                     mainAxisAlignment: MainAxisAlignment.center,
                    //                     children: [
                    //                       if (unseenCount > 0 && !isAI)
                    //                         Container(
                    //                           padding: EdgeInsets.symmetric(
                    //                               horizontal: 6, vertical: 3),
                    //                           decoration: BoxDecoration(
                    //                             color: Colors.green,
                    //                             borderRadius: BorderRadius.circular(50),
                    //                           ),
                    //                           child: Text(
                    //                             unseenCount.toString(),
                    //                             style: TextStyle(
                    //                               color: Colors.white,
                    //                               fontSize: 10.sp),
                    //                           ),
                    //                         ),
                    //                       SizedBox(height: 5.h),
                    //                       Text(
                    //                         getFormattedTime(
                    //                             chat['time'] ?? 0,
                    //                             format: 'hh:mm a'),
                    //                         style: TextStyle(
                    //                           fontSize: 12.sp,
                    //                           color: Colors.black.withOpacity(.6)),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           );
                    //         },
                    //       );
                    //     } catch (e) {
                    //       return Center(child: Text('Failed to load chats.'));
                    //     }
                    //   },
                    // )
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chat')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          try {
                            // Process Firestore documents with type safety
                            final chatlist = snapshot.data!.docs
                                .map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  return {
                                    'chatId': data['chatId'] as String? ?? '',
                                    'receiverId':
                                        data['receiverId'] as String? ?? '',
                                    'receiverName':
                                        data['receiverName'] as String? ??
                                            'Unknown',
                                    'receiverPhoto':
                                        data['receiverPhoto'] as String? ?? '',
                                    'time': data['time'] as int? ?? 0,
                                    'message': data['message'] as String? ??
                                        'No messages',
                                    // 'isAI': false,
                                    'isAI': data['receiverId'] ==
                                        'gemini-ai-id', // 🔹 Identify AI chat
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
                            // 🔹 Remove AI Chat if it exists in Firestore chatlist
                            chatlist
                                .removeWhere((chat) => chat['isAI'] == true);
                            // 🔹 Ensure AI Chat appears at the top
                            final allChats = [aiChatDoc, ...chatlist];

                            // 🔹 Sort only the user chats (AI chat remains at the top)
                            allChats.sublist(1).sort((a, b) =>
                                (b['time'] as int).compareTo(a['time'] as int));

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
                            return Center(child: CircularProgressIndicator());
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
      print('length of unseen messages: ${snapshot.docs.length}');
      return snapshot.docs.length;
    } catch (e) {
      print('Error fetching unread messages: $e');
      // Optionally, show an error message to the user
      return 0; // Return 0 in case of an error
    }
  }

  Future<void> _markMessagesAsSeen(String chatId) async {
    try {
      // Fetch unread messages
      final snapshot = await FirebaseFirestore.instance
          .collection(
              'chat') // Ensure this matches your Firestore collection name
          .doc(chatId)
          .collection('conversation')
          .where('seen', isEqualTo: false)
          .where('senderId', isNotEqualTo: currentUserId)
          .get();

      // Update each message as seen
      for (var doc in snapshot.docs) {
        await doc.reference.update({'seen': true});
      }

      print('Messages marked as seen for chatId: $chatId');
    } catch (e) {
      print('Error marking messages as seen: $e');
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark messages as seen: $e')),
      );
    }
  }
}
