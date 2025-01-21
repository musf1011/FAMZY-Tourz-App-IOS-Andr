// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
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
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please select an image and write a description')),
//       );
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
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Post uploaded successfully!')),
//       );

//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) => const HomeScreen(
//                     selectedIndex: 0,
//                   )));

//       // Clear the image and description after uploading
//       setState(() {
//         imageFile = null;
//         descriptionController.clear();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Upload failed: $e')),
//       );
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
//                 borderRadius: BorderRadius.circular(8.0),
//                 color: Colors.grey[200],
//               ),
//               child: TextField(
//                 controller:
//                     descriptionController, // Attach controller to TextField
//                 decoration: const InputDecoration(
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
//                     height: .55.sh,
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
//                         child: Text('No Image Selected\nTap to Select One'),
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
//                 child: CircularProgressIndicator(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
