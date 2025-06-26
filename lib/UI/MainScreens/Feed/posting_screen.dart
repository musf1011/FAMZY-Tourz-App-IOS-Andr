// import 'dart:io';
// import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

// class PostingScreen extends StatefulWidget {
//   const PostingScreen({super.key});

//   @override
//   State<PostingScreen> createState() => _PostingScreenState();
// }

// class _PostingScreenState extends State<PostingScreen> {
//   XFile? image;
//   File? imageFile;
//   bool isUploading = false; // For showing a loading indicator during upload
//   TextEditingController descriptionController =
//       TextEditingController(); // Controller for the description

//   // Function to pick image from camera
//   void pickImageCamera() async {
//     final ImagePicker picker = ImagePicker();
//     image = await picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       setState(() {
//         imageFile = File(image!.path);
//       });
//     }
//   }

//   // Function to pick image from gallery
//   void pickImageGallery() async {
//     final ImagePicker picker = ImagePicker();
//     image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         imageFile = File(image!.path);
//       });
//     }
//   }

//   // Function to upload image to Firebase Storage and store data in Firestore
//   Future<void> uploadImage() async {
//     if (imageFile == null || descriptionController.text.isEmpty) {
//       ToastPopUp().toastPopUp(
//           'Please select an image and write a description', Colors.red);

//       return;
//     }

//     setState(() {
//       isUploading = true; // Show loading spinner
//     });

//     try {
//       // Upload image to Firebase Storage
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       Reference firebaseStorageRef =
//           FirebaseStorage.instance.ref().child('uploads/$fileName');

//       await firebaseStorageRef.putFile(imageFile!);
//       String downloadURL = await firebaseStorageRef.getDownloadURL();

//       // Save image URL and description to Firestore
//       await FirebaseFirestore.instance.collection('posts').add({
//         'imageURL': downloadURL,
//         'description': descriptionController.text.trim(),
//         'timestamp': FieldValue.serverTimestamp(),
//         'userId': FirebaseAuth.instance.currentUser?.uid,
//         'likes': 0,
//         'comments': [],
//       });
//       ToastPopUp().toastPopUp('Post Upload Succesfully!', Colors.green);

//       Navigator.pop(context); // Go back to the previous screen
//       // Clear the image and description after uploading
//       setState(() {
//         imageFile = null;
//         descriptionController.clear();
//       });
//     } catch (e) {
//       ToastPopUp().toastPopUp('Upload failed: $e', Colors.red);
//     } finally {
//       setState(() {
//         isUploading = false; // Hide loading spinner
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload Post'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.upload),
//             onPressed:
//                 isUploading ? null : uploadImage, // Disable while uploading
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Text Field for post content (caption)
//             Container(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.r),
//                 color: Colors.grey[200],
//               ),
//               child: TextField(
//                 controller:
//                     descriptionController, // Attach controller to TextField
//                 decoration: InputDecoration(
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10.r)),
//                     borderSide: BorderSide(color: Colors.green),
//                   ),
//                   border: InputBorder.none,
//                   hintText: 'Write a caption...',
//                 ),
//                 maxLines: null,
//                 keyboardType: TextInputType.multiline,
//               ),
//             ),
//             SizedBox(height: 20.h),

//             // Display selected image
//             imageFile != null
//                 ? Container(
//                     width: 1.sw,
//                     height: .5.sh,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.grey),
//                       image: DecorationImage(
//                         image: FileImage(imageFile!),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   )
//                 : GestureDetector(
//                     onTap: pickImageGallery,
//                     child: Container(
//                       width: 1.sw,
//                       height: .55.sh,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.grey),
//                       ),
//                       child: const Center(
//                         child: Text('No Image Selected\nTap to Select One',
//                             style: TextStyle(color: Colors.black45)),
//                       ),
//                     ),
//                   ),
//             SizedBox(height: 20.h),

//             // Camera and Gallery buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: pickImageCamera,
//                   icon: const Icon(Icons.camera_alt),
//                   label: const Text('Camera'),
//                 ),
//                 SizedBox(width: 20.w),
//                 ElevatedButton.icon(
//                   onPressed: pickImageGallery,
//                   icon: const Icon(Icons.photo_library),
//                   label: const Text('Gallery'),
//                 ),
//               ],
//             ),

//             // Show loading spinner while uploading
//             if (isUploading)
//               const Center(
//                 child: SpinKitFadingCircle(color: Colors.yellow, size: 70),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
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
      appBar: AppBar(
        title: const Text('Upload Post'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
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
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    border: InputBorder.none,
                    hintText: 'Write a caption...',
                  ),
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
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Center(
                          child: Text('No Image Selected\\nTap to Select One',
                              style: TextStyle(color: Colors.black45)),
                        ),
                      ),
                    ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: pickImageCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  SizedBox(width: 20.w),
                  ElevatedButton.icon(
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
