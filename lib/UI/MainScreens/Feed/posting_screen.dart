import 'dart:io';
import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
import 'package:famzy_tourz_app/contstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostingScreen extends StatefulWidget {
  const PostingScreen({super.key});

  @override
  State<PostingScreen> createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  XFile? image;
  File? imageFile;
  bool isUploading = false;
  TextEditingController descriptionController = TextEditingController();

  void pickImageCamera() async {
    final picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imageFile = File(image!.path);
      });
    }
  }

  void pickImageGallery() async {
    final picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image!.path);
      });
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null || descriptionController.text.isEmpty) {
      ToastPopUp().toastPopUp(
          'Please select an image and write a description', Colors.red);
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');

      await firebaseStorageRef.putFile(imageFile!);
      final downloadURL = await firebaseStorageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('posts').add({
        'imageURL': downloadURL,
        'description': descriptionController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'likes': 0,
        'likesCount': 0,
        'commentsCount': 0,
        'comments': [],
      });

      ToastPopUp().toastPopUp('Post uploaded successfully!', Colors.green);
      Navigator.pop(context);
      setState(() {
        imageFile = null;
        descriptionController.clear();
      });
    } catch (e) {
      ToastPopUp().toastPopUp('Upload failed: $e', Colors.red);
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.transGColor,
      appBar: AppBar(
        backgroundColor: AppConstants.secondaryColor,
        title: Text(
          'Upload Post',
          style: AppConstants.appBarTextStyle,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppConstants.whiteColorP5,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.upload,
              color: AppConstants.whiteColorP9,
            ),
            onPressed: isUploading ? null : uploadImage,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppConstants.whiteColorP5,
                    border: Border.all(color: AppConstants.whiteColorP5)),
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        borderSide:
                            BorderSide(color: AppConstants.whiteColorP9),
                      ),
                      border: InputBorder.none,
                      hintText: 'Write a caption...',
                      hintStyle: TextStyle(color: AppConstants.whiteColorP5)),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              SizedBox(height: 20.h),
              imageFile != null
                  ? Container(
                      width: 1.sw,
                      height: .5.sh,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        image: DecorationImage(
                          image: FileImage(imageFile!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: pickImageGallery,
                      child: Container(
                        width: 1.sw,
                        height: .55.sh,
                        decoration: BoxDecoration(
                          color: AppConstants.whiteColorP5,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: Text('No Image Selected\\nTap to Select One',
                              style:
                                  TextStyle(color: AppConstants.whiteColorP5)),
                        ),
                      ),
                    ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.whiteColorP9,
                        foregroundColor: AppConstants.transGColor),
                    onPressed: pickImageCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  SizedBox(width: 20.w),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.whiteColorP9,
                        foregroundColor: AppConstants.transGColor),
                    onPressed: pickImageGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
              if (isUploading)
                const Center(
                  child: SpinKitFadingCircle(color: Colors.yellow, size: 70),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
