// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/chatting/gemini_ai/gemini_model.dart';
// import 'package:famzy_tourz_app/Utilities/prof_image.dart';
// import 'package:famzy_tourz_app/Utilities/time_formatter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class SinglChatScreen extends StatefulWidget {
//   final String receiverId;
//   final String receiverName;
//   final String receiverPhoto;
//   final String chatId;
//   const SinglChatScreen(
//       {super.key,
//       required this.receiverId,
//       required this.receiverName,
//       required this.receiverPhoto,
//       required this.chatId});

//   @override
//   State<SinglChatScreen> createState() => _SinglChatScreenState();
// }

// class _SinglChatScreenState extends State<SinglChatScreen> {
//   final ScrollController _scrollController = ScrollController();
//   TextEditingController messageController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Scroll to bottom when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollToBottom();
//     });
//   }

//   final GeminiAIService _aiService = GeminiAIService();
//   Future<void> sendAIMessage(String chatId, String message) async {
//     final aiResponse = await _aiService.generateResponse(message);

//     await FirebaseFirestore.instance
//         .collection('chat')
//         .doc(chatId)
//         .collection('conversation')
//         .add({
//       'senderId': 'gemini-ai',
//       'receiverId': FirebaseAuth.instance.currentUser!.uid,
//       'message': aiResponse,
//       'time': DateTime.now().millisecondsSinceEpoch,
//       'seen': true,
//       'isAI': true
//     });
//   }

// // sendMessage method
//   void sendMessage() async {
//     final message = messageController.text.trim();
//     if (message.isEmpty) return;

//     //add chat to firestore
//     FirebaseFirestore.instance.collection('chat').doc(widget.chatId).set({
//       'senderId': FirebaseAuth.instance.currentUser!.uid,
//       'receiverId': widget.receiverId,
//       'chatId': widget.chatId,
//       'senderName':
//           FirebaseAuth.instance.currentUser!.displayName ?? 'Unkown User',
//       'receiverName': widget.receiverName,
//       // 'senderPhoto': FirebaseAuth.instance.currentUser!.photoURL,
//       'receiverPhoto': widget.receiverPhoto,
//       'message': messageController.text.trim(),
//       'time': DateTime.now().millisecondsSinceEpoch
//     }).then((value) {
//       messageController.clear();
//     }).onError((error, stackTrace) {
//       print('Message not sent');
//     });
//     // First send user message
//     await FirebaseFirestore.instance
//         .collection('chat')
//         .doc(widget.chatId)
//         .collection('conversation')
//         .add({
//       'senderId': FirebaseAuth.instance.currentUser!.uid,
//       'receiverId': widget.receiverId,
//       'message': message,
//       'time': DateTime.now().millisecondsSinceEpoch,
//       'seen': false,
//       'isAI': false
//     });

//     // If chatting with AI, generate response
//     if (widget.receiverId == 'gemini-ai-id') {
//       await sendAIMessage(widget.chatId, message);
//     }

//     messageController.clear();
//     _scrollToBottom();
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus(); //to unfocus the keyboard
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Row(
//             mainAxisSize:
//                 MainAxisSize.min, // Prevents Row from taking full width
//             children: [
//               profileImage(profilePic: widget.receiverPhoto, size: 28.r),
//               SizedBox(width: 15.w),
//               Text(
//                 widget.receiverName,
//                 style: TextStyle(color: Colors.white, fontSize: 23.sp),
//               ),
//             ],
//           ),
//           //centerTitle: true,
//           backgroundColor: const Color.fromARGB(255, 0, 57, 2),
//           iconTheme:
//               IconThemeData(color: Colors.white), // it make back button white
//         ),
//         body: Container(
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   colorFilter: ColorFilter.mode(
//                       Colors.black.withOpacity(0.2), BlendMode.luminosity
//                       // BlendMode.dstATop
//                       ),
//                   // opacity: 0.5,
//                   image: const AssetImage("asset/images/bg-conversation1.jpg"),
//                   fit: BoxFit.cover)),
//           child: Column(
//             children: [
//               Expanded(
//                 child: StreamBuilder(
//                   stream: FirebaseFirestore.instance
//                       .collection('chat')
//                       .doc(widget.chatId)
//                       .collection('conversation')
//                       .orderBy('time', descending: false)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasError) {
//                       return const Text('Error');
//                     } else if (!snapshot.hasData ||
//                         snapshot.data!.docs.isEmpty) {
//                       return const Center(
//                         child: Text('No messages yet'),
//                       );
//                     }

//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       _scrollToBottom();
//                     });

//                     return ListView.builder(
//                         controller: _scrollController,
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (context, index) {
//                           final messageData = snapshot.data!.docs[index];
//                           final isSender = messageData['senderId'] ==
//                               FirebaseAuth.instance.currentUser!.uid;
//                           final isAI = messageData['isAI'] == true;

//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Align(
//                               alignment: isSender
//                                   ? Alignment.centerRight
//                                   : Alignment.centerLeft,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   BubbleSpecialThree(
//                                     isSender: isSender,
//                                     text: messageData['message'],
//                                     color: isAI
//                                         ? const Color.fromARGB(200, 0, 30, 0)
//                                         : (isSender
//                                             ? const Color.fromARGB(
//                                                 150, 0, 100, 0)
//                                             : Color.fromARGB(
//                                                 150, 255, 255, 255)),
//                                     tail: true,
//                                     textStyle: TextStyle(
//                                         color: isAI
//                                             ? Colors.white
//                                             : isSender
//                                                 ? Colors.white
//                                                 : Colors.black,
//                                         fontSize: 13.sp),
//                                   ),
//                                   Align(
//                                       alignment: isSender
//                                           ? Alignment.centerRight
//                                           : Alignment.centerLeft,
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           color: Colors.white.withOpacity(0.5),
//                                         ),
//                                         width: .14.sw,
//                                         height: 0.015.sh,
//                                         child: Text(
//                                           getFormattedTime(messageData['time'],
//                                               format: ' hh:mm a\t\t\t'),
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 10.sp,
//                                           ),
//                                         ),
//                                       ))
//                                 ],
//                               ),
//                             ),
//                           );
//                         });
//                   },
//                 ),
//               ),
//               SizedBox(height: 3.h),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   SizedBox(
//                     width: .85.sw,
//                     height: .08.sh,
//                     child: TextField(
//                       controller: messageController,
//                       style: TextStyle(fontSize: 18.sp, color: Colors.black),
//                       decoration: const InputDecoration(
//                         hintText: 'Enter message',
//                         hintStyle:
//                             TextStyle(color: Color.fromARGB(255, 0, 57, 2)),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(25)),
//                           borderSide:
//                               BorderSide(color: Color.fromARGB(150, 0, 100, 0)),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Color.fromARGB(255, 0, 57, 2)),
//                           borderRadius: BorderRadius.all(Radius.circular(50)),
//                         ),
//                       ),
//                       cursorColor: const Color.fromARGB(255, 0, 57, 2),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 10.h),
//                     child: IconButton(
//                       onPressed: () {
//                         sendMessage();
//                       },
//                       icon: Icon(
//                         Icons.send,
//                         color: const Color.fromARGB(255, 0, 57, 2),
//                         size: 35.r,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BubbleSpecialThree extends StatelessWidget {
//   final bool isSender;
//   final String text;
//   final Color color;
//   final bool tail;
//   final TextStyle textStyle;

//   const BubbleSpecialThree({
//     super.key,
//     required this.isSender,
//     required this.text,
//     required this.color,
//     required this.tail,
//     required this.textStyle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5, horizontal: isSender ? 10 : 0),
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(
//         text,
//         style: textStyle,
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/UI/MainScreens/chatting/gemini_ai/gemini_model.dart';
import 'package:famzy_tourz_app/Utilities/prof_image.dart';
import 'package:famzy_tourz_app/Utilities/time_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

class SinglChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverPhoto;
  final String chatId;
  const SinglChatScreen(
      {super.key,
      required this.receiverId,
      required this.receiverName,
      required this.receiverPhoto,
      required this.chatId});

  @override
  State<SinglChatScreen> createState() => _SinglChatScreenState();
}

class _SinglChatScreenState extends State<SinglChatScreen> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  final GeminiAIService _aiService = GeminiAIService();
  Future<void> sendAIMessage(String chatId, String message) async {
    String rawResponse = await _aiService.generateResponse(message);
    String cleanedResponse = rawResponse.replaceAll(RegExp(r'\`\`\`'), '');

    await FirebaseFirestore.instance
        .collection('chat')
        .doc(chatId)
        .collection('conversation')
        .add({
      'senderId': 'gemini-ai',
      'receiverId': FirebaseAuth.instance.currentUser!.uid,
      'message': cleanedResponse,
      'time': DateTime.now().millisecondsSinceEpoch,
      'seen': true,
      'isAI': true
    });
  }

  Future<String> getSenderName() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    // If displayName is available, return it
    if (currentUser?.displayName != null &&
        currentUser!.displayName!.isNotEmpty) {
      return currentUser.displayName!;
    }

    // Else, fetch from Firestore
    final doc = await FirebaseFirestore.instance
        .collection('UserDetails')
        .doc(currentUser!.uid)
        .get();

    return doc.data()?['fullName'] ?? 'Unknown User';
  }

  void sendMessage() async {
    final message = messageController.text.trim();
    if (message.isEmpty) return;
    final senderName = await getSenderName();
    FirebaseFirestore.instance.collection('chat').doc(widget.chatId).set({
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'receiverId': widget.receiverId,
      'chatId': widget.chatId,
      'senderName': senderName,
      'receiverName': widget.receiverName,
      'receiverPhoto': widget.receiverPhoto,
      'message': message,
      'time': DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      messageController.clear();
    }).onError((error, stackTrace) {
      print('Message not sent');
    });

    await FirebaseFirestore.instance
        .collection('chat')
        .doc(widget.chatId)
        .collection('conversation')
        .add({
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'receiverId': widget.receiverId,
      'message': message,
      'time': DateTime.now().millisecondsSinceEpoch,
      'seen': false,
      'isAI': false
    });

    if (widget.receiverId == 'gemini-ai-id') {
      await sendAIMessage(widget.chatId, message);
    }

    messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              profileImage(profilePic: widget.receiverPhoto, size: 28.r),
              SizedBox(width: 15.w),
              Text(
                widget.receiverName,
                style: TextStyle(color: Colors.white, fontSize: 23.sp),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 0, 57, 2),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.luminosity),
                  image: const AssetImage("asset/images/bg-conversation1.jpg"),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chat')
                      .doc(widget.chatId)
                      .collection('conversation')
                      .orderBy('time', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No messages yet'));
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });

                    return ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final messageData = snapshot.data!.docs[index];
                          final isSender = messageData['senderId'] ==
                              FirebaseAuth.instance.currentUser!.uid;
                          final isAI = messageData['isAI'] == true;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                isAI
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: EdgeInsets.all(12.w),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                150, 0, 30, 0),
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          child: MarkdownBody(
                                            data: messageData['message'],
                                            styleSheet: MarkdownStyleSheet(
                                              p: GoogleFonts.poppins(
                                                fontSize: 16.sp,
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                                fontWeight: FontWeight.w400,
                                                height: 1.4,
                                              ),
                                              strong: GoogleFonts.poppins(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              listBullet: GoogleFonts.poppins(
                                                fontSize: 16.sp,
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                              ),
                                            ),
                                          ),
                                        ))
                                    : Align(
                                        alignment: isSender
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: BubbleSpecialThree(
                                          isSender: isSender,
                                          text: messageData['message'],
                                          color: isSender
                                              ? const Color.fromARGB(
                                                  150, 0, 100, 0)
                                              : const Color.fromARGB(
                                                  150, 255, 255, 255),
                                          tail: true,
                                          textStyle: TextStyle(
                                              color: isSender
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13.sp),
                                        )),
                                Align(
                                  alignment: isSender
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    width: .14.sw,
                                    height: 0.015.sh,
                                    child: Text(
                                      getFormattedTime(messageData['time'],
                                          format: ' hh:mm a			'),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: .85.sw,
                    height: .08.sh,
                    child: TextField(
                      controller: messageController,
                      style: TextStyle(fontSize: 18.sp, color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Enter message',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 0, 57, 2)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide:
                              BorderSide(color: Color.fromARGB(150, 0, 100, 0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 57, 2)),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      cursorColor: const Color.fromARGB(255, 0, 57, 2),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: const Color.fromARGB(255, 0, 57, 2),
                        size: 35.r,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BubbleSpecialThree extends StatelessWidget {
  final bool isSender;
  final String text;
  final Color color;
  final bool tail;
  final TextStyle textStyle;

  const BubbleSpecialThree({
    super.key,
    required this.isSender,
    required this.text,
    required this.color,
    required this.tail,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: isSender ? 10 : 0),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
