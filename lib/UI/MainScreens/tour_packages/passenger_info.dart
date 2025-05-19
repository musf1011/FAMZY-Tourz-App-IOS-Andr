// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class PassengerInfoScreen extends StatefulWidget {
// //   final String destination;
// //   final String bgImage;
// //   final String tourId;
// //   final Map<String, dynamic> packageDetails;
// //   final int seatCount;

// //   const PassengerInfoScreen({
// //     super.key,
// //     required this.destination,
// //     required this.bgImage,
// //     required this.tourId,
// //     required this.packageDetails,
// //     required this.seatCount,
// //   });

// //   @override
// //   State<PassengerInfoScreen> createState() => _PassengerInfoScreenState();
// // }

// // class _PassengerInfoScreenState extends State<PassengerInfoScreen> {
// //   int seatCount = 1;
// //   List<Map<String, TextEditingController>> passengerControllers = [];
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     print('here\nnow\nwhenn');
// //     seatCount = widget.seatCount;
// //     fetchUserData();
// //   }

// //   void fetchUserData() async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) return;

// //     final userDoc = await FirebaseFirestore.instance
// //         .collection('UserDetails')
// //         .doc(user.uid)
// //         .get();

// //     final data = userDoc.data() ?? {};
// //     addPassengerFields(0, data);
// //     for (int i = 1; i < seatCount; i++) {
// //       addPassengerFields(i);
// //     }

// //     setState(() {
// //       isLoading = false;
// //     });
// //   }

// //   void addPassengerFields(int index, [Map<String, dynamic>? data]) {
// //     passengerControllers.add({
// //       'name': TextEditingController(text: data?['fullName'] ?? ''),
// //       'gender': TextEditingController(text: data?['gender'] ?? ''),
// //       'id': TextEditingController(text: data?['idNumber'] ?? ''),
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     for (var passenger in passengerControllers) {
// //       for (var controller in passenger.values) {
// //         controller.dispose();
// //       }
// //     }
// //     super.dispose();
// //   }

// //   void updatePassengerList() {
// //     if (seatCount > passengerControllers.length) {
// //       for (int i = passengerControllers.length; i < seatCount; i++) {
// //         addPassengerFields(i);
// //       }
// //     } else {
// //       passengerControllers = passengerControllers.sublist(0, seatCount);
// //     }
// //     setState(() {});
// //   }

// //   void submitBooking() async {
// //     final firestore = FirebaseFirestore.instance;
// //     final user = FirebaseAuth.instance.currentUser;

// //     if (user == null) return;

// //     for (var passenger in passengerControllers) {
// //       final id = passenger['id']!.text.trim();
// //       if (id.isEmpty) continue;

// //       await firestore
// //           .collection('packages')
// //           .doc(widget.tourId)
// //           .collection('passengersDetails')
// //           .doc(id)
// //           .set({
// //         'name': passenger['fullName']!.text.trim(),
// //         'gender': passenger['gender']!.text.trim(),
// //         'idNumber': id,
// //         'bookedBy': user.uid,
// //         'timestamp': FieldValue.serverTimestamp(),
// //       });
// //     }

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text('Booking submitted successfully!')),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final pricePerPerson =
// //         int.tryParse(widget.packageDetails['price'].toString()) ?? 0;
// //     final totalPrice = pricePerPerson * seatCount;

// //     return Scaffold(
// //       body: isLoading
// //           ? Center(child: CircularProgressIndicator())
// //           : Container(
// //               width: 1.sw,
// //               height: 1.sh,
// //               decoration: BoxDecoration(
// //                 image: DecorationImage(
// //                   image: AssetImage(widget.bgImage),
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //               child: SingleChildScrollView(
// //                 padding: EdgeInsets.all(16.w),
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.start,
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         GestureDetector(
// //                           onTap: () {
// //                             Navigator.pop(context);
// //                           },
// //                           child: Icon(
// //                             Icons.arrow_circle_left_outlined,
// //                             size: 40.h,
// //                             color: const Color.fromARGB(180, 0, 30, 0),
// //                           ),
// //                         ),
// //                         SizedBox(width: .15.sw),
// //                         Padding(
// //                           padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
// //                           child: Image.asset(
// //                             "asset/images/FAMZYLogo.png",
// //                             width: .4.sw,
// //                             height: .1.sh,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     Text(
// //                       widget.destination,
// //                       style: GoogleFonts.playfairDisplay(
// //                           fontSize: 40.sp,
// //                           fontWeight: FontWeight.bold,
// //                           color: Color.fromARGB(255, 0, 57, 2),
// //                           background: Paint()..color = Colors.white30),
// //                     ),
// //                     Text("Seats", style: TextStyle(color: Colors.white)),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         IconButton(
// //                           icon: Icon(Icons.remove, color: Colors.red),
// //                           onPressed: () {
// //                             if (seatCount > 1) {
// //                               setState(() {
// //                                 seatCount--;
// //                                 updatePassengerList();
// //                               });
// //                             }
// //                           },
// //                         ),
// //                         Text('$seatCount',
// //                             style:
// //                                 TextStyle(color: Colors.white, fontSize: 18)),
// //                         IconButton(
// //                           icon: Icon(Icons.add, color: Colors.green),
// //                           onPressed: () {
// //                             if (seatCount < 5) {
// //                               setState(() {
// //                                 seatCount++;
// //                                 updatePassengerList();
// //                               });
// //                             }
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                     ...List.generate(seatCount, (index) {
// //                       return Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text('Passenger ${index + 1}',
// //                               style: TextStyle(
// //                                   fontSize: 16,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: Colors.white)),
// //                           TextField(
// //                             controller: passengerControllers[index]['name'],
// //                             decoration: InputDecoration(
// //                                 labelText: 'Full Name',
// //                                 fillColor: Colors.white,
// //                                 filled: true),
// //                           ),

// //                           TextField(
// //                             controller: passengerControllers[index]['id'],
// //                             decoration: InputDecoration(
// //                                 labelText: 'CNIC/Form B/Passport No.',
// //                                 fillColor: Colors.white,
// //                                 filled: true),
// //                           ),
// //                           SizedBox(height: 10),
// //                         ],
// //                       );
// //                     }),
// //                     SizedBox(height: 20),
// //                     Text(
// //                       "Total Price: $totalPrice PKR",
// //                       style: TextStyle(fontSize: 18, color: Colors.greenAccent),
// //                     ),
// //                     SizedBox(height: 20),
// //                     CustomElevatedButton(
// //                       onPressed: submitBooking,
// //                       child: Text("Book Now"),
// //                     )
// //                   ],
// //                 ),
// //               ),
// //             ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:famzy_tourz_app/Utilities/CustTFField.dart';
// import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';

// class PassengerInfoScreen extends StatefulWidget {
//   final String destination;
//   final String bgImage;
//   final String tourId;
//   final Map<String, dynamic> packageDetails;
//   final int seatCount;

//   const PassengerInfoScreen({
//     super.key,
//     required this.destination,
//     required this.bgImage,
//     required this.tourId,
//     required this.packageDetails,
//     required this.seatCount,
//   });

//   @override
//   State<PassengerInfoScreen> createState() => _PassengerInfoScreenState();
// }

// class _PassengerInfoScreenState extends State<PassengerInfoScreen> {
//   int seatCount = 1;
//   List<Map<String, TextEditingController>> passengerControllers = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     seatCount = widget.seatCount;
//     fetchUserData();
//   }

//   void fetchUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     final userDoc = await FirebaseFirestore.instance
//         .collection('UserDetails')
//         .doc(user.uid)
//         .get();

//     final data = userDoc.data() ?? {};
//     addPassengerFields(0, data);
//     for (int i = 1; i < seatCount; i++) {
//       addPassengerFields(i);
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   void addPassengerFields(int index, [Map<String, dynamic>? data]) {
//     passengerControllers.add({
//       'name': TextEditingController(text: data?['fullName'] ?? ''),
//       'gender': TextEditingController(text: data?['gender'] ?? ''),
//       'id': TextEditingController(text: data?['idNumber'] ?? ''),
//     });
//   }

//   @override
//   void dispose() {
//     for (var passenger in passengerControllers) {
//       for (var controller in passenger.values) {
//         controller.dispose();
//       }
//     }
//     super.dispose();
//   }

//   void updatePassengerList() {
//     if (seatCount > passengerControllers.length) {
//       for (int i = passengerControllers.length; i < seatCount; i++) {
//         addPassengerFields(i);
//       }
//     } else {
//       passengerControllers = passengerControllers.sublist(0, seatCount);
//     }
//     setState(() {});
//   }

//   void submitBooking() async {
//     final firestore = FirebaseFirestore.instance;
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) return;

//     for (var passenger in passengerControllers) {
//       final id = passenger['id']!.text.trim();
//       if (id.isEmpty) continue;

//       await firestore
//           .collection('packages')
//           .doc(widget.tourId)
//           .collection('passengersDetails')
//           .doc(id)
//           .set({
//         'name': passenger['name']!.text.trim(),
//         'gender': passenger['gender']!.text.trim(),
//         'idNumber': id,
//         'bookedBy': user.uid,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Booking submitted successfully!')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pricePerPerson =
//         int.tryParse(widget.packageDetails['price'].toString()) ?? 0;
//     final totalPrice = pricePerPerson * seatCount;

//     return Scaffold(
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Container(
//               width: 1.sw,
//               height: 1.sh,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(widget.bgImage),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.all(16.w),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: Icon(Icons.arrow_back_ios,
//                               size: 30.h, color: Colors.white),
//                         ),
//                         SizedBox(width: 10.w),
//                         Text(widget.destination,
//                             style: GoogleFonts.playfairDisplay(
//                                 fontSize: 25.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white)),
//                       ],
//                     ),
//                     SizedBox(height: 10.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.remove, color: Colors.red),
//                           onPressed: () {
//                             if (seatCount > 1) {
//                               setState(() {
//                                 seatCount--;
//                                 updatePassengerList();
//                               });
//                             }
//                           },
//                         ),
//                         Text('$seatCount',
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 18)),
//                         IconButton(
//                           icon: Icon(Icons.add, color: Colors.green),
//                           onPressed: () {
//                             if (seatCount < 5) {
//                               setState(() {
//                                 seatCount++;
//                                 updatePassengerList();
//                               });
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     ...List.generate(seatCount, (index) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 10.h),
//                           Text('Passenger ${index + 1}',
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white)),
//                           CustTextFormField(
//                             label: 'Full Name',
//                             hint: 'Enter Full Name',
//                             controller: passengerControllers[index]['name'],
//                           ),

// DropdownButtonFormField<String>(
//   value: passengerControllers[index]['gender']!
//           .text
//           .isNotEmpty
//       ? passengerControllers[index]['gender']!.text
//       : 'null',
//   decoration: InputDecoration(
//     label: Text(
//       'Gender',
//       style: TextStyle(color: Colors.white),
//     ),
//     fillColor: Colors
//         .black, // Background color of the dropdown
//     hintText: 'Not Selected',
//     hintStyle: const TextStyle(color: Colors.grey),

//     enabledBorder: UnderlineInputBorder(
//       borderSide: BorderSide(
//         color: Colors
//             .grey, // Underline color when enabled
//         width: 1.0, // Underline width
//       ),
//     ),
//     focusedBorder: UnderlineInputBorder(
//       borderSide: BorderSide(
//         color: const Color.fromARGB(255, 123, 100,
//             22), // Underline color when focused
//         width: 2.0, // Underline width
//       ),
//     ),
//   ),
//   dropdownColor: Color.fromARGB(180, 0, 30, 0),
//   items: [
//     DropdownMenuItem(
//       value: 'male',
//       child: Text(
//         'Male',
//         style: TextStyle(
//             color: Color.fromARGB(255, 95, 176, 241)),
//       ),
//     ),
//     DropdownMenuItem(
//       value: 'female',
//       child: Text(
//         'Female',
//         style: TextStyle(
//             color:
//                 Color.fromARGB(255, 255, 109, 157)),
//       ),
//     ),
//     DropdownMenuItem(
//         value: 'other',
//         child: Text(
//           'Other',
//           style: TextStyle(
//             color: Colors.yellow,
//           ),
//         ))
//   ],
//   onChanged: (String? value) {
//     setState(() {
//       passengerControllers[index]['gender']!.text =
//           value!;
//     });
//   },
//   validator: (value) =>
//       value == null ? 'Please select a gender' : ' ',
// ),
//                           CustTextFormField(
//                             label: 'CNIC/Form B/Passport No.',
//                             hint: 'Enter ID Number',
//                             controller: passengerControllers[index]['id'],
//                           ),
//                         ],
//                       );
//                     }),
//                     SizedBox(height: 20),
//                     Text(
//                       "Total Price: $totalPrice PKR",
//                       style: TextStyle(fontSize: 18, color: Colors.greenAccent),
//                     ),
//                     SizedBox(height: 20),
//                     CustomElevatedButton(
//                       onPressed: submitBooking,
//                       child: Text("Book Now"),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:famzy_tourz_app/Utilities/CustTFField.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';

class PassengerInfoScreen extends StatefulWidget {
  final String destination;
  final String bgImage;
  // final String tourId;
  final Map<String, dynamic> packageDetails;
  final int seatCount;

  const PassengerInfoScreen({
    super.key,
    required this.destination,
    required this.bgImage,
    // required this.tourId,
    required this.packageDetails,
    required this.seatCount,
  });

  @override
  State<PassengerInfoScreen> createState() => _PassengerInfoScreenState();
}

class _PassengerInfoScreenState extends State<PassengerInfoScreen> {
  int seatCount = 1;
  List<Map<String, TextEditingController>> passengerControllers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    seatCount = widget.seatCount;
    fetchUserData();
  }

  void fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('UserDetails')
        .doc(user.uid)
        .get();

    final data = userDoc.data() ?? {};
    addPassengerFields(0, data);
    for (int i = 1; i < seatCount; i++) {
      addPassengerFields(i);
    }

    setState(() {
      isLoading = false;
    });
  }

  void addPassengerFields(int index, [Map<String, dynamic>? data]) {
    passengerControllers.add({
      'name': TextEditingController(text: data?['fullName'] ?? ''),
      'gender': TextEditingController(text: data?['gender'] ?? ''),
      'id': TextEditingController(text: data?['idNumber'] ?? ''),
      'age': TextEditingController(text: data?['age'] ?? ''),
    });
  }

  @override
  void dispose() {
    for (var passenger in passengerControllers) {
      for (var controller in passenger.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void updatePassengerList() {
    if (seatCount > passengerControllers.length) {
      for (int i = passengerControllers.length; i < seatCount; i++) {
        addPassengerFields(i);
      }
    } else {
      passengerControllers = passengerControllers.sublist(0, seatCount);
    }
    setState(() {});
  }

  void submitBooking() async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    for (var passenger in passengerControllers) {
      final id = passenger['id']!.text.trim();
      if (id.isEmpty) continue;

      await firestore
          .collection('packages')
          .doc(widget.packageDetails['tourID'])
          .collection('passengersDetails')
          .doc(id)
          .set({
        'name': passenger['name']!.text.trim(),
        'gender': passenger['gender']!.text.trim(),
        'idNumber': id,
        'age': passenger['age']!.text.trim(),
        'bookedBy': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pricePerPerson =
        int.tryParse(widget.packageDetails['price'].toString()) ?? 0;
    final totalPrice = pricePerPerson * seatCount;

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: 1.sw,
              height: 1.sh,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.bgImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_circle_left_outlined,
                            size: 40.h,
                            color: const Color.fromARGB(180, 0, 30, 0),
                          ),
                        ),
                        SizedBox(width: .15.sw),
                        Padding(
                          padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
                          child: Image.asset(
                            "asset/images/FAMZYLogo.png",
                            width: .4.sw,
                            height: .1.sh,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.destination,
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 57, 2),
                          background: Paint()..color = Colors.white30),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: 0.5.sw,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(150, 0, 30, 0),
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.w,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Seats:",
                              style: GoogleFonts.roboto(
                                  fontSize: 18.sp, color: Colors.white)),
                          SizedBox(width: 10.w),
                          IconButton(
                            onPressed: () {
                              if (seatCount > 1) {
                                setState(() {
                                  seatCount--;
                                  updatePassengerList();
                                });
                              }
                            },
                            icon: Icon(Icons.remove_circle,
                                color: Colors.redAccent),
                          ),
                          Text('$seatCount',
                              style: GoogleFonts.roboto(
                                  fontSize: 18.sp, color: Colors.white)),
                          IconButton(
                            onPressed: () {
                              if (seatCount < 5) {
                                setState(() {
                                  seatCount++;
                                  updatePassengerList();
                                });
                              }
                            },
                            icon: Icon(Icons.add_circle,
                                color: Colors.greenAccent),
                          ),
                        ],
                      ),
                    ),
                    ...List.generate(seatCount, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(150, 0, 30, 0),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              Text('Passenger ${index + 1}',
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow)),
                              CustTextFormField(
                                label: 'Full Name',
                                hint: 'Enter Full Name',
                                controller: passengerControllers[index]['name'],
                              ),
                              // DropdownButtonFormField<String>(
                              //   value: passengerControllers[index]['gender']!
                              //           .text
                              //           .isNotEmpty
                              //       ? passengerControllers[index]['gender']!
                              //           .text
                              //       : 'null',
                              //   decoration: InputDecoration(
                              //     label: Text(
                              //       'Gender',
                              //       style: TextStyle(color: Colors.white),
                              //     ),
                              //     fillColor: Colors
                              //         .black, // Background color of the dropdown
                              //     hintText: 'Not Selected',
                              //     hintStyle:
                              //         const TextStyle(color: Colors.grey),

                              //     enabledBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(
                              //         color: Colors
                              //             .grey, // Underline color when enabled
                              //         width: 1.0, // Underline width
                              //       ),
                              //     ),
                              //     focusedBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(
                              //         color: const Color.fromARGB(255, 123, 100,
                              //             22), // Underline color when focused
                              //         width: 2.0, // Underline width
                              //       ),
                              //     ),
                              //   ),
                              //   dropdownColor: Color.fromARGB(180, 0, 30, 0),
                              //   items: [
                              //     DropdownMenuItem(
                              //       value: 'male',
                              //       child: Text(
                              //         'Male',
                              //         style: TextStyle(
                              //             color: Color.fromARGB(
                              //                 255, 95, 176, 241)),
                              //       ),
                              //     ),
                              //     DropdownMenuItem(
                              //       value: 'female',
                              //       child: Text(
                              //         'Female',
                              //         style: TextStyle(
                              //             color: Color.fromARGB(
                              //                 255, 255, 109, 157)),
                              //       ),
                              //     ),
                              //     DropdownMenuItem(
                              //         value: 'other',
                              //         child: Text(
                              //           'Other',
                              //           style: TextStyle(
                              //             color: Colors.yellow,
                              //           ),
                              //         ))
                              //   ],
                              //   onChanged: (String? value) {
                              //     setState(() {
                              //       passengerControllers[index]['gender']!
                              //           .text = value!;
                              //     });
                              //   },
                              //   validator: (value) => value == null
                              //       ? 'Please select a gender'
                              //       : ' ',
                              // ),
                              DropdownButtonFormField<String>(
                                value: passengerControllers[index]['gender']!
                                        .text
                                        .isEmpty
                                    ? null
                                    : passengerControllers[index]['gender']!
                                        .text,
                                decoration: InputDecoration(
                                  label: Text(
                                    'Gender',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  fillColor: Colors
                                      .black, // Background color of the dropdown
                                  hintText: 'Not Selected',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),

                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors
                                          .grey, // Underline color when enabled
                                      width: 1.0, // Underline width
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 123, 100,
                                          22), // Underline color when focused
                                      width: 2.0, // Underline width
                                    ),
                                  ),
                                ),
                                dropdownColor: Color.fromARGB(180, 0, 30, 0),
                                borderRadius: BorderRadius.circular(15.r),
                                items: ['male', 'female', 'other']
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(
                                            e[0].toUpperCase() + e.substring(1),
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 95, 176, 241)),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    passengerControllers[index]['gender']!
                                        .text = value ?? '';
                                  });
                                },
                              ),
                              CustTextFormField(
                                label: 'CNIC/Form B/Passport No.',
                                hint: 'Enter ID Number',
                                controller: passengerControllers[index]['id'],
                              ),
                              CustTextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                label: 'Age',
                                hint: '18',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your age';
                                  }
                                  final age = int.tryParse(value);
                                  if (age == null || age <= 0 || age > 130) {
                                    return 'Invalid age, it should be between 13 and 130';
                                  }
                                  if (age < 13) {
                                    return 'You are underage'; // Not eligible
                                  }
                                  return null;
                                },
                                controller: passengerControllers[index]['age'],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 20),
                    Text(
                      "Total Price: $totalPrice PKR",
                      style: TextStyle(fontSize: 18, color: Colors.greenAccent),
                    ),
                    SizedBox(height: 20),
                    CustomElevatedButton(
                      onPressed: submitBooking,
                      child: Text("Book Now 🎟️"),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
