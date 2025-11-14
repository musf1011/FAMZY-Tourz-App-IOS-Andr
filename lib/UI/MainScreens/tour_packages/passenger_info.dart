import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/UI/MainScreens/MainScreen.dart';
import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
import 'package:famzy_tourz_app/contstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:famzy_tourz_app/Utilities/CustTFField.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';

class PassengerInfoScreen extends StatefulWidget {
  final String destination;
  final String bgImage;
  final Map<String, dynamic> packageDetails;
  final int seatCount;

  const PassengerInfoScreen({
    super.key,
    required this.destination,
    required this.bgImage,
    required this.packageDetails,
    required this.seatCount,
  });

  @override
  State<PassengerInfoScreen> createState() => _PassengerInfoScreenState();
}

class _PassengerInfoScreenState extends State<PassengerInfoScreen> {
  int seatCount = 1;
  List<Map<String, TextEditingController>> passengerControllers = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
      'id': TextEditingController(text: data?['idNumber'].toString() ?? ''),
      'age': TextEditingController(text: data?['age'].toString() ?? ''),
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
    if (!_formKey.currentState!.validate()) {
      ToastPopUp().toastPopUp("Please fill all passengers details", Colors.red);
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      for (var passenger in passengerControllers) {
        final id = passenger['id']!.text.trim();
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

      ToastPopUp().toastPopUp('Booking submitted successfully!', Colors.green);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    } catch (e) {
      ToastPopUp().toastPopUp('Error: $e', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pricePerPerson =
        int.tryParse(widget.packageDetails['price'].toString()) ?? 0;
    final totalPrice = pricePerPerson * seatCount;

    return Scaffold(
      body: isLoading
          ? Center(child: SpinKitFadingCircle(color: Colors.yellow, size: 70))
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_circle_left_outlined,
                                size: 40.h, color: AppConstants.transGColor),
                          ),
                          SizedBox(width: .15.sw),
                          Image.asset(
                            "asset/images/FAMZYLogo.png",
                            width: .4.sw,
                            height: .1.sh,
                          ),
                        ],
                      ),
                      Text(widget.destination,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryColor,
                              background: Paint()..color = Colors.white30)),
                      SizedBox(height: 10.h),
                      Container(
                        width: 0.5.sw,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: AppConstants.transGColor,
                          borderRadius: BorderRadius.circular(25.r),
                          border: Border.all(color: Colors.white, width: 2.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Seats:",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp, color: Colors.white)),
                            IconButton(
                              icon: Icon(Icons.remove_circle,
                                  color: Colors.redAccent),
                              onPressed: () {
                                if (seatCount > 1) {
                                  setState(() {
                                    seatCount--;
                                    updatePassengerList();
                                  });
                                }
                              },
                            ),
                            Text('$seatCount',
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp, color: Colors.white)),
                            IconButton(
                              icon: Icon(Icons.add_circle,
                                  color: AppConstants.tertiaryColor),
                              onPressed: () {
                                if (seatCount < 5) {
                                  setState(() {
                                    seatCount++;
                                    updatePassengerList();
                                  });
                                }
                              },
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
                              color: AppConstants.transGColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Passenger ${index + 1}',
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow)),
                                CustTextFormField(
                                  label: 'Full Name',
                                  hint: 'Enter Full Name',
                                  controller: passengerControllers[index]
                                      ['name'],
                                  validator: (val) => val == null || val.isEmpty
                                      ? 'Required'
                                      : null,
                                ),
                                DropdownButtonFormField<String>(
                                  initialValue: passengerControllers[index]
                                              ['gender']!
                                          .text
                                          .isEmpty
                                      ? null
                                      : passengerControllers[index]['gender']!
                                          .text,
                                  decoration: InputDecoration(
                                    labelText: 'Gender',
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  dropdownColor: AppConstants.transGColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  items: ['male', 'female', 'other']
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e[0].toUpperCase() +
                                                  e.substring(1),
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) => setState(() =>
                                      passengerControllers[index]['gender']!
                                          .text = value ?? ''),
                                  validator: (val) => val == null || val.isEmpty
                                      ? 'Required'
                                      : null,
                                ),
                                CustTextFormField(
                                  label: 'CNIC/Form B/Passport No.',
                                  hint: 'Enter ID Number',
                                  keyboardType: TextInputType.number,
                                  controller: passengerControllers[index]['id'],
                                  validator: (val) => val == null ||
                                          val.isEmpty ||
                                          val == 'null'
                                      ? 'Required'
                                      : null, // Example format
                                ),
                                CustTextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  label: 'Age',
                                  hint: 'e.g. 18',
                                  controller: passengerControllers[index]
                                      ['age'],
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Required';
                                    }
                                    final age = int.tryParse(val);
                                    if (age == null || age < 1 || age > 130) {
                                      return 'Invalid age';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 20),
                      Text("Total: $totalPrice PKR",
                          style: GoogleFonts.roboto(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              backgroundColor: AppConstants.transGColor)),
                      SizedBox(height: 20),
                      CustomElevatedButton(
                        onPressed: submitBooking,
                        child: Text("Book Now 🎟️"),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
