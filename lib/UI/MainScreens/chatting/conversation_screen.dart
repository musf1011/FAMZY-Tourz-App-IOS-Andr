import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/Utilities/prof_image.dart';
import 'package:famzy_tourz_app/Utilities/time_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    // Scroll to bottom when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // String getcombinID(String firstID, String secondID) {
  //   List<String> ids = [firstID, secondID];
  //   ids.sort();
  //   return ids.join("_");
  // }

  void sendMessage() {
    // String combinId =
    //     getcombinID(widget.recieverid, FirebaseAuth.instance.currentUser!.uid);

    FirebaseFirestore.instance.collection('chat').doc(widget.chatId).set({
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'receiverId': widget.receiverId,
      'chatId': widget.chatId,
      'senderName':
          FirebaseAuth.instance.currentUser!.displayName ?? 'Unkown User',
      'receiverName': widget.receiverName,
      // 'senderPhoto': FirebaseAuth.instance.currentUser!.photoURL,
      'receiverPhoto': widget.receiverPhoto,
      'message': messageController.text.trim(),
      'time': DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      messageController.clear();
    }).onError((error, stackTrace) {
      print('Message not sent');
    });

    FirebaseFirestore.instance
        .collection('chat')
        .doc(widget.chatId)
        .collection('conversation')
        .add({
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'recieverId': widget.receiverId,
      'message': messageController.text.trim(),
      'time': DateTime.now().millisecondsSinceEpoch,
      'seen': false
    }).then((value) {
      _scrollToBottom();
    }).onError((error, stackTrace) {
      print('Message not sent');
    });
    messageController.clear();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); //to unfocus the keyboard
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize:
                MainAxisSize.min, // Prevents Row from taking full width
            children: [
              profileImage(profilePic: widget.receiverPhoto, size: 35.r),
              SizedBox(width: 10.w),
              Text(
                widget.receiverName,
                style: TextStyle(color: Colors.white, fontSize: 23.sp),
              ),
            ],
          ),
          //centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 57, 2),
          iconTheme:
              IconThemeData(color: Colors.white), // it make back button white
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
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
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No messages yet'),
                    );
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

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              BubbleSpecialThree(
                                isSender: isSender,
                                text: messageData['message'],
                                color: isSender
                                    ? Colors.black54
                                    : const Color.fromARGB(255, 0, 57, 2),
                                tail: true,
                                textStyle: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Text(
                                getFormattedTime(messageData['time'],
                                    format: 'HH:mm a\t\t\t'),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.sp,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
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
                      // fillColor: Colors.green,
                      hintText: 'Enter message',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 0, 57, 2)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                  ),
                ),
                // SizedBox(width: 1.w),
                IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.teal,
                    size: 35.r,
                  ),
                )
              ],
            ),
          ],
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
